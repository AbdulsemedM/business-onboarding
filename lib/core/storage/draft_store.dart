import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';

import '../../features/onboarding/data/models/onboarding_draft.dart';
import '../utils/safe_log.dart';

/// Saves the in-progress application on the device so the user can resume.
abstract interface class DraftStore {
  Future<OnboardingDraft?> load();
  Future<void> save(OnboardingDraft draft);
  Future<void> clear();
}

/// Stores the draft as JSON in an encrypted Hive box. The encryption key is
/// kept in secure storage.
class HiveDraftStore implements DraftStore {
  HiveDraftStore(this._box);

  static const boxName = 'onboarding_drafts';
  static const _draftKey = 'current';
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
  Future<OnboardingDraft?> load() async {
    final raw = _box.get(_draftKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final draft = OnboardingDraft.fromJson(json);
      if (draft.schemaVersion != OnboardingDraft.currentSchemaVersion) {
        safeLog('Draft schema changed, discarding');
        await clear();
        return null;
      }
      return draft;
    } catch (_) {
      safeLog('Draft unreadable, discarding');
      await clear();
      return null;
    }
  }

  @override
  Future<void> save(OnboardingDraft draft) =>
      _box.put(_draftKey, jsonEncode(draft.toJson()));

  @override
  Future<void> clear() => _box.delete(_draftKey);
}
