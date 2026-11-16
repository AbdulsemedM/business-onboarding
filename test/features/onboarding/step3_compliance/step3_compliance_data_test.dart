import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/step3_compliance/data/step3_compliance_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/sample_data.dart';

void main() {
  test('starts with one processor and the owner as officer', () {
    const data = Step3ComplianceData();
    expect(data.processors, hasLength(1));
    expect(data.complianceOfficerIsOwner, isTrue);
  });

  test('processors are added, updated and removed by id', () {
    var data = const Step3ComplianceData().withProcessorAdded('p2');
    data = data.withProcessorUpdated('p2', (p) => p.copyWith(firstName: 'Jo'));
    expect(data.processors.map((p) => p.firstName), [null, 'Jo']);

    data = data.withProcessorRemoved(Step3ComplianceData.firstProcessorId);
    expect(data.processors.single.id, 'p2');
  });

  test('survives a JSON round trip inside the draft', () {
    const draft = OnboardingDraft(compliance: completeStep3);
    expect(OnboardingDraft.fromJson(draft.toJson()), draft);
  });

  test('drafts saved before Step 3 existed still load', () {
    final json = const OnboardingDraft().toJson()..remove('compliance');
    expect(
      OnboardingDraft.fromJson(json).compliance,
      const Step3ComplianceData(),
    );
  });
}
