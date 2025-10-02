// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get connectionRestored => '✓ Connection restored';

  @override
  String get loginAgain => 'Log in again.';

  @override
  String get registerExperiment => 'Register\n Experiment';

  @override
  String get registerTreatment => 'Register\n Treatment';

  @override
  String get registerEnzyme => 'Register\n Enzyme';

  @override
  String get noInternetWarning =>
      '⚠ No connection to the server: You are viewing previously loaded and un-updated information, any offline changes will not be maintained!';

  @override
  String get experiments => 'Experiments';

  @override
  String get treatments => 'Treatments';

  @override
  String get enzymes => 'Enzymes';

  @override
  String get settings => 'Settings';

  @override
  String get info => 'Info';

  @override
  String get about => 'About Enzitech';

  @override
  String get frequentlyAskedQuestions => 'FAQ';

  @override
  String get userData => 'User Data';

  @override
  String get userName => 'Name';

  @override
  String get email => 'E-mail';

  @override
  String get userType => 'User Role';

  @override
  String roles(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administrator',
      'common': 'Common',
      'other': 'Common',
    });
    return '$_temp0';
  }

  @override
  String get deletionConfirmation => 'Deletion confirmation';

  @override
  String get theme => 'Theme';

  @override
  String get details => 'Details about Enzitech';

  @override
  String get environment => 'Environment';

  @override
  String get version => 'Version';

  @override
  String get exit => 'Exit';

  @override
  String get seeYouSoon => 'See you soon...';

  @override
  String get aboutTitle => 'About:';

  @override
  String get idealizationTitle => 'Idealization';

  @override
  String get developmentTeamTitle => 'Development Team';

  @override
  String get closeButton => 'Close';

  @override
  String get idealizationTextP1 =>
      ' was conceived as a solution for the study and realization of experiments in the field of soil enzymatic activities, idealized in conjunction with the ';

  @override
  String get idealizationTextP2 => ' and the ';

  @override
  String get idealizationTextP3 => ', located at the ';

  @override
  String get roleMobileDeveloper => '(Mobile developer)';

  @override
  String get roleBackendDeveloper => '(Back-end developer)';

  @override
  String get roleProjectManagement => '(Project Management)';

  @override
  String get roleProfessorBCC => '(Professor - BCC)';

  @override
  String get roleProfessorAgronomy => '(Professor - Agronomy)';

  @override
  String get question => 'Question: ';

  @override
  String get question1 => 'I\'m unable to create an enzyme. Why?';

  @override
  String get answer => 'Answer: ';

  @override
  String get answer1 =>
      'Creating new enzymes is a feature limited to administrators. Currently, adding a new enzyme to the system requires implementation by our team. Should you need a new enzyme type, please send a request to the system administrator.';

  @override
  String get selectTreatment => 'Select Treatment: ';

  @override
  String get loadingAvailableEnzymes => 'Loading available enzymes...';

  @override
  String get allEnzymesCalculated =>
      'All enzymes for this treatment have already been calculated!';

  @override
  String get selectEnzyme => 'Select enzyme: ';

  @override
  String selectedEnzymeType(String enzymeType) {
    return 'Selected enzyme type: $enzymeType';
  }

  @override
  String get nextButton => 'Next';

  @override
  String get backButton => 'Back';

  @override
  String get insertExperimentData => 'Insert data into experiment';

  @override
  String stepIndicatorMessage(int currentStep, int totalSteps) {
    return 'Step $currentStep of $totalSteps - Identification';
  }

  @override
  String get invalidExperimentTitle => 'Invalid experiment!';

  @override
  String get invalidExperimentMessage =>
      'It is not possible to proceed without treatment(s) and/or enzyme(s) data';

  @override
  String get chooseTreatmentAndEnzyme =>
      'Choose the treatment and enzyme to insert the data';

  @override
  String get calculateButton => 'Calculate';

  @override
  String stepIndicatorMessageFilling(int currentStep, int totalSteps) {
    return 'Step $currentStep of $totalSteps - Filling and calculation';
  }

  @override
  String repetitionDataTitle(int repetitionNumber) {
    return 'Data for repetition #$repetitionNumber';
  }

  @override
  String get saveAndExitButton => 'Save and exit';

  @override
  String get recalculateButton => 'Recalculate';

  @override
  String repetitionLabel(int repetitionNumber) {
    return 'Repetition $repetitionNumber:';
  }

  @override
  String get discrepantRepetitionWarning =>
      'This repetition is discrepant!\n\nIts value differs by more than 25% from the average of all repetitions.\n\nIf you want to change it, just press \"Recalculate\".';

  @override
  String get average => 'Average:';

  @override
  String get repetitionColumnTitle => 'REPETITION';

  @override
  String get resultColumnTitle => 'RESULT';

  @override
  String get statusColumnTitle => 'STATUS';

  @override
  String stepIndicatorMessageResults(int currentStep, int totalSteps) {
    return 'Step $currentStep of $totalSteps - Results';
  }

  @override
  String get nameLabel => 'Name';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get registerNewExperiment => 'Register a new experiment';

  @override
  String get experimentIdentification => 'Experiment Identification';

  @override
  String stepIndicatorIdentification(int currentStep, int totalSteps) {
    return 'Step $currentStep of $totalSteps - Identification';
  }

  @override
  String get repetitionsPerTreatmentLabel =>
      'Number of repetitions per treatment';

  @override
  String get goToTreatmentsButton => 'Go to treatments';

  @override
  String get treatmentsAndRepetitionsData => 'Treatments and Repetitions Data';

  @override
  String get noTreatmentsRegisteredError =>
      'No treatments registered! At least one treatment is required to proceed.';

  @override
  String stepIndicatorTreatments(int currentStep, int totalSteps) {
    return 'Step $currentStep of $totalSteps - Treatments and Repetitions';
  }

  @override
  String get experimentEnzymes => 'Experiment Enzymes';

  @override
  String enzymeTypeIs(String enzymeType) {
    return 'Enzyme type: $enzymeType';
  }

  @override
  String stepIndicatorEnzymes(int currentStep, int totalSteps) {
    return 'Step $currentStep of $totalSteps - Enzymes';
  }

  @override
  String get variableA => 'Variable A';

  @override
  String get variableB => 'Variable B';

  @override
  String get timeHours => 'Time (h)';

  @override
  String get solutionVolume => 'Solution Volume';

  @override
  String get sampleWeightGrams => 'Sample Weight (g)';

  @override
  String get correctionFactor => 'Correction Factor';

  @override
  String get curveInformation => 'Curve Information:';

  @override
  String get otherVariables => 'Other Variables:';

  @override
  String get createExperimentButton => 'Create Experiment';

  @override
  String stepIndicatorFillVariables(int currentStep, int totalSteps) {
    return 'Step $currentStep of $totalSteps - Fill variables';
  }

  @override
  String get repetitions => 'Repetitions';

  @override
  String get noData => 'No data!';

  @override
  String errorLoadingExperiment(String experimentName) {
    return 'Error loading experiment \"$experimentName\"';
  }

  @override
  String get loadingExperiment => 'Loading experiment...';

  @override
  String get tapToSeeMore => 'Tap to see more information';

  @override
  String get tapToHide => 'Tap to hide information';

  @override
  String get enzymaticCalculation => 'Enzymatic Calculation';

  @override
  String get results => 'Results';

  @override
  String get experimentDetails => 'Experiment Details';

  @override
  String experimentDeleted(String experimentName) {
    return '$experimentName deleted!';
  }

  @override
  String get loadingResults => 'Loading results...';

  @override
  String experimentHeader(String experimentName) {
    return 'Experiment: $experimentName';
  }

  @override
  String enzymeTypeHeader(String enzymeType, String formula) {
    return 'Type: $enzymeType ($formula)';
  }

  @override
  String get treatmentLabel => 'Treatment';

  @override
  String get shareFileError => 'Could not share the file, please try again.';

  @override
  String get spreadsheetSavedSuccess => 'Spreadsheet saved successfully!';

  @override
  String get spreadsheetSaveError =>
      'Could not save the spreadsheet, please try again.';

  @override
  String get columnId => 'ID';

  @override
  String get columnSample => 'Sample';

  @override
  String get columnWhiteSampleShort => 'W. Sample';

  @override
  String get columnWhiteSampleTooltip => 'White Sample';

  @override
  String get columnDifference => 'Difference';

  @override
  String get columnCurve => 'Curve';

  @override
  String get columnCorrectionFactorShort => 'C. Factor';

  @override
  String get columnVolume => 'Volume';

  @override
  String get columnSampleWeightShort => 'S. Weight';

  @override
  String get columnSampleWeightTooltip => 'Sample Weight';

  @override
  String get columnResult => 'Result';

  @override
  String get errorLoadingExperiments => 'Error loading experiments';

  @override
  String get loadingExperiments => 'Loading experiments...';

  @override
  String get experimentsNotFound => 'Experiments not found';

  @override
  String get undo => 'Undo';

  @override
  String get delete => 'Delete';

  @override
  String get allExperimentsDisplayed => 'All experiments displayed!';

  @override
  String get inProgress => 'In Progress';

  @override
  String get completed => 'Completed';

  @override
  String experimentsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count experiments found',
      one: '1 experiment found',
      zero: 'No experiments found',
    );
    return '🔬 $_temp0';
  }

  @override
  String modifiedOn(String date) {
    return 'Modified on $date';
  }

  @override
  String get deleteExperimentTitle => 'Delete experiment?';

  @override
  String get deleteExperimentContent =>
      'Are you sure you want to delete this experiment?';

  @override
  String get deleteButton => 'DELETE';

  @override
  String get cancelButton => 'CANCEL';

  @override
  String get filters => 'Filters';

  @override
  String get orderBy => 'Order by:';

  @override
  String get select => 'Select';

  @override
  String get organizeInOrder => 'Organize in order:';

  @override
  String get filter_name => 'Name';

  @override
  String get filter_description => 'Description';

  @override
  String get filter_progress => 'Progress';

  @override
  String get filter_creationDate => 'Creation date';

  @override
  String get filter_modificationDate => 'Modification date';

  @override
  String get order_ascending => 'Ascending';

  @override
  String get order_descending => 'Descending';

  @override
  String clearFilters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Clear filters',
      one: 'Clear filter',
      zero: 'Clear filters',
    );
    return '$_temp0';
  }

  @override
  String applyFilters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Apply filters',
      one: 'Apply filter',
      zero: 'Apply filters',
    );
    return '$_temp0';
  }

  @override
  String get experimentCreatedSuccess => 'Experiment created successfully!';

  @override
  String get treatmentCreatedSuccess => 'Treatment created successfully!';

  @override
  String get registerNewTreatment => 'Register a new\n Treatment';

  @override
  String get treatmentIdentification => 'Treatment Identification';

  @override
  String get createTreatmentButton => 'Create treatment';

  @override
  String get errorLoadingTreatments => 'Error loading treatments';

  @override
  String get loadingTreatments => 'Loading treatments...';

  @override
  String get treatmentsNotFound => 'Treatments not found';

  @override
  String treatmentDeleted(String treatmentName) {
    return '$treatmentName deleted!';
  }

  @override
  String get deleteTreatmentTitle => 'Delete treatment?';

  @override
  String get deleteTreatmentContent =>
      'Are you sure you want to delete this treatment?';

  @override
  String treatmentsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count treatments found',
      one: '1 treatment found',
      zero: 'No treatments found',
    );
    return '🧪 $_temp0';
  }

  @override
  String createdOn(String date) {
    return 'Created on $date';
  }

  @override
  String get enzymeCreatedSuccess => 'Enzyme created successfully!';

  @override
  String get registerNewEnzyme => 'Register a new\n Enzyme';

  @override
  String get enzymeIdentification => 'Enzyme Identification';

  @override
  String get variableA_long => 'Variable a - Angular Coefficient of the Curve';

  @override
  String get variableB_long => 'Variable b - Constant of the Curve Equation';

  @override
  String get chooseEnzymeType => 'Choose the enzyme type';

  @override
  String get createEnzymeButton => 'Create enzyme';

  @override
  String get enzymeType_betaGlucosidase => 'Beta-glucosidase';

  @override
  String get enzymeType_aryl => 'Aryl';

  @override
  String get enzymeType_acidPhosphatase => 'Acid Phosphatase';

  @override
  String get enzymeType_alkalinePhosphatase => 'Alkaline Phosphatase';

  @override
  String get enzymeType_urease => 'Urease';

  @override
  String get enzymeType_fda => 'FDA';

  @override
  String get errorLoadingEnzymes => 'Error loading enzymes';

  @override
  String get loadingEnzymes => 'Loading enzymes...';

  @override
  String get noEnzymesRegisteredAdmin => 'No enzymes registered.';

  @override
  String get noEnzymesRegisteredUser =>
      'No enzymes registered, please contact your Administrator to solve this issue.';

  @override
  String enzymeDeleted(String enzymeName) {
    return '$enzymeName deleted!';
  }

  @override
  String get deleteEnzymeTitle => 'Delete enzyme?';

  @override
  String get deleteEnzymeContent =>
      'Are you sure you want to delete this enzyme?';

  @override
  String enzymesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enzymes found',
      one: '1 enzyme found',
      zero: 'No enzymes found',
    );
    return '🧬 $_temp0';
  }

  @override
  String get formulaLabel => 'Formula: ';

  @override
  String get variableALabel => 'Variable A: ';

  @override
  String get variableBLabel => 'Variable B: ';

  @override
  String get enzymesSummaryTitle => 'Enzymes Summary';

  @override
  String enzymeTagFormat(String enzymeName, int quantity) {
    return '$enzymeName ($quantity)';
  }

  @override
  String environmentValue(String env) {
    String _temp0 = intl.Intl.selectLogic(env, {
      'dev': 'Development',
      'stage': 'Stage',
      'prod': 'Production',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String unableToOpenUrlError(String url) {
    return 'Could not access $url';
  }

  @override
  String get institutionLabel => 'Institution';

  @override
  String get signUp => 'Sign Up';

  @override
  String get personalData => 'Personal Data';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get access => 'Access';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get accountCreatedSuccess => 'Account created successfully!';

  @override
  String welcomeMessage(String userName) {
    return 'Welcome $userName!';
  }

  @override
  String get helloWelcome => 'Hello,\nwelcome!';

  @override
  String get forgotMyPassword => 'I forgot my password';

  @override
  String get loginButton => 'Login';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get createOne => ' Create one';

  @override
  String get excel_treatmentLabel => 'Treatment:';

  @override
  String get excel_col_id => 'Id';

  @override
  String get excel_col_sampleAbsorbance => 'Sample Abs.';

  @override
  String get excel_col_whiteSampleAbsorbance => 'White Sample Abs.';

  @override
  String get excel_col_difference => 'Difference A - B';

  @override
  String get excel_col_variableA => 'a - Angular Coefficient';

  @override
  String get excel_col_variableB => 'b - Curve Equation Constant';

  @override
  String get excel_col_curveCalculation => 'Curve Calculation';

  @override
  String get excel_col_correctionFactor => 'CF - Correction Factor';

  @override
  String get excel_col_time => 'Time (h)';

  @override
  String get excel_col_volume => 'Volume (Substrate Solution)';

  @override
  String get excel_col_sampleWeight => 'Sample Weight (g)';

  @override
  String get excel_col_result => 'Result';

  @override
  String get excel_footer_developedBy => 'Developed by:';

  @override
  String get excel_footer_learnMore => '👨🏻‍💻 LEARN MORE:';

  @override
  String shareExperimentResultsFilename(String experimentName) {
    return 'Results for experiment \"$experimentName\"';
  }

  @override
  String get sample => 'Sample';

  @override
  String get whiteSample => 'White Sample';

  @override
  String get error_serverConnectionRefused =>
      '⚠ Server Error, please try again later.';

  @override
  String error_statusCodeAndMessage(Object statusCode, Object message) {
    return '⚠ SC$statusCode - $message';
  }

  @override
  String error_messageOnly(Object message) {
    return '⚠ $message';
  }

  @override
  String get error_400 => '⚠ Incorrect data: Some field is invalid or missing.';

  @override
  String get error_401 => '⚠ Not authorized: Token expired or invalid user.';

  @override
  String get error_403 =>
      '⚠ Access denied: You do not have permission to perform this action.';

  @override
  String get error_404_login => '⚠ User not found.';

  @override
  String get error_404_generic =>
      '⚠ Not found: This information may no longer exist.';

  @override
  String get error_422 =>
      '⚠ Unprocessable entity: The server understands the content type, but was unable to process the contained instructions.';

  @override
  String get error_426 => '⚠ Upgrade required: Invalid device ID.';

  @override
  String get error_500 => '⚠ Server Error: The request could not be fulfilled.';

  @override
  String get error_503 =>
      '⚠ Server Error: The service is temporarily unavailable.';

  @override
  String get error_noNetwork =>
      '⚠ No internet connection, check your network access and try again.';

  @override
  String error_noResultQuery(Object query) {
    return '⚠ Could not get $query.';
  }
}
