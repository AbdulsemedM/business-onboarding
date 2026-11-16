import '../../../../l10n/app_localizations.dart';
import '../data/step2_documents_data.dart';

/// Display names for the Step 2 document types. Shared with the review
/// screen.

String registrationLabel(AppLocalizations l10n, RegistrationDocType type) =>
    switch (type) {
      RegistrationDocType.articlesOfOrganization =>
        l10n.regArticlesOfOrganization,
      RegistrationDocType.articlesOfIncorporation =>
        l10n.regArticlesOfIncorporation,
    };

String irsLabel(AppLocalizations l10n, IrsDocType type) => switch (type) {
  IrsDocType.einForm => l10n.irsEinForm,
  IrsDocType.ss4Letter => l10n.irsSs4Letter,
  IrsDocType.recentTaxReturn => l10n.irsRecentTaxReturn,
};

String licenseLabel(AppLocalizations l10n, LicenseType type) => switch (type) {
  LicenseType.generalBusinessLicense => l10n.licenseGeneralBusiness,
  LicenseType.salesTaxPermit => l10n.licenseSalesTaxPermit,
  LicenseType.foodLicense => l10n.licenseFood,
  LicenseType.liquorLicense => l10n.licenseLiquor,
  LicenseType.tobaccoLicense => l10n.licenseTobacco,
  LicenseType.lotteryLicense => l10n.licenseLottery,
  LicenseType.healthDeptPermit => l10n.licenseHealthDept,
  LicenseType.certificateOfOccupancy => l10n.licenseCertificateOfOccupancy,
  LicenseType.fireInspection => l10n.licenseFireInspection,
  LicenseType.foodInspection => l10n.licenseFoodInspection,
  LicenseType.dotRegistration => l10n.licenseDotRegistration,
  LicenseType.commercialAutoInsurance => l10n.licenseCommercialAutoInsurance,
  LicenseType.commercialVehicleRegistration =>
    l10n.licenseCommercialVehicleRegistration,
};
