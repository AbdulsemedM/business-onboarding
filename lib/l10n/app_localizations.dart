import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FastPay Business'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Become a FastPay merchant'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your business, upload a few documents, and we\'ll review your application. Your progress is saved on this device so you can finish later.'**
  String get welcomeBody;

  /// No description provided for @welcomeStepsHeading.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get welcomeStepsHeading;

  /// No description provided for @welcomeStep1Body.
  ///
  /// In en, this message translates to:
  /// **'Your details, address and tax information.'**
  String get welcomeStep1Body;

  /// No description provided for @welcomeStep2Body.
  ///
  /// In en, this message translates to:
  /// **'IDs, registration, license and photos.'**
  String get welcomeStep2Body;

  /// No description provided for @welcomeStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Who processes transactions and your compliance officer.'**
  String get welcomeStep3Body;

  /// No description provided for @welcomeStep4Body.
  ///
  /// In en, this message translates to:
  /// **'Check everything, then submit for review.'**
  String get welcomeStep4Body;

  /// No description provided for @welcomeSavedNote.
  ///
  /// In en, this message translates to:
  /// **'Your progress is saved on this device.'**
  String get welcomeSavedNote;

  /// No description provided for @startApplication.
  ///
  /// In en, this message translates to:
  /// **'Start application'**
  String get startApplication;

  /// No description provided for @continueApplication.
  ///
  /// In en, this message translates to:
  /// **'Continue application'**
  String get continueApplication;

  /// No description provided for @stepBusinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Business details'**
  String get stepBusinessTitle;

  /// No description provided for @stepDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get stepDocumentsTitle;

  /// No description provided for @stepComplianceTitle.
  ///
  /// In en, this message translates to:
  /// **'Operations and compliance'**
  String get stepComplianceTitle;

  /// No description provided for @stepReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review and submit'**
  String get stepReviewTitle;

  /// No description provided for @stepUpNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {title}'**
  String stepUpNext(String title);

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepProgress(int current, int total);

  /// No description provided for @stepProgressSemantics.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}: {title}'**
  String stepProgressSemantics(int current, int total, String title);

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'This section is coming soon.'**
  String get comingSoon;

  /// No description provided for @statusTitle.
  ///
  /// In en, this message translates to:
  /// **'Application status'**
  String get statusTitle;

  /// No description provided for @statusRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get statusRefresh;

  /// No description provided for @statusAppNumber.
  ///
  /// In en, this message translates to:
  /// **'Application {number}'**
  String statusAppNumber(String number);

  /// No description provided for @statusSubmittedOn.
  ///
  /// In en, this message translates to:
  /// **'Submitted {date}'**
  String statusSubmittedOn(String date);

  /// No description provided for @statusLabelDraft.
  ///
  /// In en, this message translates to:
  /// **'Not submitted'**
  String get statusLabelDraft;

  /// No description provided for @statusLabelInReview.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get statusLabelInReview;

  /// No description provided for @statusLabelActionRequired.
  ///
  /// In en, this message translates to:
  /// **'Action needed'**
  String get statusLabelActionRequired;

  /// No description provided for @statusLabelApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusLabelApproved;

  /// No description provided for @statusLabelRejected.
  ///
  /// In en, this message translates to:
  /// **'Not approved'**
  String get statusLabelRejected;

  /// No description provided for @statusHeadlineDraft.
  ///
  /// In en, this message translates to:
  /// **'Not submitted yet'**
  String get statusHeadlineDraft;

  /// No description provided for @statusBodyDraft.
  ///
  /// In en, this message translates to:
  /// **'Finish your application and submit it for review.'**
  String get statusBodyDraft;

  /// No description provided for @statusHeadlineInReview.
  ///
  /// In en, this message translates to:
  /// **'We\'re reviewing your application'**
  String get statusHeadlineInReview;

  /// No description provided for @statusBodyInReview.
  ///
  /// In en, this message translates to:
  /// **'We\'ll let you know when there\'s an update, or if we need anything else.'**
  String get statusBodyInReview;

  /// No description provided for @statusHeadlineActionRequired.
  ///
  /// In en, this message translates to:
  /// **'A few things need your attention'**
  String get statusHeadlineActionRequired;

  /// No description provided for @statusBodyActionRequired.
  ///
  /// In en, this message translates to:
  /// **'Our reviewer asked for the changes below. Fix them, then resubmit.'**
  String get statusBodyActionRequired;

  /// No description provided for @statusHeadlineApproved.
  ///
  /// In en, this message translates to:
  /// **'You\'re approved'**
  String get statusHeadlineApproved;

  /// No description provided for @statusBodyApproved.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FastPay. We\'ll be in touch with your next steps.'**
  String get statusBodyApproved;

  /// No description provided for @statusHeadlineRejected.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t approve this application'**
  String get statusHeadlineRejected;

  /// No description provided for @statusBodyRejected.
  ///
  /// In en, this message translates to:
  /// **'Contact FastPay support if you have questions about this decision.'**
  String get statusBodyRejected;

  /// No description provided for @statusDocsSection.
  ///
  /// In en, this message translates to:
  /// **'Documents to upload again'**
  String get statusDocsSection;

  /// No description provided for @statusDocsHint.
  ///
  /// In en, this message translates to:
  /// **'Upload a new file for each document. Only these need to change.'**
  String get statusDocsHint;

  /// No description provided for @statusFieldsSection.
  ///
  /// In en, this message translates to:
  /// **'Details to change'**
  String get statusFieldsSection;

  /// No description provided for @statusFieldsHint.
  ///
  /// In en, this message translates to:
  /// **'Change these details, then submit again from the Review step.'**
  String get statusFieldsHint;

  /// No description provided for @statusFixIn.
  ///
  /// In en, this message translates to:
  /// **'Fix in {step}'**
  String statusFixIn(String step);

  /// No description provided for @statusResubmit.
  ///
  /// In en, this message translates to:
  /// **'Resubmit for review'**
  String get statusResubmit;

  /// No description provided for @statusResubmitBlocked.
  ///
  /// In en, this message translates to:
  /// **'Upload a new file for every document above to resubmit.'**
  String get statusResubmitBlocked;

  /// No description provided for @statusContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue application'**
  String get statusContinue;

  /// No description provided for @statusRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get statusRetry;

  /// No description provided for @statusViewStatus.
  ///
  /// In en, this message translates to:
  /// **'View application status'**
  String get statusViewStatus;

  /// No description provided for @reviewIntro.
  ///
  /// In en, this message translates to:
  /// **'Check your answers before you submit. Tap Edit to change a section.'**
  String get reviewIntro;

  /// No description provided for @reviewEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get reviewEdit;

  /// No description provided for @reviewEditSection.
  ///
  /// In en, this message translates to:
  /// **'Edit {section}'**
  String reviewEditSection(String section);

  /// No description provided for @reviewOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get reviewOwner;

  /// No description provided for @reviewHours.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get reviewHours;

  /// No description provided for @reviewHoursValue.
  ///
  /// In en, this message translates to:
  /// **'{days}, {opens} to {closes}'**
  String reviewHoursValue(String days, String opens, String closes);

  /// No description provided for @reviewAddress.
  ///
  /// In en, this message translates to:
  /// **'Business address'**
  String get reviewAddress;

  /// No description provided for @reviewSubtenant.
  ///
  /// In en, this message translates to:
  /// **'Subleases this location'**
  String get reviewSubtenant;

  /// No description provided for @reviewTimeAtLocation.
  ///
  /// In en, this message translates to:
  /// **'Time at location'**
  String get reviewTimeAtLocation;

  /// No description provided for @reviewTimeAtResidence.
  ///
  /// In en, this message translates to:
  /// **'Time at residential home'**
  String get reviewTimeAtResidence;

  /// No description provided for @reviewYearsMonths.
  ///
  /// In en, this message translates to:
  /// **'{years, plural, =1{1 year} other{{years} years}}, {months, plural, =1{1 month} other{{months} months}}'**
  String reviewYearsMonths(int years, int months);

  /// No description provided for @reviewYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get reviewYes;

  /// No description provided for @reviewNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get reviewNo;

  /// No description provided for @reviewNotProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get reviewNotProvided;

  /// No description provided for @reviewMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get reviewMissing;

  /// No description provided for @reviewPhotoCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String reviewPhotoCount(int count);

  /// No description provided for @reviewBillDated.
  ///
  /// In en, this message translates to:
  /// **'{file}, dated {date}'**
  String reviewBillDated(String file, String date);

  /// No description provided for @reviewPartnerId.
  ///
  /// In en, this message translates to:
  /// **'{name}: {idType}'**
  String reviewPartnerId(String name, String idType);

  /// No description provided for @reviewHomeBill.
  ///
  /// In en, this message translates to:
  /// **'Home utility bill'**
  String get reviewHomeBill;

  /// No description provided for @reviewOfficerIsOwner.
  ///
  /// In en, this message translates to:
  /// **'{name} (owner)'**
  String reviewOfficerIsOwner(String name);

  /// No description provided for @submitConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit your application?'**
  String get submitConfirmTitle;

  /// No description provided for @submitConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'By submitting, you confirm the information and documents are accurate and belong to your business. You can\'t change them while the application is in review.'**
  String get submitConfirmBody;

  /// No description provided for @submitConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitConfirmAction;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get submitting;

  /// No description provided for @fixErrorsMessage.
  ///
  /// In en, this message translates to:
  /// **'Please fix the highlighted fields.'**
  String get fixErrorsMessage;

  /// No description provided for @errorRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get errorRequired;

  /// No description provided for @errorSelectDay.
  ///
  /// In en, this message translates to:
  /// **'Select at least one day'**
  String get errorSelectDay;

  /// No description provided for @errorSameTimes.
  ///
  /// In en, this message translates to:
  /// **'Closing time must be different from opening time'**
  String get errorSameTimes;

  /// No description provided for @errorYearsRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a number from 0 to 99'**
  String get errorYearsRange;

  /// No description provided for @errorMonthsRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a number from 0 to 11'**
  String get errorMonthsRange;

  /// No description provided for @errorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number for the selected country'**
  String get errorPhoneInvalid;

  /// No description provided for @errorEinFormat.
  ///
  /// In en, this message translates to:
  /// **'Enter a 9-digit EIN (XX-XXXXXXX)'**
  String get errorEinFormat;

  /// No description provided for @errorSsnFormat.
  ///
  /// In en, this message translates to:
  /// **'Enter a 9-digit SSN (XXX-XX-XXXX)'**
  String get errorSsnFormat;

  /// No description provided for @countrySearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search by country code or dial code'**
  String get countrySearchLabel;

  /// No description provided for @phoneCountryButton.
  ///
  /// In en, this message translates to:
  /// **'Country {isoCode}, dial code plus {dialCode}. Change country'**
  String phoneCountryButton(String isoCode, String dialCode);

  /// No description provided for @step1OwnerSection.
  ///
  /// In en, this message translates to:
  /// **'Business owner'**
  String get step1OwnerSection;

  /// No description provided for @step1OwnerHelp.
  ///
  /// In en, this message translates to:
  /// **'The owner is partner 1 when you upload IDs in the next step.'**
  String get step1OwnerHelp;

  /// No description provided for @step1OwnerFirstName.
  ///
  /// In en, this message translates to:
  /// **'Owner first name'**
  String get step1OwnerFirstName;

  /// No description provided for @step1OwnerLastName.
  ///
  /// In en, this message translates to:
  /// **'Owner last name'**
  String get step1OwnerLastName;

  /// No description provided for @step1AddressSection.
  ///
  /// In en, this message translates to:
  /// **'Business location address'**
  String get step1AddressSection;

  /// No description provided for @step1AddressLine1.
  ///
  /// In en, this message translates to:
  /// **'Street address'**
  String get step1AddressLine1;

  /// No description provided for @step1AddressLine2.
  ///
  /// In en, this message translates to:
  /// **'Apt, suite, or unit (optional)'**
  String get step1AddressLine2;

  /// No description provided for @step1City.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get step1City;

  /// No description provided for @step1Region.
  ///
  /// In en, this message translates to:
  /// **'State or region (optional)'**
  String get step1Region;

  /// No description provided for @step1PostalCode.
  ///
  /// In en, this message translates to:
  /// **'ZIP or postal code (optional)'**
  String get step1PostalCode;

  /// No description provided for @step1Country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get step1Country;

  /// No description provided for @step1CountryButton.
  ///
  /// In en, this message translates to:
  /// **'Country {isoCode}. Change country'**
  String step1CountryButton(String isoCode);

  /// No description provided for @step1SubtenantToggle.
  ///
  /// In en, this message translates to:
  /// **'I sublease this location from another business'**
  String get step1SubtenantToggle;

  /// No description provided for @step1HoursSection.
  ///
  /// In en, this message translates to:
  /// **'Days and hours of operation'**
  String get step1HoursSection;

  /// No description provided for @step1DaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Open on'**
  String get step1DaysLabel;

  /// No description provided for @step1OpensAt.
  ///
  /// In en, this message translates to:
  /// **'Opens at'**
  String get step1OpensAt;

  /// No description provided for @step1ClosesAt.
  ///
  /// In en, this message translates to:
  /// **'Closes at'**
  String get step1ClosesAt;

  /// No description provided for @step1LocationSection.
  ///
  /// In en, this message translates to:
  /// **'Time at current location'**
  String get step1LocationSection;

  /// No description provided for @step1Years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get step1Years;

  /// No description provided for @step1Months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get step1Months;

  /// No description provided for @step1PropertySection.
  ///
  /// In en, this message translates to:
  /// **'Property status'**
  String get step1PropertySection;

  /// No description provided for @step1BusinessProperty.
  ///
  /// In en, this message translates to:
  /// **'Business location'**
  String get step1BusinessProperty;

  /// No description provided for @step1ResidentialProperty.
  ///
  /// In en, this message translates to:
  /// **'Residential home'**
  String get step1ResidentialProperty;

  /// No description provided for @propertyLease.
  ///
  /// In en, this message translates to:
  /// **'Lease'**
  String get propertyLease;

  /// No description provided for @propertyOwn.
  ///
  /// In en, this message translates to:
  /// **'Own'**
  String get propertyOwn;

  /// No description provided for @step1ResidenceTimeSection.
  ///
  /// In en, this message translates to:
  /// **'Time at residential home (optional)'**
  String get step1ResidenceTimeSection;

  /// No description provided for @step1BusinessLandlordSection.
  ///
  /// In en, this message translates to:
  /// **'Business landlord'**
  String get step1BusinessLandlordSection;

  /// No description provided for @step1BusinessLandlordName.
  ///
  /// In en, this message translates to:
  /// **'Business landlord name'**
  String get step1BusinessLandlordName;

  /// No description provided for @step1BusinessLandlordPhone.
  ///
  /// In en, this message translates to:
  /// **'Business landlord phone'**
  String get step1BusinessLandlordPhone;

  /// No description provided for @step1ResidentialLandlordSection.
  ///
  /// In en, this message translates to:
  /// **'Home landlord'**
  String get step1ResidentialLandlordSection;

  /// No description provided for @step1ResidentialLandlordName.
  ///
  /// In en, this message translates to:
  /// **'Home landlord name'**
  String get step1ResidentialLandlordName;

  /// No description provided for @step1ResidentialLandlordPhone.
  ///
  /// In en, this message translates to:
  /// **'Home landlord phone'**
  String get step1ResidentialLandlordPhone;

  /// No description provided for @step1BankSection.
  ///
  /// In en, this message translates to:
  /// **'Banking'**
  String get step1BankSection;

  /// No description provided for @step1BankName.
  ///
  /// In en, this message translates to:
  /// **'Personal bank name'**
  String get step1BankName;

  /// No description provided for @step1TaxSection.
  ///
  /// In en, this message translates to:
  /// **'Business tax designation'**
  String get step1TaxSection;

  /// No description provided for @step1EinLabel.
  ///
  /// In en, this message translates to:
  /// **'Business EIN'**
  String get step1EinLabel;

  /// No description provided for @step1SsnLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner\'s SSN'**
  String get step1SsnLabel;

  /// No description provided for @taxLlcSoleEinTitle.
  ///
  /// In en, this message translates to:
  /// **'LLC (Sole Proprietorship / Single-Member LLC - EIN)'**
  String get taxLlcSoleEinTitle;

  /// No description provided for @taxLlcSoleEinBody.
  ///
  /// In en, this message translates to:
  /// **'Files under its own EIN.'**
  String get taxLlcSoleEinBody;

  /// No description provided for @taxLlcSoleSsnTitle.
  ///
  /// In en, this message translates to:
  /// **'LLC (Sole Proprietorship / Single-Member LLC - SSN)'**
  String get taxLlcSoleSsnTitle;

  /// No description provided for @taxLlcSoleSsnBody.
  ///
  /// In en, this message translates to:
  /// **'Disregarded entity. The owner reports on their personal return using their SSN.'**
  String get taxLlcSoleSsnBody;

  /// No description provided for @taxLlcCCorpTitle.
  ///
  /// In en, this message translates to:
  /// **'LLC (C-Corporation Election)'**
  String get taxLlcCCorpTitle;

  /// No description provided for @taxLlcCCorpBody.
  ///
  /// In en, this message translates to:
  /// **'Taxed as a C-Corporation (IRS Form 8832).'**
  String get taxLlcCCorpBody;

  /// No description provided for @taxLlcSCorpTitle.
  ///
  /// In en, this message translates to:
  /// **'LLC (S-Corporation Election)'**
  String get taxLlcSCorpTitle;

  /// No description provided for @taxLlcSCorpBody.
  ///
  /// In en, this message translates to:
  /// **'Taxed as an S-Corporation (IRS Form 2553).'**
  String get taxLlcSCorpBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The connection timed out. Try again.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'This couldn\'t be accepted. Check it and try again.'**
  String get errorValidation;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Try again.'**
  String get errorServer;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get errorUnknown;

  /// No description provided for @fileSizeKb.
  ///
  /// In en, this message translates to:
  /// **'{size} KB'**
  String fileSizeKb(String size);

  /// No description provided for @fileSizeMb.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String fileSizeMb(String size);

  /// No description provided for @docStatusNotUploaded.
  ///
  /// In en, this message translates to:
  /// **'Not uploaded'**
  String get docStatusNotUploaded;

  /// No description provided for @docStatusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get docStatusPreparing;

  /// No description provided for @docStatusUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading'**
  String get docStatusUploading;

  /// No description provided for @docStatusUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get docStatusUploaded;

  /// No description provided for @docStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get docStatusFailed;

  /// No description provided for @docStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get docStatusRejected;

  /// No description provided for @docStatusSemantics.
  ///
  /// In en, this message translates to:
  /// **'{document}: {status}'**
  String docStatusSemantics(String document, String status);

  /// No description provided for @docPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing file…'**
  String get docPreparing;

  /// No description provided for @docUploadingProgress.
  ///
  /// In en, this message translates to:
  /// **'Uploading {percent}%'**
  String docUploadingProgress(int percent);

  /// No description provided for @docRejectedReason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String docRejectedReason(String reason);

  /// No description provided for @docCurrentFileNote.
  ///
  /// In en, this message translates to:
  /// **'Your previous file is still on record.'**
  String get docCurrentFileNote;

  /// No description provided for @docAdd.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get docAdd;

  /// No description provided for @docReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get docReplace;

  /// No description provided for @docRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get docRemove;

  /// No description provided for @docRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get docRetry;

  /// No description provided for @docChooseAnother.
  ///
  /// In en, this message translates to:
  /// **'Choose another file'**
  String get docChooseAnother;

  /// No description provided for @docOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get docOpenSettings;

  /// No description provided for @docActionFor.
  ///
  /// In en, this message translates to:
  /// **'{action}: {document}'**
  String docActionFor(String action, String document);

  /// No description provided for @docSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get docSourceTitle;

  /// No description provided for @docSourceCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get docSourceCamera;

  /// No description provided for @docSourceGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from photos'**
  String get docSourceGallery;

  /// No description provided for @docSourceFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose a file (PDF, JPG or PNG)'**
  String get docSourceFiles;

  /// No description provided for @docCameraHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you take the photo'**
  String get docCameraHintTitle;

  /// No description provided for @docOpenCamera.
  ///
  /// In en, this message translates to:
  /// **'Open camera'**
  String get docOpenCamera;

  /// No description provided for @docErrorTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This file is too large. The maximum size is {maxSize}.'**
  String docErrorTooLarge(String maxSize);

  /// No description provided for @docErrorUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This file type isn\'t supported. Use PDF, JPG or PNG.'**
  String get docErrorUnsupported;

  /// No description provided for @docErrorUnreadable.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t read this file. Try another one.'**
  String get docErrorUnreadable;

  /// No description provided for @docErrorPermission.
  ///
  /// In en, this message translates to:
  /// **'FastPay needs access to your camera or photos. You can allow it in Settings.'**
  String get docErrorPermission;

  /// No description provided for @docErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Upload this document'**
  String get docErrorRequired;

  /// No description provided for @step2Intro.
  ///
  /// In en, this message translates to:
  /// **'Upload clear photos or scans. Accepted file types: PDF, JPG and PNG.'**
  String get step2Intro;

  /// No description provided for @step2IdSection.
  ///
  /// In en, this message translates to:
  /// **'Personal ID'**
  String get step2IdSection;

  /// No description provided for @step2IdHelp.
  ///
  /// In en, this message translates to:
  /// **'Every business partner needs a valid government ID, driver\'s license, or passport.'**
  String get step2IdHelp;

  /// No description provided for @step2OwnerHeading.
  ///
  /// In en, this message translates to:
  /// **'Partner 1 (owner)'**
  String get step2OwnerHeading;

  /// No description provided for @step2PartnerFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name (as on ID)'**
  String get step2PartnerFirstName;

  /// No description provided for @step2PartnerLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name (as on ID)'**
  String get step2PartnerLastName;

  /// No description provided for @step2OwnerName.
  ///
  /// In en, this message translates to:
  /// **'{name}, from business details'**
  String step2OwnerName(String name);

  /// No description provided for @step2PartnerHeading.
  ///
  /// In en, this message translates to:
  /// **'Partner {number}'**
  String step2PartnerHeading(int number);

  /// No description provided for @step2RemovePartner.
  ///
  /// In en, this message translates to:
  /// **'Remove partner {number}'**
  String step2RemovePartner(int number);

  /// No description provided for @step2RemovePartnerBody.
  ///
  /// In en, this message translates to:
  /// **'Their ID and utility bill will be removed from this application.'**
  String get step2RemovePartnerBody;

  /// No description provided for @step2RemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get step2RemoveConfirm;

  /// No description provided for @step2AddPartner.
  ///
  /// In en, this message translates to:
  /// **'Add partner'**
  String get step2AddPartner;

  /// No description provided for @step2IdTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type of ID'**
  String get step2IdTypeLabel;

  /// No description provided for @idTypeGovernmentId.
  ///
  /// In en, this message translates to:
  /// **'Government-issued ID card'**
  String get idTypeGovernmentId;

  /// No description provided for @idTypeDriversLicense.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s license'**
  String get idTypeDriversLicense;

  /// No description provided for @idTypePassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get idTypePassport;

  /// No description provided for @idTypePassportNote.
  ///
  /// In en, this message translates to:
  /// **'A home utility bill is also required.'**
  String get idTypePassportNote;

  /// No description provided for @step2IdCard.
  ///
  /// In en, this message translates to:
  /// **'Partner {number}: photo ID'**
  String step2IdCard(int number);

  /// No description provided for @step2PoBoxToggle.
  ///
  /// In en, this message translates to:
  /// **'This ID lists a P.O. Box address'**
  String get step2PoBoxToggle;

  /// No description provided for @step2PoBoxNote.
  ///
  /// In en, this message translates to:
  /// **'If so, we also need a home utility bill.'**
  String get step2PoBoxNote;

  /// No description provided for @step2HomeBillCard.
  ///
  /// In en, this message translates to:
  /// **'Partner {number}: home utility bill'**
  String step2HomeBillCard(int number);

  /// No description provided for @step2HomeBillHelp.
  ///
  /// In en, this message translates to:
  /// **'Needed because the ID is a passport or lists a P.O. Box. It must show the home address and be dated within the last 60 days.'**
  String get step2HomeBillHelp;

  /// No description provided for @step2BillDate.
  ///
  /// In en, this message translates to:
  /// **'Bill date'**
  String get step2BillDate;

  /// No description provided for @errorBillDateFuture.
  ///
  /// In en, this message translates to:
  /// **'The bill date can\'t be in the future'**
  String get errorBillDateFuture;

  /// No description provided for @errorBillOlderThan60Days.
  ///
  /// In en, this message translates to:
  /// **'The bill must be dated within the last 60 days'**
  String get errorBillOlderThan60Days;

  /// No description provided for @errorBillOlderThan90Days.
  ///
  /// In en, this message translates to:
  /// **'The bill must be dated within the last 90 days'**
  String get errorBillOlderThan90Days;

  /// No description provided for @step2RegistrationSection.
  ///
  /// In en, this message translates to:
  /// **'Business registration'**
  String get step2RegistrationSection;

  /// No description provided for @step2RegistrationHelp.
  ///
  /// In en, this message translates to:
  /// **'The business must be in good standing with the Secretary of State. Which document do you have?'**
  String get step2RegistrationHelp;

  /// No description provided for @regArticlesOfOrganization.
  ///
  /// In en, this message translates to:
  /// **'Articles of Organization (LLC)'**
  String get regArticlesOfOrganization;

  /// No description provided for @regArticlesOfIncorporation.
  ///
  /// In en, this message translates to:
  /// **'Articles of Incorporation (corporation)'**
  String get regArticlesOfIncorporation;

  /// No description provided for @step2IrsSection.
  ///
  /// In en, this message translates to:
  /// **'IRS registration'**
  String get step2IrsSection;

  /// No description provided for @step2IrsHelp.
  ///
  /// In en, this message translates to:
  /// **'Upload one of these.'**
  String get step2IrsHelp;

  /// No description provided for @irsEinForm.
  ///
  /// In en, this message translates to:
  /// **'EIN form (Form SS-4 or equivalent)'**
  String get irsEinForm;

  /// No description provided for @irsSs4Letter.
  ///
  /// In en, this message translates to:
  /// **'IRS SS-4 letter'**
  String get irsSs4Letter;

  /// No description provided for @irsRecentTaxReturn.
  ///
  /// In en, this message translates to:
  /// **'Recent tax return'**
  String get irsRecentTaxReturn;

  /// No description provided for @step2LicenseSection.
  ///
  /// In en, this message translates to:
  /// **'Business license or permit'**
  String get step2LicenseSection;

  /// No description provided for @step2LicenseHelp.
  ///
  /// In en, this message translates to:
  /// **'Upload one document. Choose its type first.'**
  String get step2LicenseHelp;

  /// No description provided for @step2LicenseTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'License or permit type'**
  String get step2LicenseTypeLabel;

  /// No description provided for @licenseGeneralBusiness.
  ///
  /// In en, this message translates to:
  /// **'General business license'**
  String get licenseGeneralBusiness;

  /// No description provided for @licenseSalesTaxPermit.
  ///
  /// In en, this message translates to:
  /// **'Sales tax permit'**
  String get licenseSalesTaxPermit;

  /// No description provided for @licenseFood.
  ///
  /// In en, this message translates to:
  /// **'Food license'**
  String get licenseFood;

  /// No description provided for @licenseLiquor.
  ///
  /// In en, this message translates to:
  /// **'Liquor license'**
  String get licenseLiquor;

  /// No description provided for @licenseTobacco.
  ///
  /// In en, this message translates to:
  /// **'Tobacco license'**
  String get licenseTobacco;

  /// No description provided for @licenseLottery.
  ///
  /// In en, this message translates to:
  /// **'Lottery license'**
  String get licenseLottery;

  /// No description provided for @licenseHealthDept.
  ///
  /// In en, this message translates to:
  /// **'Health department permit'**
  String get licenseHealthDept;

  /// No description provided for @licenseCertificateOfOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Certificate of occupancy'**
  String get licenseCertificateOfOccupancy;

  /// No description provided for @licenseFireInspection.
  ///
  /// In en, this message translates to:
  /// **'Fire inspection'**
  String get licenseFireInspection;

  /// No description provided for @licenseFoodInspection.
  ///
  /// In en, this message translates to:
  /// **'Food inspection'**
  String get licenseFoodInspection;

  /// No description provided for @licenseDotRegistration.
  ///
  /// In en, this message translates to:
  /// **'DOT registration'**
  String get licenseDotRegistration;

  /// No description provided for @licenseCommercialAutoInsurance.
  ///
  /// In en, this message translates to:
  /// **'Commercial auto insurance'**
  String get licenseCommercialAutoInsurance;

  /// No description provided for @licenseCommercialVehicleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Commercial vehicle registration'**
  String get licenseCommercialVehicleRegistration;

  /// No description provided for @licenseGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'General business license or sales tax permit'**
  String get licenseGeneralTitle;

  /// No description provided for @licenseIndustryTitle.
  ///
  /// In en, this message translates to:
  /// **'Industry-specific permit'**
  String get licenseIndustryTitle;

  /// No description provided for @licenseIndustryBody.
  ///
  /// In en, this message translates to:
  /// **'Food, liquor, tobacco, lottery, health department, etc.'**
  String get licenseIndustryBody;

  /// No description provided for @licensePropertySafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Property or safety certificate'**
  String get licensePropertySafetyTitle;

  /// No description provided for @licensePropertySafetyBody.
  ///
  /// In en, this message translates to:
  /// **'Certificate of occupancy, fire inspection, food inspection.'**
  String get licensePropertySafetyBody;

  /// No description provided for @licenseTransportationTitle.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get licenseTransportationTitle;

  /// No description provided for @licenseTransportationBody.
  ///
  /// In en, this message translates to:
  /// **'DOT registration, commercial auto insurance, commercial vehicle registration.'**
  String get licenseTransportationBody;

  /// No description provided for @step2LicenseCard.
  ///
  /// In en, this message translates to:
  /// **'License or permit'**
  String get step2LicenseCard;

  /// No description provided for @step2BusinessBillSection.
  ///
  /// In en, this message translates to:
  /// **'Business utility bill'**
  String get step2BusinessBillSection;

  /// No description provided for @step2BusinessBillCard.
  ///
  /// In en, this message translates to:
  /// **'Business utility bill'**
  String get step2BusinessBillCard;

  /// No description provided for @step2BusinessBillHelp.
  ///
  /// In en, this message translates to:
  /// **'Must show the business address and be dated within the last 90 days.'**
  String get step2BusinessBillHelp;

  /// No description provided for @step2PhotosSection.
  ///
  /// In en, this message translates to:
  /// **'Business photos'**
  String get step2PhotosSection;

  /// No description provided for @step2PhotosHelp.
  ///
  /// In en, this message translates to:
  /// **'Three photos are required. You can add a fourth.'**
  String get step2PhotosHelp;

  /// No description provided for @photoExteriorTitle.
  ///
  /// In en, this message translates to:
  /// **'Exterior'**
  String get photoExteriorTitle;

  /// No description provided for @photoExteriorHelp.
  ///
  /// In en, this message translates to:
  /// **'Show the entrance, business name, and street number clearly.'**
  String get photoExteriorHelp;

  /// No description provided for @photoExteriorCameraHint.
  ///
  /// In en, this message translates to:
  /// **'Show the entrance, business name, and street number.'**
  String get photoExteriorCameraHint;

  /// No description provided for @photoInteriorLayoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Interior: store layout'**
  String get photoInteriorLayoutTitle;

  /// No description provided for @photoInteriorLayoutHelp.
  ///
  /// In en, this message translates to:
  /// **'Show the full store layout.'**
  String get photoInteriorLayoutHelp;

  /// No description provided for @photoCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Interior: checkout area'**
  String get photoCheckoutTitle;

  /// No description provided for @photoCheckoutHelp.
  ///
  /// In en, this message translates to:
  /// **'Show the transaction or checkout area.'**
  String get photoCheckoutHelp;

  /// No description provided for @photoAdditionalTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional photo (optional)'**
  String get photoAdditionalTitle;

  /// No description provided for @photoAdditionalHelp.
  ///
  /// In en, this message translates to:
  /// **'Any other view that helps us verify your business.'**
  String get photoAdditionalHelp;

  /// No description provided for @step2OtherSection.
  ///
  /// In en, this message translates to:
  /// **'Trade name and sublease'**
  String get step2OtherSection;

  /// No description provided for @step2DbaToggle.
  ///
  /// In en, this message translates to:
  /// **'My business uses a trade name (DBA)'**
  String get step2DbaToggle;

  /// No description provided for @step2DbaNote.
  ///
  /// In en, this message translates to:
  /// **'We verify your trade name from your business photos. Make sure it is clearly visible in the exterior photo.'**
  String get step2DbaNote;

  /// No description provided for @step2TradeName.
  ///
  /// In en, this message translates to:
  /// **'Trade name (DBA)'**
  String get step2TradeName;

  /// No description provided for @step2DbaCard.
  ///
  /// In en, this message translates to:
  /// **'DBA documentation (optional)'**
  String get step2DbaCard;

  /// No description provided for @step2DbaCardHelp.
  ///
  /// In en, this message translates to:
  /// **'For example, your trade name filing or certificate.'**
  String get step2DbaCardHelp;

  /// No description provided for @step2SubleaseCard.
  ///
  /// In en, this message translates to:
  /// **'Sublease agreement'**
  String get step2SubleaseCard;

  /// No description provided for @step2SubleaseHelp.
  ///
  /// In en, this message translates to:
  /// **'Required because you said you sublease this location.'**
  String get step2SubleaseHelp;

  /// No description provided for @step3ProcessorsSection.
  ///
  /// In en, this message translates to:
  /// **'Transaction processors'**
  String get step3ProcessorsSection;

  /// No description provided for @step3ProcessorsHelp.
  ///
  /// In en, this message translates to:
  /// **'Everyone who will process transactions. We use these names to set up their logins and compliance training.'**
  String get step3ProcessorsHelp;

  /// No description provided for @step3ProcessorHeading.
  ///
  /// In en, this message translates to:
  /// **'Processor {number}'**
  String step3ProcessorHeading(int number);

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @step3RemoveProcessor.
  ///
  /// In en, this message translates to:
  /// **'Remove processor {number}'**
  String step3RemoveProcessor(int number);

  /// No description provided for @step3AddProcessor.
  ///
  /// In en, this message translates to:
  /// **'Add processor'**
  String get step3AddProcessor;

  /// No description provided for @step3OfficerSection.
  ///
  /// In en, this message translates to:
  /// **'Compliance Officer'**
  String get step3OfficerSection;

  /// No description provided for @step3OfficerHelp.
  ///
  /// In en, this message translates to:
  /// **'The person responsible for compliance at your business.'**
  String get step3OfficerHelp;

  /// No description provided for @step3OfficerSameAsOwner.
  ///
  /// In en, this message translates to:
  /// **'Same as owner'**
  String get step3OfficerSameAsOwner;

  /// No description provided for @step3OfficerOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Owner: {name}'**
  String step3OfficerOwnerName(String name);

  /// No description provided for @step3OfficerOwnerUnknown.
  ///
  /// In en, this message translates to:
  /// **'The owner you entered in Business details.'**
  String get step3OfficerOwnerUnknown;

  /// No description provided for @step3OfficerFirstName.
  ///
  /// In en, this message translates to:
  /// **'Compliance Officer first name'**
  String get step3OfficerFirstName;

  /// No description provided for @step3OfficerLastName.
  ///
  /// In en, this message translates to:
  /// **'Compliance Officer last name'**
  String get step3OfficerLastName;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
