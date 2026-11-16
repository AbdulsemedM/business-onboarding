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

  test('returns null when nothing is saved', () async {
    expect(await store.load(), isNull);
  });

  test('saves and loads a draft', () async {
    const draft = OnboardingDraft(currentStep: OnboardingStep.compliance);
    await store.save(draft);
    expect(await store.load(), draft);
  });

  test('clear removes the draft', () async {
    await store.save(const OnboardingDraft());
    await store.clear();
    expect(await store.load(), isNull);
  });

  test('discards unreadable data', () async {
    await box.put('current', 'not json');
    expect(await store.load(), isNull);
    expect(box.isEmpty, isTrue);
  });

  test('discards drafts from another schema version', () async {
    await store.save(const OnboardingDraft(schemaVersion: -1));
    expect(await store.load(), isNull);
  });
}
