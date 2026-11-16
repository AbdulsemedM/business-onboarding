import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';

import '../../features/onboarding/data/models/onboarding_draft.dart';
import '../utils/safe_log.dart';

/// Saves in-progress applications on the device so the user can resume.
///
/// An account can have several applications, so there is one draft per
/// application, keyed by [OnboardingDraft.applicationId].
abstract interface class DraftStore {
  /// The draft for [applicationId]. A draft saved before drafts were kept
  /// per application (no id) is handed over to the first application asked
  /// for.
  Future<OnboardingDraft?> load(String applicationId);

  /// Saves under the draft's own `applicationId`.
  Future<void> save(OnboardingDraft draft);

  Future<void> clear(String applicationId);

  /// Removes every draft (sign out: drafts hold personal data).
  Future<void> clearAll();

  /// Removes drafts for applications not in [applicationIds], e.g. ones left
  /// by another account on this device.
  Future<void> retainOnly(Set<String> applicationIds);
}

/// Stores the draft as JSON in an encrypted Hive box. The encryption key is
/// kept in secure storage.
class HiveDraftStore implements DraftStore {
  HiveDraftStore(this._box);

  static const boxName = 'onboarding_drafts';

  /// Where older builds kept their single draft.
  static const _legacyKey = 'current';
  static const _encryptionKeyName = 'draft_box_key';

  final Box<String> _box;

  static Future<HiveDraftStore> open(FlutterSecureStorage secureStorage) async {
    final cipher = HiveAesCipher(await _encryptionKey(secureStorage));
    try {
      return HiveDraftStore(
        await Hive.openBox<String>(boxName, encryptionCipher: cipher),
      );
    } catch (_) {
      // The key no longer matches the box (for example after a restore).
      // The draft cannot be read, so start again with an empty box.
      safeLog('Draft box unreadable, resetting');
      await Hive.deleteBoxFromDisk(boxName);
      return HiveDraftStore(
        await Hive.openBox<String>(boxName, encryptionCipher: cipher),
      );
    }
  }

  static Future<List<int>> _encryptionKey(FlutterSecureStorage storage) async {
    final existing = await storage.read(key: _encryptionKeyName);
    if (existing != null) return base64Url.decode(existing);
    final key = Hive.generateSecureKey();
    await storage.write(key: _encryptionKeyName, value: base64UrlEncode(key));
    return key;
  }

  @override
  Future<OnboardingDraft?> load(String applicationId) async {
    final key = _keyFor(applicationId);
    if (_box.containsKey(key)) return _read(key);
    // Older builds kept a single draft. Move it under its own application;
    // one saved before drafts had an id goes to this application.
    final legacy = await _read(_legacyKey);
    if (legacy == null) return null;
    await _box.delete(_legacyKey);
    final moved = legacy.applicationId == null
        ? legacy.copyWith(applicationId: applicationId)
        : legacy;
    await save(moved);
    return moved.applicationId == applicationId ? moved : null;
  }

  Future<OnboardingDraft?> _read(String key) async {
    final raw = _box.get(key);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final draft = OnboardingDraft.fromJson(json);
      if (draft.schemaVersion != OnboardingDraft.currentSchemaVersion) {
        safeLog('Draft schema changed, discarding');
        await _box.delete(key);
        return null;
      }
      return draft;
    } catch (_) {
      safeLog('Draft unreadable, discarding');
      await _box.delete(key);
      return null;
    }
  }

  @override
  Future<void> save(OnboardingDraft draft) {
    final id = draft.applicationId;
    // Every draft belongs to an application; one without an id has nowhere
    // to go and would never be loaded.
    if (id == null) return Future.value();
    return _box.put(_keyFor(id), jsonEncode(draft.toJson()));
  }

  @override
  Future<void> clear(String applicationId) =>
      _box.delete(_keyFor(applicationId));

  @override
  Future<void> clearAll() => _box.clear();

  @override
  Future<void> retainOnly(Set<String> applicationIds) async {
    final keep = applicationIds.map(_keyFor).toSet();
    final stale = _box.keys.where((k) => !keep.contains(k)).toList();
    if (stale.isNotEmpty) await _box.deleteAll(stale);
  }

  static String _keyFor(String applicationId) => 'app:$applicationId';
}
