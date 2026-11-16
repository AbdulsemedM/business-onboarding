import 'dart:convert';
import 'dart:io';

import 'package:business_onboarding/core/storage/draft_store.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_step.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory dir;
  late Box<String> box;
  late HiveDraftStore store;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('draft_store_test');
    Hive.init(dir.path);
    box = await Hive.openBox<String>(HiveDraftStore.boxName);
    store = HiveDraftStore(box);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await Hive.close();
    await dir.delete(recursive: true);
  });

  const a = OnboardingDraft(
    applicationId: 'app-a',
    currentStep: OnboardingStep.compliance,
  );
  const b = OnboardingDraft(
    applicationId: 'app-b',
    currentStep: OnboardingStep.documents,
  );

  test('returns null when nothing is saved', () async {
    expect(await store.load('app-a'), isNull);
  });

  test('keeps one draft per application', () async {
    await store.save(a);
    await store.save(b);
    expect(await store.load('app-a'), a);
    expect(await store.load('app-b'), b);
  });

  test('does not save a draft without an application', () async {
    await store.save(const OnboardingDraft());
    expect(box.isEmpty, isTrue);
  });

  test('clear removes only that application draft', () async {
    await store.save(a);
    await store.save(b);
    await store.clear('app-a');
    expect(await store.load('app-a'), isNull);
    expect(await store.load('app-b'), b);
  });

  test('clearAll removes every draft', () async {
    await store.save(a);
    await store.save(b);
    await store.clearAll();
    expect(box.isEmpty, isTrue);
  });

  test('retainOnly drops drafts of other applications', () async {
    await store.save(a);
    await store.save(b);
    await store.retainOnly({'app-b'});
    expect(await store.load('app-a'), isNull);
    expect(await store.load('app-b'), b);
  });

  group('draft from an older build', () {
    test('without an id goes to the first application opened', () async {
      await box.put('current', jsonEncode(const OnboardingDraft().toJson()));
      expect(
        await store.load('app-a'),
        const OnboardingDraft(applicationId: 'app-a'),
      );
      expect(box.containsKey('current'), isFalse);
    });

    test('with an id moves under that application', () async {
      await box.put('current', jsonEncode(b.toJson()));
      expect(await store.load('app-a'), isNull);
      expect(await store.load('app-b'), b);
    });
  });

  test('discards unreadable data', () async {
    await box.put('app:app-a', 'not json');
    expect(await store.load('app-a'), isNull);
    expect(box.isEmpty, isTrue);
  });

  test('discards drafts from another schema version', () async {
    await store.save(
      const OnboardingDraft(applicationId: 'app-a', schemaVersion: -1),
    );
    expect(await store.load('app-a'), isNull);
  });
}
