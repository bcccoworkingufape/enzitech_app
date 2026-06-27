// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get enzymeCreatedSuccess => 'Enzima criada com sucesso!';

  @override
  String get registerNewEnzyme => 'Cadastre uma nova\nenzima';

  @override
  String get enzymeIdentification => 'IdentificaÃ§Ã£o da enzima';

  @override
  String get chooseEnzymeType => 'Escolha o tipo da enzima';

  @override
  String get createEnzymeButton => 'Criar enzima';

  @override
  String get enzymeType_acidPhosphatase => 'Fosfatase Ãcida';

  @override
  String get enzymeType_alkalinePhosphatase => 'Fosfatase Alcalina';

  @override
  String get enzymeType_arylsulfatase => 'Arilsulfatase';

  @override
  String get enzymeType_betaGlucosidase => 'Beta-Glicosidase';

  @override
  String get enzymeType_urease => 'Urease';

  @override
  String get enzymeType_fda => 'FDA';

  @override
  String get enzymeType_aryl => 'Aryl';

  @override
  String get errorLoadingEnzymes => 'Erro ao carregar enzimas';

  @override
  String get loadingEnzymes => 'Carregando enzimas...';

  @override
  String get noEnzymesRegisteredAdmin => 'Nenhuma enzima cadastrada.';

  @override
  String get noEnzymesRegisteredUser =>
      'Nenhuma enzima cadastrada, entre em contato com o seu Administrador para solucionar este problema.';

  @override
  String enzymeDeleted(String enzymeName) {
    return '$enzymeName excluÃ­do!';
  }

  @override
  String get deleteEnzymeTitle => 'Excluir a enzima?';

  @override
  String get deleteEnzymeContent =>
      'VocÃª tem certeza que deseja excluir esta enzima?';

  @override
  String enzymesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enzimas encontradas',
      one: '1 enzima encontrada',
      zero: 'Nenhuma enzima encontrada',
    );
    return 'ðŸ§¬ $_temp0';
  }

  @override
  String get formulaLabel => 'FÃ³rmula: ';

  @override
  String get variableALabel => 'VariÃ¡vel A: ';

  @override
  String get variableBLabel => 'VariÃ¡vel B: ';

  @override
  String get enzymesSummaryTitle => 'SumÃ¡rio de enzimas';

  @override
  String enzymeTagFormat(String enzymeName, int quantity) {
    return '$enzymeName ($quantity)';
  }

  @override
  String get variableA => 'VariÃ¡vel A';

  @override
  String get variableB => 'VariÃ¡vel B';

  @override
  String modifiedOn(String date) {
    return 'Modificado em $date';
  }

  @override
  String get repetitions => 'RepetiÃ§Ãµes';

  @override
  String errorLoadingExperiment(String experimentName) {
    return 'Erro ao carregar o experimento \"$experimentName\"';
  }

  @override
  String get loadingExperiment => 'Carregando experimento...';

  @override
  String get tapToSeeMore => 'Toque para ver mais informaÃ§Ãµes';

  @override
  String get tapToHide => 'Toque para ocultar as informaÃ§Ãµes';

  @override
  String get enzymaticCalculation => 'CÃ¡lculo enzimÃ¡tico';

  @override
  String get results => 'Resultados';

  @override
  String get experimentDetails => 'Detalhes do experimento';

  @override
  String experimentDeleted(String experimentName) {
    return '$experimentName excluÃ­do!';
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
      'NÃ£o foi possÃ­vel compartilhar o arquivo, tente novamente.';

  @override
  String get spreadsheetSavedSuccess => 'Planilha salva com sucesso!';

  @override
  String get spreadsheetSaveError =>
      'NÃ£o foi possÃ­vel salvar a planilha, tente novamente.';

  @override
  String get columnId => 'ID';

  @override
  String get columnSample => 'Amostra';

  @override
  String get columnWhiteSampleShort => 'Am. Branca';

  @override
  String get columnWhiteSampleTooltip => 'Amostra Branca';

  @override
  String get columnDifference => 'DiferenÃ§a';

  @override
  String get columnCurve => 'Curva';

  @override
  String get columnCorrectionFactorShort => 'F. de CorreÃ§Ã£o';

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
  String get experimentsNotFound => 'Experimentos nÃ£o encontrados';

  @override
  String get allExperimentsDisplayed => 'Todos os experimentos exibidos!';

  @override
  String get inProgress => 'Em andamento';

  @override
  String get completed => 'ConcluÃ­do';

  @override
  String experimentsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count experimentos encontrados',
      one: '1 experimento encontrado',
      zero: 'Nenhum experimento encontrado',
    );
    return 'ðŸ”¬ $_temp0';
  }

  @override
  String get selectTreatment => 'Selecione o tratamento:';

  @override
  String get loadingAvailableEnzymes => 'Carregando enzimas disponÃ­veis...';

  @override
  String get allEnzymesCalculated =>
      'Todas as enzimas para este tratamento jÃ¡ foram calculadas!';

  @override
  String get selectEnzyme => 'Selecione a enzima:';

  @override
  String selectedEnzymeType(String enzymeType) {
    return 'Tipo da enzima selecionada: $enzymeType';
  }

  @override
  String get insertExperimentData => 'Inserir dados no experimento';

  @override
  String stepIndicatorMessage(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - IdentificaÃ§Ã£o';
  }

  @override
  String get invalidExperimentTitle => 'Experimento invÃ¡lido!';

  @override
  String get invalidExperimentMessage =>
      'NÃ£o Ã© possÃ­vel prosseguir sem dados de tratamento(s) e/ou enzima(s)';

  @override
  String get chooseTreatmentAndEnzyme =>
      'Escolha o tratamento e a enzima para inserir os dados';

  @override
  String get calculateButton => 'Calcular';

  @override
  String stepIndicatorMessageFilling(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - Preenchimento e cÃ¡lculo';
  }

  @override
  String repetitionDataTitle(int repetitionNumber) {
    return 'Dados da $repetitionNumberÂª repetiÃ§Ã£o';
  }

  @override
  String get saveAndExitButton => 'Salvar e sair';

  @override
  String get recalculateButton => 'Recalcular';

  @override
  String repetitionLabel(int repetitionNumber) {
    return 'RepetiÃ§Ã£o $repetitionNumber:';
  }

  @override
  String get discrepantRepetitionWarning =>
      'Esta repetiÃ§Ã£o estÃ¡ discrepante!\n\nO valor dela difere acima de 25% da mÃ©dia de todas as repetiÃ§Ãµes.\n\nCaso queira mudar, basta pressionar \"Recalcular\".';

  @override
  String get average => 'MÃ©dia:';

  @override
  String get repetitionColumnTitle => 'REPETIÃ‡ÃƒO';

  @override
  String get resultColumnTitle => 'RESULTADO';

  @override
  String get statusColumnTitle => 'STATUS';

  @override
  String stepIndicatorMessageResults(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - Resultados';
  }

  @override
  String get registerNewExperiment => 'Cadastre um novo experimento';

  @override
  String get experimentIdentification => 'IdentificaÃ§Ã£o do experimento';

  @override
  String stepIndicatorIdentification(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - IdentificaÃ§Ã£o';
  }

  @override
  String get repetitionsPerTreatmentLabel =>
      'Quantidade de repetiÃ§Ãµes por tratamento';

  @override
  String get goToTreatmentsButton => 'Ir para tratamentos';

  @override
  String get treatmentsAndRepetitionsData =>
      'Dados dos tratamentos e repetiÃ§Ãµes';

  @override
  String get noTreatmentsRegisteredError =>
      'Nenhum tratamento cadastrado! Ã‰ necessÃ¡rio pelo menos um tratamento para prosseguir.';

  @override
  String stepIndicatorTreatments(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - Tratamentos e RepetiÃ§Ãµes';
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
  String get variableA_long => 'VariÃ¡vel a - Coeficiente Angular da Curva';

  @override
  String get variableB_long => 'VariÃ¡vel b - Constante da EquaÃ§Ã£o da Curva';

  @override
  String get timeHours => 'Tempo (h)';

  @override
  String get solutionVolume => 'Volume da SoluÃ§Ã£o';

  @override
  String get sampleWeightGrams => 'Peso da amostra (g)';

  @override
  String get correctionFactor => 'Fator de correÃ§Ã£o';

  @override
  String get curveInformation => 'InformaÃ§Ãµes da Curva:';

  @override
  String get otherVariables => 'Demais VariÃ¡veis:';

  @override
  String get createExperimentButton => 'Criar Experimento';

  @override
  String stepIndicatorFillVariables(int currentStep, int totalSteps) {
    return 'Etapa $currentStep de $totalSteps - Preencher variÃ¡veis';
  }

  @override
  String get experimentCreatedSuccess => 'Experimento criado com sucesso!';

  @override
  String get deleteExperimentTitle => 'Excluir o experimento?';

  @override
  String get deleteExperimentContent =>
      'VocÃª tem certeza que deseja excluir este experimento?';

  @override
  String get nameLabel => 'Nome';

  @override
  String get descriptionLabel => 'DescriÃ§Ã£o';

  @override
  String get sample => 'Amostra';

  @override
  String get whiteSample => 'Amostra branca';

  @override
  String get filters => 'Filtros';

  @override
  String get orderBy => 'Ordenar por:';

  @override
  String get organizeInOrder => 'Organizar em ordem:';

  @override
  String get filter_name => 'Nome';

  @override
  String get filter_description => 'DescriÃ§Ã£o';

  @override
  String get filter_progress => 'Progresso';

  @override
  String get filter_creationDate => 'Data de criaÃ§Ã£o';

  @override
  String get filter_modificationDate => 'Data de modificaÃ§Ã£o';

  @override
  String get order_ascending => 'Crescente';

  @override
  String get order_descending => 'Decrescente';

  @override
  String clearFilters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Limpar filtros',
      one: 'Limpar filtro',
      zero: 'Limpar filtros',
    );
    return '$_temp0';
  }

  @override
  String applyFilters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aplicar filtros',
      one: 'Aplicar filtro',
      zero: 'Aplicar filtros',
    );
    return '$_temp0';
  }

  @override
  String get error_serverConnectionRefused =>
      'âš  Erro de Servidor, tente novamente mais tarde.';

  @override
  String error_statusCodeAndMessage(Object statusCode, Object message) {
    return 'âš  SC$statusCode - $message';
  }

  @override
  String error_messageOnly(Object message) {
    if (message.toString().isEmpty) {
      return 'âš Ocorreu um erro inesperado. Tente novamente.';
    }
    return 'âš  $message';
  }

  @override
  String get error_400 =>
      'âš  Dados incorretos: Algum campo invÃ¡lido ou ausente.';

  @override
  String get error_401 =>
      'âš  NÃ£o autorizado: Token expirado ou usuÃ¡rio invÃ¡lido.';

  @override
  String get error_403 =>
      'âš  Acesso negado: VocÃª nÃ£o tem permissÃ£o para executar esta aÃ§Ã£o.';

  @override
  String get error_404_login => 'âš  UsuÃ¡rio nÃ£o encontrado.';

  @override
  String get error_404_generic =>
      'âš  NÃ£o encontrado: Talvez essa informaÃ§Ã£o nÃ£o exista mais.';

  @override
  String get error_422 =>
      'âš  Entidade nÃ£o processÃ¡vel: NÃ£o foi possÃ­vel processar as instruÃ§Ãµes presentes.';

  @override
  String get error_426 => 'âš  Upgrade requerido: ID de dispositivo invÃ¡lido.';

  @override
  String get error_500 =>
      'âš  Erro do Servidor: NÃ£o foi possÃ­vel atender Ã  solicitaÃ§Ã£o.';

  @override
  String get error_503 =>
      'âš  Erro do Servidor: NÃ£o foi possÃ­vel atender Ã  solicitaÃ§Ã£o neste momento.';

  @override
  String get error_noNetwork =>
      'âš  Sem conexÃ£o com a internet, verifique seu acesso Ã  rede e tente novamente.';

  @override
  String error_noResultQuery(Object query) {
    return 'âš  NÃ£o foi possÃ­vel obter $query.';
  }

  @override
  String get validation_required => 'âš  Campo obrigatÃ³rio';

  @override
  String get validation_strongPassword =>
      'âš  Senha nÃ£o atende ao padrÃ£o informado.';

  @override
  String get validation_alfanumeric =>
      'âš  Campo nÃ£o aceita caracteres especiais';

  @override
  String get validation_name => 'âš  Nome invÃ¡lido';

  @override
  String get validation_phone => 'âš  NÃºmero invÃ¡lido';

  @override
  String get validation_cellphone => 'âš  NÃºmero invÃ¡lido';

  @override
  String get validation_passwordEquals =>
      'âš  As senhas digitadas nÃ£o coincidem.';

  @override
  String get validation_passwordMustBeDiff =>
      'âš  A nova senha nÃ£o pode ser igual a senha atual.';

  @override
  String get validation_notFound => 'âš  NÃ£o encontrado';

  @override
  String get validation_emailEquals => 'âš  Os e-mails digitados nÃ£o coincidem.';

  @override
  String get validation_email => 'âš  E-mail invÃ¡lido';

  @override
  String get validation_cpf => 'âš  CPF invÃ¡lido';

  @override
  String get validation_cnpj => 'âš  CNPJ invÃ¡lido';

  @override
  String get validation_numeric => 'âš  NÃºmero invÃ¡lido';

  @override
  String get validation_number => 'âš  NÃºmero invÃ¡lido';

  @override
  String get validation_greaterThanZeroDecimal =>
      'âš  Insira um nÃºmero maior que zero';

  @override
  String get validation_isInteger => 'âš  Insira um nÃºmero inteiro';

  @override
  String get validation_greaterThanZero => 'âš  Insira um nÃºmero maior que zero';

  @override
  String validation_maxNumber(Object value) {
    return 'âš  NÃºmero deve ser menor ou igual a $value.';
  }

  @override
  String validation_maxChars(Object value) {
    return 'âš  Esse campo deve ter no mÃ¡ximo $value caractere(s)';
  }

  @override
  String validation_maxAge(Object value) {
    return 'âš  Idade mÃ¡xima $value anos';
  }

  @override
  String validation_minAge(Object value) {
    return 'âš  Idade mÃ­nima $value anos';
  }

  @override
  String validation_minNumber(Object value) {
    return 'âš  NÃºmero deve ser maior ou igual a $value.';
  }

  @override
  String validation_minChars(Object value) {
    return 'âš  Esse campo deve ter no mÃ­nimo $value caractere(s)';
  }

  @override
  String get validation_emailOrRegistration =>
      'âš  E-mail ou matrÃ­cula invÃ¡lido.';

  @override
  String get connectionRestored => 'âœ“ ConexÃ£o reestabelecida';

  @override
  String get noInternetWarning =>
      'âš  Sem conexÃ£o com o servidor: VocÃª estÃ¡ visualizando informaÃ§Ãµes previamente carregadas e sem atualizaÃ§Ãµes, quaisquer mudanÃ§as offline nÃ£o serÃ£o mantidas!';

  @override
  String get experiments => 'Experimentos';

  @override
  String get treatments => 'Tratamentos';

  @override
  String get enzymes => 'Enzimas';

  @override
  String get settings => 'ConfiguraÃ§Ãµes';

  @override
  String get nextButton => 'PrÃ³ximo';

  @override
  String get backButton => 'Voltar';

  @override
  String get loginAgain => 'FaÃ§a seu login novamente.';

  @override
  String get noData => 'Sem dados!';

  @override
  String get select => 'Selecionar';

  @override
  String get tryAgain => 'Tentar Novamente';

  @override
  String get undo => 'Desfazer';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteButton => 'EXCLUIR';

  @override
  String get cancelButton => 'CANCELAR';

  @override
  String get registerExperiment => 'Cadastrar\n Experimento';

  @override
  String get registerTreatment => 'Cadastrar\n Tratamento';

  @override
  String get registerEnzyme => 'Cadastrar\n Enzima';

  @override
  String welcomeMessage(String userName) {
    return 'Bem vindo(a) $userName!';
  }

  @override
  String get helloWelcome => 'OlÃ¡,\nseja bem vindo(a)!';

  @override
  String get forgotMyPassword => 'Esqueci minha senha';

  @override
  String get loginButton => 'Entrar';

  @override
  String get dontHaveAnAccount => 'NÃ£o possui uma conta?';

  @override
  String get createOne => ' Crie uma';

  @override
  String get institutionLabel => 'InstituiÃ§Ã£o';

  @override
  String get signUp => 'Cadastre-se';

  @override
  String get personalData => 'Dados pessoais';

  @override
  String get email => 'E-mail';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get confirmPasswordLabel => 'Confirmar senha';

  @override
  String get access => 'Acesso';

  @override
  String get createAccountButton => 'Criar conta';

  @override
  String get accountCreatedSuccess => 'Conta criada com sucesso!';

  @override
  String get info => 'InformaÃ§Ãµes';

  @override
  String get about => 'Sobre o Enzitech';

  @override
  String get frequentlyAskedQuestions => 'Perguntas frequentes';

  @override
  String get userData => 'Dados do UsuÃ¡rio';

  @override
  String get userName => 'Nome';

  @override
  String get userType => 'Tipo de usuÃ¡rio';

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
  String get deletionConfirmation => 'ConfirmaÃ§Ã£o de exclusÃ£o';

  @override
  String get languages => 'Idiomas';

  @override
  String get replaceLanguage => 'Substituir idioma';

  @override
  String get theme => 'Tema';

  @override
  String get details => 'Detalhes sobre o Enzitech';

  @override
  String get environment => 'Ambiente';

  @override
  String get version => 'VersÃ£o';

  @override
  String get exit => 'Sair';

  @override
  String get seeYouSoon => 'AtÃ© logo...';

  @override
  String environmentValue(String env) {
    String _temp0 = intl.Intl.selectLogic(env, {
      'dev': 'Desenvolvimento',
      'stage': 'Teste',
      'prod': 'ProduÃ§Ã£o',
      'other': 'Desconhecido',
    });
    return '$_temp0';
  }

  @override
  String unableToOpenUrlError(String url) {
    return 'NÃ£o foi possÃ­vel acessar $url';
  }

  @override
  String get aboutTitle => 'Sobre:';

  @override
  String get idealizationTitle => 'IdealizaÃ§Ã£o';

  @override
  String get developmentTeamTitle => 'Equipe de desenvolvimento';

  @override
  String get closeButton => 'Fechar';

  @override
  String get idealizationTextP1 =>
      ' foi concebido como uma soluÃ§Ã£o para o estudo e realizaÃ§Ã£o de experimentos no campo das atividades enzimÃ¡ticas do solo, idealizado em conjunto pelo ';

  @override
  String get idealizationTextP2 => ' e o ';

  @override
  String get idealizationTextP3 => ', localizados na ';

  @override
  String get idealizationTextP4 => '.';

  @override
  String get roleMobileDeveloper => '(Desenvolvedor mobile)';

  @override
  String get roleBackendDeveloper => '(Desenvolvedor back-end)';

  @override
  String get roleProjectManagement => '(GestÃ£o do Projeto)';

  @override
  String get roleProfessorBCC => '(Docente - BCC)';

  @override
  String get roleProfessorAgronomy => '(Docente - Agronomia)';

  @override
  String get question => 'Pergunta: ';

  @override
  String get question1 => 'Por que nÃ£o consigo criar enzimas?';

  @override
  String get answer => 'Resposta: ';

  @override
  String get answer1 =>
      'A funcionalidade de criaÃ§Ã£o de enzimas Ã© restrita ao adminstrador do Enzitech, pois atualmente para o cadastro de uma enzima Ã© necessÃ¡rio sua implementaÃ§Ã£o atÃ© que a mesma possa estar disponÃ­vel para uso, caso necessite de algum novo tipo de enzima solicite ao administrador do sistema.';

  @override
  String get stringtest4 => 'Teste4';

  @override
  String get excel_treatmentLabel => 'Tratamento:';

  @override
  String get excel_col_id => 'Id';

  @override
  String get excel_col_sampleAbsorbance => 'Abs. Amostra';

  @override
  String get excel_col_whiteSampleAbsorbance => 'Abs. Branco';

  @override
  String get excel_col_difference => 'DiferenÃ§a';

  @override
  String get excel_col_variableA => 'VariÃ¡vel A';

  @override
  String get excel_col_variableB => 'VariÃ¡vel B';

  @override
  String get excel_col_curveCalculation => 'CÃ¡lc. Curva';

  @override
  String get excel_col_correctionFactor => 'Fator CorreÃ§Ã£o';

  @override
  String get excel_col_time => 'Tempo (h)';

  @override
  String get excel_col_volume => 'Volume';

  @override
  String get excel_col_sampleWeight => 'Peso Amostra (g)';

  @override
  String get excel_col_result => 'Resultado';

  @override
  String get excel_footer_developedBy => 'Desenvolvido por:';

  @override
  String get excel_footer_learnMore => 'ðŸ‘¨ðŸ»â€ðŸ’» SAIBA MAIS:';

  @override
  String shareExperimentResultsFilename(String experimentName) {
    return 'Resultados do experimento \"$experimentName\"';
  }

  @override
  String get treatmentCreatedSuccess => 'Tratamento criado com sucesso!';

  @override
  String get registerNewTreatment => 'Cadastre um novo\ntratamento';

  @override
  String get treatmentIdentification => 'IdentificaÃ§Ã£o do tratamento';

  @override
  String get createTreatmentButton => 'Criar tratamento';

  @override
  String get errorLoadingTreatments => 'Erro ao carregar tratamentos';

  @override
  String get loadingTreatments => 'Carregando tratamentos...';

  @override
  String get treatmentsNotFound => 'Tratamentos nÃ£o encontrados';

  @override
  String treatmentDeleted(String treatmentName) {
    return '$treatmentName excluÃ­do!';
  }

  @override
  String get deleteTreatmentTitle => 'Excluir o tratamento?';

  @override
  String get deleteTreatmentContent =>
      'VocÃª tem certeza que deseja excluir este tratamento?';

  @override
  String treatmentsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tratamentos encontrados',
      one: '1 tratamento encontrado',
      zero: 'Nenhum tratamento encontrado',
    );
    return 'ðŸ§ª $_temp0';
  }

  @override
  String createdOn(String date) {
    return 'Criado em $date';
  }
}

