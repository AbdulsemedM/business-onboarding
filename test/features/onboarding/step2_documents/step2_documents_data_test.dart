import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/step2_documents/data/step2_documents_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/sample_data.dart';

void main() {
  test('starts with one partner', () {
    expect(const Step2DocumentsData().partners, hasLength(1));
  });

  test('home utility bill is required for a passport or a P.O. Box', () {
    const partner = PartnerDocuments(id: 'p');
    expect(partner.homeUtilityBillRequired, isFalse);
    expect(
      partner.copyWith(idType: PersonalIdType.passport).homeUtilityBillRequired,
      isTrue,
    );
    expect(
      partner
          .copyWith(idType: PersonalIdType.driversLicense, idShowsPoBox: true)
          .homeUtilityBillRequired,
      isTrue,
    );
  });

  test('partners can be added, updated and removed by id', () {
    var data = const Step2DocumentsData().withPartnerAdded('p2');
    data = data.withPartnerUpdated(
      'p2',
      (p) => p.copyWith(idType: PersonalIdType.passport),
    );
    expect(data.partners.map((p) => p.id), [
      Step2DocumentsData.firstPartnerId,
      'p2',
    ]);
    expect(data.partners.last.idType, PersonalIdType.passport);
    expect(data.partners.first.idType, isNull);

    data = data.withPartnerRemoved('p2');
    expect(data.partners, hasLength(1));
  });

  test('survives a JSON round trip inside the draft', () {
    final draft = OnboardingDraft(
      documents: completeStep2().copyWith(
        subleaseAgreement: uploaded('sublease'),
      ),
    );
    expect(OnboardingDraft.fromJson(draft.toJson()), draft);
  });

  test('drafts saved before Step 2 existed still load', () {
    final json = const OnboardingDraft().toJson()..remove('documents');
    expect(
      OnboardingDraft.fromJson(json).documents,
      const Step2DocumentsData(),
    );
  });
}
