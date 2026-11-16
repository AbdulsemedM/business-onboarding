// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FastPay Business';

  @override
  String get welcomeTitle => 'Become a FastPay merchant';

  @override
  String get welcomeBody =>
      'Tell us about your business, upload a few documents, and we\'ll review your application. Your progress is saved on this device so you can finish later.';

  @override
  String get startApplication => 'Start application';

  @override
  String get continueApplication => 'Continue application';

  @override
  String get stepBusinessTitle => 'Business details';

  @override
  String get stepDocumentsTitle => 'Documents';

  @override
  String get stepComplianceTitle => 'Operations and compliance';

  @override
  String get stepReviewTitle => 'Review and submit';

  @override
  String stepUpNext(String title) {
    return 'Next: $title';
  }

  @override
  String stepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String stepProgressSemantics(int current, int total, String title) {
    return 'Step $current of $total: $title';
  }

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get submit => 'Submit';

  @override
  String get comingSoon => 'This section is coming soon.';

  @override
  String get statusTitle => 'Application status';

  @override
  String get fixErrorsMessage => 'Please fix the highlighted fields.';

  @override
  String get errorRequired => 'This field is required';

  @override
  String get errorSelectDay => 'Select at least one day';

  @override
  String get errorSameTimes =>
      'Closing time must be different from opening time';

  @override
  String get errorYearsRange => 'Enter a number from 0 to 99';

  @override
  String get errorMonthsRange => 'Enter a number from 0 to 11';

  @override
  String get errorPhoneInvalid =>
      'Enter a valid phone number for the selected country';

  @override
  String get errorEinFormat => 'Enter a 9-digit EIN (XX-XXXXXXX)';

  @override
  String get errorSsnFormat => 'Enter a 9-digit SSN (XXX-XX-XXXX)';

  @override
  String get countrySearchLabel => 'Search by country code or dial code';

  @override
  String phoneCountryButton(String isoCode, String dialCode) {
    return 'Country $isoCode, dial code plus $dialCode. Change country';
  }

  @override
  String get step1OwnerSection => 'Business owner';

  @override
  String get step1OwnerHelp =>
      'The owner is partner 1 when you upload IDs in the next step.';

  @override
  String get step1OwnerFirstName => 'Owner first name';

  @override
  String get step1OwnerLastName => 'Owner last name';

  @override
  String get step1AddressSection => 'Business location address';

  @override
  String get step1AddressLine1 => 'Street address';

  @override
  String get step1AddressLine2 => 'Apt, suite, or unit (optional)';

  @override
  String get step1City => 'City';

  @override
  String get step1Region => 'State or region (optional)';

  @override
  String get step1PostalCode => 'ZIP or postal code (optional)';

  @override
  String get step1Country => 'Country';

  @override
  String step1CountryButton(String isoCode) {
    return 'Country $isoCode. Change country';
  }

  @override
  String get step1SubtenantToggle =>
      'I sublease this location from another business';

  @override
  String get step1HoursSection => 'Days and hours of operation';

  @override
  String get step1DaysLabel => 'Open on';

  @override
  String get step1OpensAt => 'Opens at';

  @override
  String get step1ClosesAt => 'Closes at';

  @override
  String get step1LocationSection => 'Time at current location';

  @override
  String get step1Years => 'Years';

  @override
  String get step1Months => 'Months';

  @override
  String get step1PropertySection => 'Property status';

  @override
  String get step1BusinessProperty => 'Business location';

  @override
  String get step1ResidentialProperty => 'Residential home';

  @override
  String get propertyLease => 'Lease';

  @override
  String get propertyOwn => 'Own';

  @override
  String get step1ResidenceTimeSection => 'Time at residential home (optional)';

  @override
  String get step1BusinessLandlordSection => 'Business landlord';

  @override
  String get step1BusinessLandlordName => 'Business landlord name';

  @override
  String get step1BusinessLandlordPhone => 'Business landlord phone';

  @override
  String get step1ResidentialLandlordSection => 'Home landlord';

  @override
  String get step1ResidentialLandlordName => 'Home landlord name';

  @override
  String get step1ResidentialLandlordPhone => 'Home landlord phone';

  @override
  String get step1BankSection => 'Banking';

  @override
  String get step1BankName => 'Personal bank name';

  @override
  String get step1TaxSection => 'Business tax designation';

  @override
  String get step1EinLabel => 'Business EIN';

  @override
  String get step1SsnLabel => 'Owner\'s SSN';

  @override
  String get taxLlcSoleEinTitle =>
      'LLC (Sole Proprietorship / Single-Member LLC - EIN)';

  @override
  String get taxLlcSoleEinBody => 'Files under its own EIN.';

  @override
  String get taxLlcSoleSsnTitle =>
      'LLC (Sole Proprietorship / Single-Member LLC - SSN)';

  @override
  String get taxLlcSoleSsnBody =>
      'Disregarded entity. The owner reports on their personal return using their SSN.';

  @override
  String get taxLlcCCorpTitle => 'LLC (C-Corporation Election)';

  @override
  String get taxLlcCCorpBody => 'Taxed as a C-Corporation (IRS Form 8832).';

  @override
  String get taxLlcSCorpTitle => 'LLC (S-Corporation Election)';

  @override
  String get taxLlcSCorpBody => 'Taxed as an S-Corporation (IRS Form 2553).';

  @override
  String get cancel => 'Cancel';

  @override
  String get errorNetwork =>
      'No internet connection. Check your connection and try again.';

  @override
  String get errorTimeout => 'The connection timed out. Try again.';

  @override
  String get errorUnauthorized =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorValidation =>
      'This couldn\'t be accepted. Check it and try again.';

  @override
  String get errorServer => 'Something went wrong on our side. Try again.';

  @override
  String get errorUnknown => 'Something went wrong. Try again.';

  @override
  String fileSizeKb(String size) {
    return '$size KB';
  }

  @override
  String fileSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get docStatusNotUploaded => 'Not uploaded';

  @override
  String get docStatusPreparing => 'Preparing';

  @override
  String get docStatusUploading => 'Uploading';

  @override
  String get docStatusUploaded => 'Uploaded';

  @override
  String get docStatusFailed => 'Upload failed';

  @override
  String get docStatusRejected => 'Rejected';

  @override
  String docStatusSemantics(String document, String status) {
    return '$document: $status';
  }

  @override
  String get docPreparing => 'Preparing file…';

  @override
  String docUploadingProgress(int percent) {
    return 'Uploading $percent%';
  }

  @override
  String docRejectedReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get docCurrentFileNote => 'Your previous file is still on record.';

  @override
  String get docAdd => 'Add document';

  @override
  String get docReplace => 'Replace';

  @override
  String get docRemove => 'Remove';

  @override
  String get docRetry => 'Retry';

  @override
  String get docChooseAnother => 'Choose another file';

  @override
  String get docOpenSettings => 'Open settings';

  @override
  String docActionFor(String action, String document) {
    return '$action: $document';
  }

  @override
  String get docSourceTitle => 'Add document';

  @override
  String get docSourceCamera => 'Take a photo';

  @override
  String get docSourceGallery => 'Choose from photos';

  @override
  String get docSourceFiles => 'Choose a file (PDF, JPG or PNG)';

  @override
  String get docCameraHintTitle => 'Before you take the photo';

  @override
  String get docOpenCamera => 'Open camera';

  @override
  String docErrorTooLarge(String maxSize) {
    return 'This file is too large. The maximum size is $maxSize.';
  }

  @override
  String get docErrorUnsupported =>
      'This file type isn\'t supported. Use PDF, JPG or PNG.';

  @override
  String get docErrorUnreadable =>
      'We couldn\'t read this file. Try another one.';

  @override
  String get docErrorPermission =>
      'FastPay needs access to your camera or photos. You can allow it in Settings.';

  @override
  String get docErrorRequired => 'Upload this document';

  @override
  String get step2Intro =>
      'Upload clear photos or scans. Accepted file types: PDF, JPG and PNG.';

  @override
  String get step2IdSection => 'Personal ID';

  @override
  String get step2IdHelp =>
      'Every business partner needs a valid government ID, driver\'s license, or passport.';

  @override
  String get step2OwnerHeading => 'Partner 1 (owner)';

  @override
  String get step2PartnerFirstName => 'First name (as on ID)';

  @override
  String get step2PartnerLastName => 'Last name (as on ID)';

  @override
  String step2OwnerName(String name) {
    return '$name, from business details';
  }

  @override
  String step2PartnerHeading(int number) {
    return 'Partner $number';
  }

  @override
  String step2RemovePartner(int number) {
    return 'Remove partner $number';
  }

  @override
  String get step2RemovePartnerBody =>
      'Their ID and utility bill will be removed from this application.';

  @override
  String get step2RemoveConfirm => 'Remove';

  @override
  String get step2AddPartner => 'Add partner';

  @override
  String get step2IdTypeLabel => 'Type of ID';

  @override
  String get idTypeGovernmentId => 'Government-issued ID card';

  @override
  String get idTypeDriversLicense => 'Driver\'s license';

  @override
  String get idTypePassport => 'Passport';

  @override
  String get idTypePassportNote => 'A home utility bill is also required.';

  @override
  String step2IdCard(int number) {
    return 'Partner $number: photo ID';
  }

  @override
  String get step2PoBoxToggle => 'This ID lists a P.O. Box address';

  @override
  String get step2PoBoxNote => 'If so, we also need a home utility bill.';

  @override
  String step2HomeBillCard(int number) {
    return 'Partner $number: home utility bill';
  }

  @override
  String get step2HomeBillHelp =>
      'Needed because the ID is a passport or lists a P.O. Box. It must show the home address and be dated within the last 60 days.';

  @override
  String get step2BillDate => 'Bill date';

  @override
  String get errorBillDateFuture => 'The bill date can\'t be in the future';

  @override
  String get errorBillOlderThan60Days =>
      'The bill must be dated within the last 60 days';

  @override
  String get errorBillOlderThan90Days =>
      'The bill must be dated within the last 90 days';

  @override
  String get step2RegistrationSection => 'Business registration';

  @override
  String get step2RegistrationHelp =>
      'The business must be in good standing with the Secretary of State. Which document do you have?';

  @override
  String get regArticlesOfOrganization => 'Articles of Organization (LLC)';

  @override
  String get regArticlesOfIncorporation =>
      'Articles of Incorporation (corporation)';

  @override
  String get step2IrsSection => 'IRS registration';

  @override
  String get step2IrsHelp => 'Upload one of these.';

  @override
  String get irsEinForm => 'EIN form (Form SS-4 or equivalent)';

  @override
  String get irsSs4Letter => 'IRS SS-4 letter';

  @override
  String get irsRecentTaxReturn => 'Recent tax return';

  @override
  String get step2LicenseSection => 'Business license or permit';

  @override
  String get step2LicenseHelp => 'Upload one document. Choose its type first.';

  @override
  String get step2LicenseTypeLabel => 'License or permit type';

  @override
  String get licenseGeneralBusiness => 'General business license';

  @override
  String get licenseSalesTaxPermit => 'Sales tax permit';

  @override
  String get licenseFood => 'Food license';

  @override
  String get licenseLiquor => 'Liquor license';

  @override
  String get licenseTobacco => 'Tobacco license';

  @override
  String get licenseLottery => 'Lottery license';

  @override
  String get licenseHealthDept => 'Health department permit';

  @override
  String get licenseCertificateOfOccupancy => 'Certificate of occupancy';

  @override
  String get licenseFireInspection => 'Fire inspection';

  @override
  String get licenseFoodInspection => 'Food inspection';

  @override
  String get licenseDotRegistration => 'DOT registration';

  @override
  String get licenseCommercialAutoInsurance => 'Commercial auto insurance';

  @override
  String get licenseCommercialVehicleRegistration =>
      'Commercial vehicle registration';

  @override
  String get licenseGeneralTitle =>
      'General business license or sales tax permit';

  @override
  String get licenseIndustryTitle => 'Industry-specific permit';

  @override
  String get licenseIndustryBody =>
      'Food, liquor, tobacco, lottery, health department, etc.';

  @override
  String get licensePropertySafetyTitle => 'Property or safety certificate';

  @override
  String get licensePropertySafetyBody =>
      'Certificate of occupancy, fire inspection, food inspection.';

  @override
  String get licenseTransportationTitle => 'Transportation';

  @override
  String get licenseTransportationBody =>
      'DOT registration, commercial auto insurance, commercial vehicle registration.';

  @override
  String get step2LicenseCard => 'License or permit';

  @override
  String get step2BusinessBillSection => 'Business utility bill';

  @override
  String get step2BusinessBillCard => 'Business utility bill';

  @override
  String get step2BusinessBillHelp =>
      'Must show the business address and be dated within the last 90 days.';

  @override
  String get step2PhotosSection => 'Business photos';

  @override
  String get step2PhotosHelp =>
      'Three photos are required. You can add a fourth.';

  @override
  String get photoExteriorTitle => 'Exterior';

  @override
  String get photoExteriorHelp =>
      'Show the entrance, business name, and street number clearly.';

  @override
  String get photoExteriorCameraHint =>
      'Show the entrance, business name, and street number.';

  @override
  String get photoInteriorLayoutTitle => 'Interior: store layout';

  @override
  String get photoInteriorLayoutHelp => 'Show the full store layout.';

  @override
  String get photoCheckoutTitle => 'Interior: checkout area';

  @override
  String get photoCheckoutHelp => 'Show the transaction or checkout area.';

  @override
  String get photoAdditionalTitle => 'Additional photo (optional)';

  @override
  String get photoAdditionalHelp =>
      'Any other view that helps us verify your business.';

  @override
  String get step2OtherSection => 'Trade name and sublease';

  @override
  String get step2DbaToggle => 'My business uses a trade name (DBA)';

  @override
  String get step2DbaNote =>
      'We verify your trade name from your business photos. Make sure it is clearly visible in the exterior photo.';

  @override
  String get step2TradeName => 'Trade name (DBA)';

  @override
  String get step2DbaCard => 'DBA documentation (optional)';

  @override
  String get step2DbaCardHelp =>
      'For example, your trade name filing or certificate.';

  @override
  String get step2SubleaseCard => 'Sublease agreement';

  @override
  String get step2SubleaseHelp =>
      'Required because you said you sublease this location.';

  @override
  String get step3ProcessorsSection => 'Transaction processors';

  @override
  String get step3ProcessorsHelp =>
      'Everyone who will process transactions. We use these names to set up their logins and compliance training.';

  @override
  String step3ProcessorHeading(int number) {
    return 'Processor $number';
  }

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String step3RemoveProcessor(int number) {
    return 'Remove processor $number';
  }

  @override
  String get step3AddProcessor => 'Add processor';

  @override
  String get step3OfficerSection => 'Compliance Officer';

  @override
  String get step3OfficerHelp =>
      'The person responsible for compliance at your business.';

  @override
  String get step3OfficerSameAsOwner => 'Same as owner';

  @override
  String step3OfficerOwnerName(String name) {
    return 'Owner: $name';
  }

  @override
  String get step3OfficerOwnerUnknown =>
      'The owner you entered in Business details.';

  @override
  String get step3OfficerFirstName => 'Compliance Officer first name';

  @override
  String get step3OfficerLastName => 'Compliance Officer last name';
}
