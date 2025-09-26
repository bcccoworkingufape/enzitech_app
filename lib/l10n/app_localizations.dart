import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @connectionRestored.
  ///
  /// In en, this message translates to:
  /// **'✓ Connection restored'**
  String get connectionRestored;

  /// No description provided for @loginAgain.
  ///
  /// In en, this message translates to:
  /// **'Log in again.'**
  String get loginAgain;

  /// No description provided for @registerExperiment.
  ///
  /// In en, this message translates to:
  /// **'Register\n Experiment'**
  String get registerExperiment;

  /// No description provided for @registerTreatment.
  ///
  /// In en, this message translates to:
  /// **'Register\n Treatment'**
  String get registerTreatment;

  /// No description provided for @registerEnzyme.
  ///
  /// In en, this message translates to:
  /// **'Register\n Enzyme'**
  String get registerEnzyme;

  /// No description provided for @noInternetWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠ No connection to the server: You are viewing previously loaded and un-updated information, any offline changes will not be maintained!'**
  String get noInternetWarning;

  /// No description provided for @experiments.
  ///
  /// In en, this message translates to:
  /// **'Experiments'**
  String get experiments;

  /// No description provided for @treatments.
  ///
  /// In en, this message translates to:
  /// **'Treatments'**
  String get treatments;

  /// No description provided for @enzymes.
  ///
  /// In en, this message translates to:
  /// **'Enzymes'**
  String get enzymes;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About Enzitech'**
  String get about;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get frequentlyAskedQuestions;

  /// No description provided for @userData.
  ///
  /// In en, this message translates to:
  /// **'User Data'**
  String get userData;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get userName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @userType.
  ///
  /// In en, this message translates to:
  /// **'User Role'**
  String get userType;

  /// Users roles into the app
  ///
  /// In en, this message translates to:
  /// **'{role, select, admin{Administrator} common{Common} other{Common}}'**
  String roles(String role);

  /// No description provided for @deletionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Deletion confirmation'**
  String get deletionConfirmation;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details about Enzitech'**
  String get details;

  /// No description provided for @environment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @seeYouSoon.
  ///
  /// In en, this message translates to:
  /// **'See you soon...'**
  String get seeYouSoon;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About:'**
  String get aboutTitle;

  /// No description provided for @idealizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Idealization'**
  String get idealizationTitle;

  /// No description provided for @developmentTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Development Team'**
  String get developmentTeamTitle;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @idealizationTextP1.
  ///
  /// In en, this message translates to:
  /// **' was conceived as a solution for the study and realization of experiments in the field of soil enzymatic activities, idealized in conjunction with the '**
  String get idealizationTextP1;

  /// No description provided for @idealizationTextP2.
  ///
  /// In en, this message translates to:
  /// **' and the '**
  String get idealizationTextP2;

  /// No description provided for @idealizationTextP3.
  ///
  /// In en, this message translates to:
  /// **', located at the '**
  String get idealizationTextP3;

  /// No description provided for @roleMobileDeveloper.
  ///
  /// In en, this message translates to:
  /// **'(Mobile developer)'**
  String get roleMobileDeveloper;

  /// No description provided for @roleBackendDeveloper.
  ///
  /// In en, this message translates to:
  /// **'(Back-end developer)'**
  String get roleBackendDeveloper;

  /// No description provided for @roleProjectManagement.
  ///
  /// In en, this message translates to:
  /// **'(Project Management)'**
  String get roleProjectManagement;

  /// No description provided for @roleProfessorBCC.
  ///
  /// In en, this message translates to:
  /// **'(Professor - BCC)'**
  String get roleProfessorBCC;

  /// No description provided for @roleProfessorAgronomy.
  ///
  /// In en, this message translates to:
  /// **'(Professor - Agronomy)'**
  String get roleProfessorAgronomy;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question: '**
  String get question;

  /// No description provided for @question1.
  ///
  /// In en, this message translates to:
  /// **'I\'m unable to create an enzyme. Why?'**
  String get question1;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer: '**
  String get answer;

  /// No description provided for @answer1.
  ///
  /// In en, this message translates to:
  /// **'Creating new enzymes is a feature limited to administrators. Currently, adding a new enzyme to the system requires implementation by our team. Should you need a new enzyme type, please send a request to the system administrator.'**
  String get answer1;

  /// No description provided for @selectTreatment.
  ///
  /// In en, this message translates to:
  /// **'Select Treatment: '**
  String get selectTreatment;

  /// No description provided for @loadingAvailableEnzymes.
  ///
  /// In en, this message translates to:
  /// **'Loading available enzymes...'**
  String get loadingAvailableEnzymes;

  /// No description provided for @allEnzymesCalculated.
  ///
  /// In en, this message translates to:
  /// **'All enzymes for this treatment have already been calculated!'**
  String get allEnzymesCalculated;

  /// No description provided for @selectEnzyme.
  ///
  /// In en, this message translates to:
  /// **'Select enzyme: '**
  String get selectEnzyme;

  /// No description provided for @selectedEnzymeType.
  ///
  /// In en, this message translates to:
  /// **'Selected enzyme type: {enzymeType}'**
  String selectedEnzymeType(String enzymeType);

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @insertExperimentData.
  ///
  /// In en, this message translates to:
  /// **'Insert data into experiment'**
  String get insertExperimentData;

  /// No description provided for @stepIndicatorMessage.
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {totalSteps} - Identification'**
  String stepIndicatorMessage(int currentStep, int totalSteps);

  /// No description provided for @invalidExperimentTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid experiment!'**
  String get invalidExperimentTitle;

  /// No description provided for @invalidExperimentMessage.
  ///
  /// In en, this message translates to:
  /// **'It is not possible to proceed without treatment(s) and/or enzyme(s) data'**
  String get invalidExperimentMessage;

  /// No description provided for @chooseTreatmentAndEnzyme.
  ///
  /// In en, this message translates to:
  /// **'Choose the treatment and enzyme to insert the data'**
  String get chooseTreatmentAndEnzyme;

  /// No description provided for @calculateButton.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculateButton;

  /// No description provided for @stepIndicatorMessageFilling.
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {totalSteps} - Filling and calculation'**
  String stepIndicatorMessageFilling(int currentStep, int totalSteps);

  /// No description provided for @repetitionDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data for repetition #{repetitionNumber}'**
  String repetitionDataTitle(int repetitionNumber);

  /// No description provided for @saveAndExitButton.
  ///
  /// In en, this message translates to:
  /// **'Save and exit'**
  String get saveAndExitButton;

  /// No description provided for @recalculateButton.
  ///
  /// In en, this message translates to:
  /// **'Recalculate'**
  String get recalculateButton;

  /// No description provided for @repetitionLabel.
  ///
  /// In en, this message translates to:
  /// **'Repetition {repetitionNumber}:'**
  String repetitionLabel(int repetitionNumber);

  /// No description provided for @discrepantRepetitionWarning.
  ///
  /// In en, this message translates to:
  /// **'This repetition is discrepant!\n\nIts value differs by more than 25% from the average of all repetitions.\n\nIf you want to change it, just press \"Recalculate\".'**
  String get discrepantRepetitionWarning;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average:'**
  String get average;

  /// No description provided for @repetitionColumnTitle.
  ///
  /// In en, this message translates to:
  /// **'REPETITION'**
  String get repetitionColumnTitle;

  /// No description provided for @resultColumnTitle.
  ///
  /// In en, this message translates to:
  /// **'RESULT'**
  String get resultColumnTitle;

  /// No description provided for @statusColumnTitle.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get statusColumnTitle;

  /// No description provided for @stepIndicatorMessageResults.
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {totalSteps} - Results'**
  String stepIndicatorMessageResults(int currentStep, int totalSteps);

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @registerNewExperiment.
  ///
  /// In en, this message translates to:
  /// **'Register a new experiment'**
  String get registerNewExperiment;

  /// No description provided for @experimentIdentification.
  ///
  /// In en, this message translates to:
  /// **'Experiment Identification'**
  String get experimentIdentification;

  /// No description provided for @stepIndicatorIdentification.
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {totalSteps} - Identification'**
  String stepIndicatorIdentification(int currentStep, int totalSteps);

  /// No description provided for @repetitionsPerTreatmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of repetitions per treatment'**
  String get repetitionsPerTreatmentLabel;

  /// No description provided for @goToTreatmentsButton.
  ///
  /// In en, this message translates to:
  /// **'Go to treatments'**
  String get goToTreatmentsButton;

  /// No description provided for @treatmentsAndRepetitionsData.
  ///
  /// In en, this message translates to:
  /// **'Treatments and Repetitions Data'**
  String get treatmentsAndRepetitionsData;

  /// No description provided for @noTreatmentsRegisteredError.
  ///
  /// In en, this message translates to:
  /// **'No treatments registered! At least one treatment is required to proceed.'**
  String get noTreatmentsRegisteredError;

  /// No description provided for @stepIndicatorTreatments.
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {totalSteps} - Treatments and Repetitions'**
  String stepIndicatorTreatments(int currentStep, int totalSteps);

  /// No description provided for @experimentEnzymes.
  ///
  /// In en, this message translates to:
  /// **'Experiment Enzymes'**
  String get experimentEnzymes;

  /// No description provided for @enzymeTypeIs.
  ///
  /// In en, this message translates to:
  /// **'Enzyme type: {enzymeType}'**
  String enzymeTypeIs(String enzymeType);

  /// No description provided for @stepIndicatorEnzymes.
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {totalSteps} - Enzymes'**
  String stepIndicatorEnzymes(int currentStep, int totalSteps);

  /// No description provided for @variableA.
  ///
  /// In en, this message translates to:
  /// **'Variable A'**
  String get variableA;

  /// No description provided for @variableB.
  ///
  /// In en, this message translates to:
  /// **'Variable B'**
  String get variableB;

  /// No description provided for @timeHours.
  ///
  /// In en, this message translates to:
  /// **'Time (h)'**
  String get timeHours;

  /// No description provided for @solutionVolume.
  ///
  /// In en, this message translates to:
  /// **'Solution Volume'**
  String get solutionVolume;

  /// No description provided for @sampleWeightGrams.
  ///
  /// In en, this message translates to:
  /// **'Sample Weight (g)'**
  String get sampleWeightGrams;

  /// No description provided for @correctionFactor.
  ///
  /// In en, this message translates to:
  /// **'Correction Factor'**
  String get correctionFactor;

  /// No description provided for @curveInformation.
  ///
  /// In en, this message translates to:
  /// **'Curve Information:'**
  String get curveInformation;

  /// No description provided for @otherVariables.
  ///
  /// In en, this message translates to:
  /// **'Other Variables:'**
  String get otherVariables;

  /// No description provided for @createExperimentButton.
  ///
  /// In en, this message translates to:
  /// **'Create Experiment'**
  String get createExperimentButton;

  /// No description provided for @stepIndicatorFillVariables.
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {totalSteps} - Fill variables'**
  String stepIndicatorFillVariables(int currentStep, int totalSteps);

  /// No description provided for @repetitions.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get repetitions;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data!'**
  String get noData;

  /// No description provided for @errorLoadingExperiment.
  ///
  /// In en, this message translates to:
  /// **'Error loading experiment \"{experimentName}\"'**
  String errorLoadingExperiment(String experimentName);

  /// No description provided for @loadingExperiment.
  ///
  /// In en, this message translates to:
  /// **'Loading experiment...'**
  String get loadingExperiment;

  /// No description provided for @tapToSeeMore.
  ///
  /// In en, this message translates to:
  /// **'Tap to see more information'**
  String get tapToSeeMore;

  /// No description provided for @tapToHide.
  ///
  /// In en, this message translates to:
  /// **'Tap to hide information'**
  String get tapToHide;

  /// No description provided for @enzymaticCalculation.
  ///
  /// In en, this message translates to:
  /// **'Enzymatic Calculation'**
  String get enzymaticCalculation;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @experimentDetails.
  ///
  /// In en, this message translates to:
  /// **'Experiment Details'**
  String get experimentDetails;

  /// No description provided for @experimentDeleted.
  ///
  /// In en, this message translates to:
  /// **'{experimentName} deleted!'**
  String experimentDeleted(String experimentName);

  /// No description provided for @loadingResults.
  ///
  /// In en, this message translates to:
  /// **'Loading results...'**
  String get loadingResults;

  /// No description provided for @experimentHeader.
  ///
  /// In en, this message translates to:
  /// **'Experiment: {experimentName}'**
  String experimentHeader(String experimentName);

  /// No description provided for @enzymeTypeHeader.
  ///
  /// In en, this message translates to:
  /// **'Type: {enzymeType} ({formula})'**
  String enzymeTypeHeader(String enzymeType, String formula);

  /// No description provided for @treatmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatmentLabel;

  /// No description provided for @shareFileError.
  ///
  /// In en, this message translates to:
  /// **'Could not share the file, please try again.'**
  String get shareFileError;

  /// No description provided for @spreadsheetSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet saved successfully!'**
  String get spreadsheetSavedSuccess;

  /// No description provided for @spreadsheetSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the spreadsheet, please try again.'**
  String get spreadsheetSaveError;

  /// No description provided for @columnId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get columnId;

  /// No description provided for @columnSample.
  ///
  /// In en, this message translates to:
  /// **'Sample'**
  String get columnSample;

  /// No description provided for @columnWhiteSampleShort.
  ///
  /// In en, this message translates to:
  /// **'W. Sample'**
  String get columnWhiteSampleShort;

  /// No description provided for @columnWhiteSampleTooltip.
  ///
  /// In en, this message translates to:
  /// **'White Sample'**
  String get columnWhiteSampleTooltip;

  /// No description provided for @columnDifference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get columnDifference;

  /// No description provided for @columnCurve.
  ///
  /// In en, this message translates to:
  /// **'Curve'**
  String get columnCurve;

  /// No description provided for @columnCorrectionFactorShort.
  ///
  /// In en, this message translates to:
  /// **'C. Factor'**
  String get columnCorrectionFactorShort;

  /// No description provided for @columnVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get columnVolume;

  /// No description provided for @columnSampleWeightShort.
  ///
  /// In en, this message translates to:
  /// **'S. Weight'**
  String get columnSampleWeightShort;

  /// No description provided for @columnSampleWeightTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sample Weight'**
  String get columnSampleWeightTooltip;

  /// No description provided for @columnResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get columnResult;

  /// No description provided for @errorLoadingExperiments.
  ///
  /// In en, this message translates to:
  /// **'Error loading experiments'**
  String get errorLoadingExperiments;

  /// No description provided for @loadingExperiments.
  ///
  /// In en, this message translates to:
  /// **'Loading experiments...'**
  String get loadingExperiments;

  /// No description provided for @experimentsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Experiments not found'**
  String get experimentsNotFound;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @allExperimentsDisplayed.
  ///
  /// In en, this message translates to:
  /// **'All experiments displayed!'**
  String get allExperimentsDisplayed;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// A message that shows the number of experiments found
  ///
  /// In en, this message translates to:
  /// **'🔬 {count, plural, =0{No experiments found} =1{1 experiment found} other{{count} experiments found}}'**
  String experimentsFound(int count);
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
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
