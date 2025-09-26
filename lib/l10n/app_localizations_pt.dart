// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get connectionRestored => '✓ Conexão reestabelecida';

  @override
  String get loginAgain => 'Faça seu login novamente.';

  @override
  String get registerExperiment => 'Cadastrar\n Experimento';

  @override
  String get registerTreatment => 'Cadastrar\n Tratamento';

  @override
  String get registerEnzyme => 'Cadastrar\n Enzima';

  @override
  String get noInternetWarning =>
      '⚠ Sem conexão com o servidor: Você está visualizando informações previamente carregadas e sem atualizações, quaisquer mudanças offline não serão mantidas!';

  @override
  String get experiments => 'Experimentos';

  @override
  String get treatments => 'Tratamentos';

  @override
  String get enzymes => 'Enzimas';

  @override
  String get settings => 'Configurações';

  @override
  String get info => 'Informações';

  @override
  String get about => 'Sobre o Enzitech';

  @override
  String get frequentlyAskedQuestions => 'Perguntas frequentes';

  @override
  String get userData => 'Dados do Usuário';

  @override
  String get userName => 'Nome';

  @override
  String get email => 'E-mail';

  @override
  String get userType => 'Tipo de usuário';

  @override
  String roles(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administrador',
      'common': 'Comum',
      'other': 'Comum',
    });
    return '$_temp0';
  }

  @override
  String get deletionConfirmation => 'Confirmação de exclusão';

  @override
  String get theme => 'Tema';

  @override
  String get details => 'Detalhes sobre o Enzitech';

  @override
  String get environment => 'Ambiente';

  @override
  String get version => 'Versão';

  @override
  String get exit => 'Sair';

  @override
  String get seeYouSoon => 'Até logo...';

  @override
  String get aboutTitle => 'Sobre:';

  @override
  String get idealizationTitle => 'Idealização';

  @override
  String get developmentTeamTitle => 'Equipe de desenvolvimento';

  @override
  String get closeButton => 'Fechar';

  @override
  String get idealizationTextP1 =>
      ' foi concebido como uma solução para o estudo e realização de experimentos no campo das atividades enzimáticas do solo, idealizado em conjunto pelo ';

  @override
  String get idealizationTextP2 => ' e o ';

  @override
  String get idealizationTextP3 => ', localizados na ';

  @override
  String get roleMobileDeveloper => '(Desenvolvedor mobile)';

  @override
  String get roleBackendDeveloper => '(Desenvolvedor back-end)';

  @override
  String get roleProjectManagement => '(Gestão do Projeto)';

  @override
  String get roleProfessorBCC => '(Docente - BCC)';

  @override
  String get roleProfessorAgronomy => '(Docente - Agronomia)';

  @override
  String get question => 'Pergunta: ';

  @override
  String get question1 => 'Por que não consigo criar enzimas?';

  @override
  String get answer => 'Resposta: ';

  @override
  String get answer1 =>
      'A funcionalidade de criação de enzimas é restrita ao adminstrador do Enzitech, pois atualmente para o cadastro de uma enzima é necessário sua implementação até que a mesma possa estar disponível para uso, caso necessite de algum novo tipo de enzima solicite ao administrador do sistema.';

  @override
  String get selectTreatment => 'Selecione o tratamento:';

  @override
  String get loadingAvailableEnzymes => 'Carregando enzimas disponíveis...';

  @override
  String get allEnzymesCalculated =>
      'Todas as enzimas para este tratamento já foram calculadas!';

  @override
  String get selectEnzyme => 'Selecione a enzima:';

  @override
  String selectedEnzymeType(String enzymeType) {
    return 'Tipo da enzima selecionada: $enzymeType';
  }

  @override
  String get nextButton => 'Próximo';

  @override
  String get backButton => 'Voltar';

  @override
  String get insertExperimentData => 'Inserir dados no experimento';

  @override
  String stepIndicatorMessage(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - Identificação';
  }

  @override
  String get invalidExperimentTitle => 'Experimento inválido!';

  @override
  String get invalidExperimentMessage =>
      'Não é possível prosseguir sem dados de tratamento(s) e/ou enzima(s)';

  @override
  String get chooseTreatmentAndEnzyme =>
      'Escolha o tratamento e a enzima para inserir os dados';

  @override
  String get calculateButton => 'Calcular';

  @override
  String stepIndicatorMessageFilling(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - Preenchimento e cálculo';
  }

  @override
  String repetitionDataTitle(int repetitionNumber) {
    return 'Dados da $repetitionNumberª repetição';
  }

  @override
  String get saveAndExitButton => 'Salvar e sair';

  @override
  String get recalculateButton => 'Recalcular';

  @override
  String repetitionLabel(int repetitionNumber) {
    return 'Repetição $repetitionNumber:';
  }

  @override
  String get discrepantRepetitionWarning =>
      'Esta repetição está discrepante!\n\nO valor dela difere acima de 25% da média de todas as repetições.\n\nCaso queira mudar, basta pressionar \"Recalcular\".';

  @override
  String get average => 'Média:';

  @override
  String get repetitionColumnTitle => 'REPETIÇÃO';

  @override
  String get resultColumnTitle => 'RESULTADO';

  @override
  String get statusColumnTitle => 'STATUS';

  @override
  String stepIndicatorMessageResults(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - Resultados';
  }

  @override
  String get nameLabel => 'Nome';

  @override
  String get descriptionLabel => 'Descrição';

  @override
  String get registerNewExperiment => 'Cadastre um novo experimento';

  @override
  String get experimentIdentification => 'Identificação do experimento';

  @override
  String stepIndicatorIdentification(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - Identificação';
  }

  @override
  String get repetitionsPerTreatmentLabel =>
      'Quantidade de repetições por tratamento';

  @override
  String get goToTreatmentsButton => 'Ir para tratamentos';

  @override
  String get treatmentsAndRepetitionsData =>
      'Dados dos tratamentos e repetições';

  @override
  String get noTreatmentsRegisteredError =>
      'Nenhum tratamento cadastrado! É necessário pelo menos um tratamento para prosseguir.';

  @override
  String stepIndicatorTreatments(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - Tratamentos e Repetições';
  }

  @override
  String get experimentEnzymes => 'Enzimas do experimento';

  @override
  String enzymeTypeIs(String enzymeType) {
    return 'Tipo da enzima: $enzymeType';
  }

  @override
  String stepIndicatorEnzymes(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - Enzimas';
  }

  @override
  String get variableA => 'Variável A';

  @override
  String get variableB => 'Variável B';

  @override
  String get timeHours => 'Tempo (h)';

  @override
  String get solutionVolume => 'Volume da Solução';

  @override
  String get sampleWeightGrams => 'Peso da amostra (g)';

  @override
  String get correctionFactor => 'Fator de correção';

  @override
  String get curveInformation => 'Informações da Curva:';

  @override
  String get otherVariables => 'Demais Variáveis:';

  @override
  String get createExperimentButton => 'Criar Experimento';

  @override
  String stepIndicatorFillVariables(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - Preencher variáveis';
  }

  @override
  String get repetitions => 'Repetições';

  @override
  String get noData => 'Sem dados!';

  @override
  String errorLoadingExperiment(String experimentName) {
    return 'Erro ao carregar o experimento \"$experimentName\"';
  }

  @override
  String get loadingExperiment => 'Carregando experimento...';

  @override
  String get tapToSeeMore => 'Toque para ver mais informações';

  @override
  String get tapToHide => 'Toque para ocultar as informações';

  @override
  String get enzymaticCalculation => 'Cálculo enzimático';

  @override
  String get results => 'Resultados';

  @override
  String get experimentDetails => 'Detalhes do experimento';

  @override
  String experimentDeleted(String experimentName) {
    return '$experimentName excluído!';
  }

  @override
  String get loadingResults => 'Carregando resultados...';

  @override
  String experimentHeader(String experimentName) {
    return 'Experimento: $experimentName';
  }

  @override
  String enzymeTypeHeader(String enzymeType, String formula) {
    return 'Tipo: $enzymeType ($formula)';
  }

  @override
  String get treatmentLabel => 'Tratamento';

  @override
  String get shareFileError =>
      'Não foi possível compartilhar o arquivo, tente novamente.';

  @override
  String get spreadsheetSavedSuccess => 'Planilha salva com sucesso!';

  @override
  String get spreadsheetSaveError =>
      'Não foi possível salvar a planilha, tente novamente.';

  @override
  String get columnId => 'ID';

  @override
  String get columnSample => 'Amostra';

  @override
  String get columnWhiteSampleShort => 'Am. Branca';

  @override
  String get columnWhiteSampleTooltip => 'Amostra Branca';

  @override
  String get columnDifference => 'Diferença';

  @override
  String get columnCurve => 'Curva';

  @override
  String get columnCorrectionFactorShort => 'F. de Correção';

  @override
  String get columnVolume => 'Volume';

  @override
  String get columnSampleWeightShort => 'Peso da Am.';

  @override
  String get columnSampleWeightTooltip => 'Peso da Amostra';

  @override
  String get columnResult => 'Resultado';

  @override
  String get errorLoadingExperiments => 'Erro ao carregar experimentos';

  @override
  String get loadingExperiments => 'Carregando experimentos...';

  @override
  String get experimentsNotFound => 'Experimentos não encontrados';

  @override
  String get undo => 'Desfazer';

  @override
  String get delete => 'Excluir';

  @override
  String get allExperimentsDisplayed => 'Todos os experimentos exibidos!';

  @override
  String get inProgress => 'Em andamento';

  @override
  String get completed => 'Concluído';

  @override
  String experimentsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count experimentos encontrados',
      one: '1 experimento encontrado',
      zero: 'Nenhum experimento encontrado',
    );
    return '🔬 $_temp0';
  }
}
