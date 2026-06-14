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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @enzymeCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Enzyme created successfully!'**
  String get enzymeCreatedSuccess;

  /// No description provided for @registerNewEnzyme.
  ///
  /// In en, this message translates to:
  /// **'Register a new\nenzyme'**
  String get registerNewEnzyme;

  /// No description provided for @enzymeIdentification.
  ///
  /// In en, this message translates to:
  /// **'Enzyme Identification'**
  String get enzymeIdentification;

  /// No description provided for @chooseEnzymeType.
  ///
  /// In en, this message translates to:
  /// **'Choose the enzyme type'**
  String get chooseEnzymeType;

  /// No description provided for @createEnzymeButton.
  ///
  /// In en, this message translates to:
  /// **'Create enzyme'**
  String get createEnzymeButton;

  /// No description provided for @enzymeType_acidPhosphatase.
  ///
  /// In en, this message translates to:
  /// **'Acid Phosphatase'**
  String get enzymeType_acidPhosphatase;

  /// No description provided for @enzymeType_alkalinePhosphatase.
  ///
  /// In en, this message translates to:
  /// **'Alkaline Phosphatase'**
  String get enzymeType_alkalinePhosphatase;

  /// No description provided for @enzymeType_arylsulfatase.
  ///
  /// In en, this message translates to:
  /// **'Arylsulfatase'**
  String get enzymeType_arylsulfatase;

  /// No description provided for @enzymeType_betaGlucosidase.
  ///
  /// In en, this message translates to:
  /// **'Beta-Glucosidase'**
  String get enzymeType_betaGlucosidase;

  /// No description provided for @enzymeType_urease.
  ///
  /// In en, this message translates to:
  /// **'Urease'**
  String get enzymeType_urease;

  /// No description provided for @enzymeType_fda.
  ///
  /// In en, this message translates to:
  /// **'FDA'**
  String get enzymeType_fda;

  /// No description provided for @enzymeType_aryl.
  ///
  /// In en, this message translates to:
  /// **'Aryl'**
  String get enzymeType_aryl;

  /// No description provided for @errorLoadingEnzymes.
  ///
  /// In en, this message translates to:
  /// **'Error loading enzymes'**
  String get errorLoadingEnzymes;

  /// No description provided for @loadingEnzymes.
  ///
  /// In en, this message translates to:
  /// **'Loading enzymes...'**
  String get loadingEnzymes;

  /// No description provided for @noEnzymesRegisteredAdmin.
  ///
  /// In en, this message translates to:
  /// **'No enzymes registered.'**
  String get noEnzymesRegisteredAdmin;

  /// No description provided for @noEnzymesRegisteredUser.
  ///
  /// In en, this message translates to:
  /// **'No enzymes registered, please contact your Administrator to solve this issue.'**
  String get noEnzymesRegisteredUser;

  /// No description provided for @enzymeDeleted.
  ///
  /// In en, this message translates to:
  /// **'{enzymeName} deleted!'**
  String enzymeDeleted(String enzymeName);

  /// No description provided for @deleteEnzymeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete enzyme?'**
  String get deleteEnzymeTitle;

  /// No description provided for @deleteEnzymeContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this enzyme?'**
  String get deleteEnzymeContent;

  /// A message that shows the number of enzymes found
  ///
  /// In en, this message translates to:
  /// **'🧬 {count, plural, =0{No enzymes found} =1{1 enzyme found} other{{count} enzymes found}}'**
  String enzymesFound(int count);

  /// No description provided for @formulaLabel.
  ///
  /// In en, this message translates to:
  /// **'Formula: '**
  String get formulaLabel;

  /// No description provided for @variableALabel.
  ///
  /// In en, this message translates to:
  /// **'Variable A: '**
  String get variableALabel;

  /// No description provided for @variableBLabel.
  ///
  /// In en, this message translates to:
  /// **'Variable B: '**
  String get variableBLabel;

  /// No description provided for @enzymesSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Enzymes Summary'**
  String get enzymesSummaryTitle;

  /// Format for the enzyme tag, showing name and quantity
  ///
  /// In en, this message translates to:
  /// **'{enzymeName} ({quantity})'**
  String enzymeTagFormat(String enzymeName, int quantity);

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

  /// Label to show when an experiment was last modified
  ///
  /// In en, this message translates to:
  /// **'Modified on {date}'**
  String modifiedOn(String date);

  /// No description provided for @repetitions.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get repetitions;

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

  /// No description provided for @selectTreatment.
  ///
  /// In en, this message translates to:
  /// **'Select the treatment:'**
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
  /// **'Select the enzyme:'**
  String get selectEnzyme;

  /// No description provided for @selectedEnzymeType.
  ///
  /// In en, this message translates to:
  /// **'Selected enzyme type: {enzymeType}'**
  String selectedEnzymeType(String enzymeType);

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

  /// No description provided for @variableA_long.
  ///
  /// In en, this message translates to:
  /// **'Variable a - Angular Coefficient of the Curve'**
  String get variableA_long;

  /// No description provided for @variableB_long.
  ///
  /// In en, this message translates to:
  /// **'Variable b - Constant of the Curve Equation'**
  String get variableB_long;

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

  /// No description provided for @experimentCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Experiment created successfully!'**
  String get experimentCreatedSuccess;

  /// No description provided for @deleteExperimentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete experiment?'**
  String get deleteExperimentTitle;

  /// No description provided for @deleteExperimentContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this experiment?'**
  String get deleteExperimentContent;

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

  /// No description provided for @sample.
  ///
  /// In en, this message translates to:
  /// **'Sample'**
  String get sample;

  /// No description provided for @whiteSample.
  ///
  /// In en, this message translates to:
  /// **'White Sample'**
  String get whiteSample;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @orderBy.
  ///
  /// In en, this message translates to:
  /// **'Order by:'**
  String get orderBy;

  /// No description provided for @organizeInOrder.
  ///
  /// In en, this message translates to:
  /// **'Organize in order:'**
  String get organizeInOrder;

  /// No description provided for @filter_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get filter_name;

  /// No description provided for @filter_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get filter_description;

  /// No description provided for @filter_progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get filter_progress;

  /// No description provided for @filter_creationDate.
  ///
  /// In en, this message translates to:
  /// **'Creation date'**
  String get filter_creationDate;

  /// No description provided for @filter_modificationDate.
  ///
  /// In en, this message translates to:
  /// **'Modification date'**
  String get filter_modificationDate;

  /// No description provided for @order_ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get order_ascending;

  /// No description provided for @order_descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get order_descending;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Clear filters} =1{Clear filter} other{Clear filters}}'**
  String clearFilters(int count);

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Apply filters} =1{Apply filter} other{Apply filters}}'**
  String applyFilters(int count);

  /// No description provided for @error_serverConnectionRefused.
  ///
  /// In en, this message translates to:
  /// **'⚠ Server Error, please try again later.'**
  String get error_serverConnectionRefused;

  /// No description provided for @error_statusCodeAndMessage.
  ///
  /// In en, this message translates to:
  /// **'⚠ SC{statusCode} - {message}'**
  String error_statusCodeAndMessage(Object statusCode, Object message);

  /// No description provided for @error_messageOnly.
  ///
  /// In en, this message translates to:
  /// **'⚠ {message}'**
  String error_messageOnly(Object message);

  /// No description provided for @error_400.
  ///
  /// In en, this message translates to:
  /// **'⚠ Incorrect data: Some field is invalid or missing.'**
  String get error_400;

  /// No description provided for @error_401.
  ///
  /// In en, this message translates to:
  /// **'⚠ Not authorized: Token expired or invalid user.'**
  String get error_401;

  /// No description provided for @error_403.
  ///
  /// In en, this message translates to:
  /// **'⚠ Access denied: You do not have permission to perform this action.'**
  String get error_403;

  /// No description provided for @error_404_login.
  ///
  /// In en, this message translates to:
  /// **'⚠ User not found.'**
  String get error_404_login;

  /// No description provided for @error_404_generic.
  ///
  /// In en, this message translates to:
  /// **'⚠ Not found: This information may no longer exist.'**
  String get error_404_generic;

  /// No description provided for @error_422.
  ///
  /// In en, this message translates to:
  /// **'⚠ Unprocessable entity: The server understands the content type, but was unable to process the contained instructions.'**
  String get error_422;

  /// No description provided for @error_426.
  ///
  /// In en, this message translates to:
  /// **'⚠ Upgrade required: Invalid device ID.'**
  String get error_426;

  /// No description provided for @error_500.
  ///
  /// In en, this message translates to:
  /// **'⚠ Server Error: The request could not be fulfilled.'**
  String get error_500;

  /// No description provided for @error_502.
  ///
  /// In en, this message translates to:
  /// **'⚠ Bad Gateway: The service is unavailable.'**
  String get error_502;

  /// No description provided for @error_503.
  ///
  /// In en, this message translates to:
  /// **'⚠ Server Error: The service is temporarily unavailable.'**
  String get error_503;

  /// No description provided for @error_noNetwork.
  ///
  /// In en, this message translates to:
  /// **'⚠ No internet connection, check your network access and try again.'**
  String get error_noNetwork;

  /// No description provided for @error_noResultQuery.
  ///
  /// In en, this message translates to:
  /// **'⚠ Could not get {query}.'**
  String error_noResultQuery(Object query);

  /// No description provided for @validation_required.
  ///
  /// In en, this message translates to:
  /// **'⚠ Required field'**
  String get validation_required;

  /// No description provided for @validation_strongPassword.
  ///
  /// In en, this message translates to:
  /// **'⚠ Password does not meet the required pattern.'**
  String get validation_strongPassword;

  /// No description provided for @validation_alfanumeric.
  ///
  /// In en, this message translates to:
  /// **'⚠ Field does not accept special characters'**
  String get validation_alfanumeric;

  /// No description provided for @validation_name.
  ///
  /// In en, this message translates to:
  /// **'⚠ Invalid name'**
  String get validation_name;

  /// No description provided for @validation_phone.
  ///
  /// In en, this message translates to:
  /// **'⚠ Invalid number'**
  String get validation_phone;

  /// No description provided for @validation_cellphone.
  ///
  /// In en, this message translates to:
  /// **'⚠ Invalid number'**
  String get validation_cellphone;

  /// No description provided for @validation_passwordEquals.
  ///
  /// In en, this message translates to:
  /// **'⚠ The entered passwords do not match.'**
  String get validation_passwordEquals;

  /// No description provided for @validation_passwordMustBeDiff.
  ///
  /// In en, this message translates to:
  /// **'⚠ The new password cannot be the same as the current one.'**
  String get validation_passwordMustBeDiff;

  /// No description provided for @validation_notFound.
  ///
  /// In en, this message translates to:
  /// **'⚠ Not found'**
  String get validation_notFound;

  /// No description provided for @validation_emailEquals.
  ///
  /// In en, this message translates to:
  /// **'⚠ The entered emails do not match.'**
  String get validation_emailEquals;

  /// No description provided for @validation_email.
  ///
  /// In en, this message translates to:
  /// **'⚠ Invalid email'**
  String get validation_email;

  /// No description provided for @validation_cpf.
  ///
  /// In en, this message translates to:
  /// **'⚠ Invalid CPF'**
  String get validation_cpf;

  /// No description provided for @validation_cnpj.
  ///
  /// In en, this message translates to:
  /// **'⚠ Invalid CNPJ'**
  String get validation_cnpj;

  /// No description provided for @validation_numeric.
  ///
  /// In en, this message translates to:
  /// **'⚠ Invalid number'**
  String get validation_numeric;

  /// No description provided for @validation_number.
  ///
  /// In en, this message translates to:
  /// **'⚠ Invalid number'**
  String get validation_number;

  /// No description provided for @validation_greaterThanZeroDecimal.
  ///
  /// In en, this message translates to:
  /// **'⚠ Enter a number greater than zero'**
  String get validation_greaterThanZeroDecimal;

  /// No description provided for @validation_isInteger.
  ///
  /// In en, this message translates to:
  /// **'⚠ Enter an integer'**
  String get validation_isInteger;

  /// No description provided for @validation_greaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'⚠ Enter a number greater than zero'**
  String get validation_greaterThanZero;

  /// No description provided for @validation_maxNumber.
  ///
  /// In en, this message translates to:
  /// **'⚠ Number must be less than or equal to {value}.'**
  String validation_maxNumber(Object value);

  /// No description provided for @validation_maxChars.
  ///
  /// In en, this message translates to:
  /// **'⚠ This field must have a maximum of {value} character(s)'**
  String validation_maxChars(Object value);

  /// No description provided for @validation_maxAge.
  ///
  /// In en, this message translates to:
  /// **'⚠ Maximum age {value} years'**
  String validation_maxAge(Object value);

  /// No description provided for @validation_minAge.
  ///
  /// In en, this message translates to:
  /// **'⚠ Minimum age {value} years'**
  String validation_minAge(Object value);

  /// No description provided for @validation_minNumber.
  ///
  /// In en, this message translates to:
  /// **'⚠ Number must be greater than or equal to {value}.'**
  String validation_minNumber(Object value);

  /// No description provided for @validation_minChars.
  ///
  /// In en, this message translates to:
  /// **'⚠ This field must have a minimum of {value} character(s)'**
  String validation_minChars(Object value);

  /// No description provided for @validation_emailOrRegistration.
  ///
  /// In en, this message translates to:
  /// **'⚠ Invalid email or registration.'**
  String get validation_emailOrRegistration;

  /// No description provided for @connectionRestored.
  ///
  /// In en, this message translates to:
  /// **'✓ Connection restored'**
  String get connectionRestored;

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

  /// No description provided for @loginAgain.
  ///
  /// In en, this message translates to:
  /// **'Log in again.'**
  String get loginAgain;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data!'**
  String get noData;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

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

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancelButton;

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

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome {userName}!'**
  String welcomeMessage(String userName);

  /// No description provided for @helloWelcome.
  ///
  /// In en, this message translates to:
  /// **'Hello,\nwelcome!'**
  String get helloWelcome;

  /// No description provided for @forgotMyPassword.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password'**
  String get forgotMyPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @createOne.
  ///
  /// In en, this message translates to:
  /// **' Create one'**
  String get createOne;

  /// No description provided for @institutionLabel.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get institutionLabel;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @personalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personalData;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @access.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get access;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountButton;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccess;

  /// No description provided for @recoverEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Recovery email sent successfully!'**
  String get recoverEmailSent;

  /// No description provided for @recoverPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get recoverPassword;

  /// No description provided for @recoverPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email below. We will send you instructions to reset your password.'**
  String get recoverPasswordInstructions;

  /// No description provided for @sendRecoverEmail.
  ///
  /// In en, this message translates to:
  /// **'Send E-mail'**
  String get sendRecoverEmail;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get passwordResetSuccess;

  /// No description provided for @recoverCode.
  ///
  /// In en, this message translates to:
  /// **'Reset Code'**
  String get recoverCode;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match!'**
  String get passwordsDoNotMatch;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmPassword;

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

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @replaceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Replace language'**
  String get replaceLanguage;

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

  /// The translated value of the application environment
  ///
  /// In en, this message translates to:
  /// **'{env, select, dev{Development} stage{Stage} prod{Production} other{Unknown}}'**
  String environmentValue(String env);

  /// No description provided for @unableToOpenUrlError.
  ///
  /// In en, this message translates to:
  /// **'Could not access {url}'**
  String unableToOpenUrlError(String url);

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

  /// No description provided for @idealizationTextP4.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get idealizationTextP4;

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

  /// No description provided for @stringtest4.
  ///
  /// In en, this message translates to:
  /// **'Test4'**
  String get stringtest4;

  /// No description provided for @excel_treatmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Treatment:'**
  String get excel_treatmentLabel;

  /// No description provided for @excel_col_id.
  ///
  /// In en, this message translates to:
  /// **'Id'**
  String get excel_col_id;

  /// No description provided for @excel_col_sampleAbsorbance.
  ///
  /// In en, this message translates to:
  /// **'Sample Abs.'**
  String get excel_col_sampleAbsorbance;

  /// No description provided for @excel_col_whiteSampleAbsorbance.
  ///
  /// In en, this message translates to:
  /// **'White Abs.'**
  String get excel_col_whiteSampleAbsorbance;

  /// No description provided for @excel_col_difference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get excel_col_difference;

  /// No description provided for @excel_col_variableA.
  ///
  /// In en, this message translates to:
  /// **'Variable A'**
  String get excel_col_variableA;

  /// No description provided for @excel_col_variableB.
  ///
  /// In en, this message translates to:
  /// **'Variable B'**
  String get excel_col_variableB;

  /// No description provided for @excel_col_curveCalculation.
  ///
  /// In en, this message translates to:
  /// **'Curve Calc.'**
  String get excel_col_curveCalculation;

  /// No description provided for @excel_col_correctionFactor.
  ///
  /// In en, this message translates to:
  /// **'Corr. Factor'**
  String get excel_col_correctionFactor;

  /// No description provided for @excel_col_time.
  ///
  /// In en, this message translates to:
  /// **'Time (h)'**
  String get excel_col_time;

  /// No description provided for @excel_col_volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get excel_col_volume;

  /// No description provided for @excel_col_sampleWeight.
  ///
  /// In en, this message translates to:
  /// **'Sample Weight (g)'**
  String get excel_col_sampleWeight;

  /// No description provided for @excel_col_result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get excel_col_result;

  /// No description provided for @excel_footer_developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by:'**
  String get excel_footer_developedBy;

  /// No description provided for @excel_footer_learnMore.
  ///
  /// In en, this message translates to:
  /// **'👨🏻‍💻 LEARN MORE:'**
  String get excel_footer_learnMore;

  /// No description provided for @shareExperimentResultsFilename.
  ///
  /// In en, this message translates to:
  /// **'Results for experiment \"{experimentName}\"'**
  String shareExperimentResultsFilename(String experimentName);

  /// No description provided for @treatmentCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Treatment created successfully!'**
  String get treatmentCreatedSuccess;

  /// No description provided for @registerNewTreatment.
  ///
  /// In en, this message translates to:
  /// **'Register a new\ntreatment'**
  String get registerNewTreatment;

  /// No description provided for @treatmentIdentification.
  ///
  /// In en, this message translates to:
  /// **'Treatment Identification'**
  String get treatmentIdentification;

  /// No description provided for @createTreatmentButton.
  ///
  /// In en, this message translates to:
  /// **'Create treatment'**
  String get createTreatmentButton;

  /// No description provided for @errorLoadingTreatments.
  ///
  /// In en, this message translates to:
  /// **'Error loading treatments'**
  String get errorLoadingTreatments;

  /// No description provided for @loadingTreatments.
  ///
  /// In en, this message translates to:
  /// **'Loading treatments...'**
  String get loadingTreatments;

  /// No description provided for @treatmentsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Treatments not found'**
  String get treatmentsNotFound;

  /// No description provided for @treatmentDeleted.
  ///
  /// In en, this message translates to:
  /// **'{treatmentName} deleted!'**
  String treatmentDeleted(String treatmentName);

  /// No description provided for @deleteTreatmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete treatment?'**
  String get deleteTreatmentTitle;

  /// No description provided for @deleteTreatmentContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this treatment?'**
  String get deleteTreatmentContent;

  /// A message that shows the number of treatments found
  ///
  /// In en, this message translates to:
  /// **'🧪 {count, plural, =0{No treatments found} =1{1 treatment found} other{{count} treatments found}}'**
  String treatmentsFound(int count);

  /// Label to show when a treatment was created
  ///
  /// In en, this message translates to:
  /// **'Created on {date}'**
  String createdOn(String date);
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
