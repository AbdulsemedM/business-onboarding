import 'package:business_onboarding/features/documents/data/models/uploaded_document.dart';
import 'package:business_onboarding/features/onboarding/step1_business/data/step1_business_data.dart';
import 'package:business_onboarding/features/onboarding/step2_documents/data/step2_documents_data.dart';
import 'package:business_onboarding/features/onboarding/step3_compliance/data/step3_compliance_data.dart';

/// A Step 1 answer set that passes validation.
const completeStep1 = Step1BusinessData(
  ownerFirstName: 'Alex',
  ownerLastName: 'Owner',
  openDays: [1, 2, 3, 4, 5],
  opensAt: 9 * 60,
  closesAt: 17 * 60,
  addressLine1: '100 Market St',
  city: 'Austin',
  yearsAtLocation: 3,
  monthsAtLocation: 4,
  businessProperty: PropertyStatus.own,
  residentialProperty: PropertyStatus.own,
  bankName: 'Test Bank',
  taxDesignation: TaxDesignation.llcSoleEin,
  taxId: '123456789',
);

/// A real, valid US number (Google HQ), used only in tests.
const validUsPhone = '650 253 0000';

UploadedDocument uploaded(String name) => UploadedDocument(
  id: 'id-$name',
  fileName: '$name.pdf',
  mimeType: 'application/pdf',
  sizeBytes: 1024,
);

/// [daysAgo] days before today, as a date with no time.
DateTime daysAgo(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day - days);
}

/// A Step 2 answer set that passes validation: one partner (the Step 1
/// owner, so no name here) with a driver's license, no DBA, no sublease.
Step2DocumentsData completeStep2() => Step2DocumentsData(
  partners: [
    PartnerDocuments(
      id: Step2DocumentsData.firstPartnerId,
      idType: PersonalIdType.driversLicense,
      idDocument: uploaded('id'),
    ),
  ],
  registrationType: RegistrationDocType.articlesOfOrganization,
  businessRegistration: uploaded('articles'),
  irsType: IrsDocType.einForm,
  irsRegistration: uploaded('ein'),
  licenseCategory: LicenseCategory.general,
  licenseType: LicenseType.generalBusinessLicense,
  license: uploaded('license'),
  businessUtilityBill: uploaded('bill'),
  businessUtilityBillDate: daysAgo(10),
  exteriorPhoto: uploaded('exterior'),
  interiorLayoutPhoto: uploaded('interior'),
  checkoutPhoto: uploaded('checkout'),
);

/// A Step 3 answer set that passes validation: one processor, the owner is
/// the Compliance Officer.
const completeStep3 = Step3ComplianceData(
  processors: [
    TransactionProcessor(
      id: Step3ComplianceData.firstProcessorId,
      firstName: 'Sam',
      lastName: 'Cashier',
    ),
  ],
);
