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
  String get enzymeIdentification => 'Identificação da enzima';

  @override
  String get chooseEnzymeType => 'Escolha o tipo da enzima';

  @override
  String get createEnzymeButton => 'Criar enzima';

  @override
  String get enzymeType_acidPhosphatase => 'Fosfatase Ácida';

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
    return '$enzymeName excluído!';
  }

  @override
  String get deleteEnzymeTitle => 'Excluir a enzima?';

  @override
  String get deleteEnzymeContent =>
      'Você tem certeza que deseja excluir esta enzima?';

  @override
  String enzymesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enzimas encontradas',
      one: '1 enzima encontrada',
      zero: 'Nenhuma enzima encontrada',
    );
    return '🧬 $_temp0';
  }

  @override
  String get formulaLabel => 'Fórmula: ';

  @override
  String get variableALabel => 'Variável A: ';

  @override
  String get variableBLabel => 'Variável B: ';

  @override
  String get enzymesSummaryTitle => 'Sumário de enzimas';

  @override
  String enzymeTagFormat(String enzymeName, int quantity) {
    return '$enzymeName ($quantity)';
  }

  @override
  String get variableA => 'Variável A';

  @override
  String get variableB => 'Variável B';

  @override
  String modifiedOn(String date) {
    return 'Modificado em $date';
  }

  @override
  String get repetitions => 'Repetições';

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

  @override
  String get selectTreatment => 'Selecione o tratamento:';

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
  String repetitionLabel(int repetitionNumber) {
    return 'Repetição $repetitionNumber:';
  }

  @override
  String get pending => 'Pendente';

  @override
  String get fillRepetitionsTitle => 'Preencha os dados de cada repetição';

  @override
  String get saveRepetitionButton => 'Salvar repetição';

  @override
  String get repetitionSavedMessage => 'Repetição salva com sucesso!';

  @override
  String get finishButton => 'Concluir';

  @override
  String get editExperimentTitle => 'Editar experimento';

  @override
  String get editExperimentTooltip => 'Editar experimento';

  @override
  String get saveChangesButton => 'Salvar alterações';

  @override
  String get experimentUpdatedSuccess => 'Experimento atualizado com sucesso!';

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
  String get treatmentsAndRepetitionsData =>
      'Dados dos tratamentos e repetições';

  @override
  String get noTreatmentsRegisteredError =>
      'Nenhum tratamento cadastrado! É necessário pelo menos um tratamento para prosseguir.';

  @override
  String get addTreatmentButton => 'Adicionar tratamento';

  @override
  String get noTreatmentsAddedYet => 'Nenhum tratamento adicionado ainda';

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
  String get variableA_long => 'Variável a - Coeficiente Angular da Curva';

  @override
  String get variableB_long => 'Variável b - Constante da Equação da Curva';

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
  String get experimentCreatedSuccess => 'Experimento criado com sucesso!';

  @override
  String get deleteExperimentTitle => 'Excluir o experimento?';

  @override
  String get deleteExperimentContent =>
      'Você tem certeza que deseja excluir este experimento?';

  @override
  String get nameLabel => 'Nome';

  @override
  String get descriptionLabel => 'Descrição';

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
  String get filter_description => 'Descrição';

  @override
  String get filter_progress => 'Progresso';

  @override
  String get filter_creationDate => 'Data de criação';

  @override
  String get filter_modificationDate => 'Data de modificação';

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
      '⚠ Erro de Servidor, tente novamente mais tarde.';

  @override
  String error_statusCodeAndMessage(Object statusCode, Object message) {
    return '⚠ SC$statusCode - $message';
  }

  @override
  String error_messageOnly(Object message) {
    return '⚠ $message';
  }

  @override
  String get error_400 =>
      '⚠ Dados incorretos: Algum campo inválido ou ausente.';

  @override
  String get error_401 =>
      '⚠ Não autorizado: Token expirado ou usuário inválido.';

  @override
  String get error_403 =>
      '⚠ Acesso negado: Você não tem permissão para executar esta ação.';

  @override
  String get error_404_login => '⚠ Usuário não encontrado.';

  @override
  String get error_404_generic =>
      '⚠ Não encontrado: Talvez essa informação não exista mais.';

  @override
  String get error_422 =>
      '⚠ Entidade não processável: Não foi possível processar as instruções presentes.';

  @override
  String get error_426 => '⚠ Upgrade requerido: ID de dispositivo inválido.';

  @override
  String get error_500 =>
      '⚠ Erro do Servidor: Não foi possível atender à solicitação.';

  @override
  String get error_502 =>
      '⚠ Bad Gateway: Não foi possível atender à solicitação.';

  @override
  String get error_503 =>
      '⚠ Erro do Servidor: Não foi possível atender à solicitação neste momento.';

  @override
  String get error_noNetwork =>
      '⚠ Sem conexão com a internet, verifique seu acesso à rede e tente novamente.';

  @override
  String error_noResultQuery(Object query) {
    return '⚠ Não foi possível obter $query.';
  }

  @override
  String get error_emailNotRegistered =>
      '⚠ O e-mail não está cadastrado em nossa base de dados.';

  @override
  String get error_invalidCode => '⚠ Código inválido.';

  @override
  String get error_invalidOrNotFoundCode =>
      '⚠ Código inválido ou não encontrado.';

  @override
  String get error_codeExpired =>
      '⚠ O código expirou. Por favor, solicite um novo.';

  @override
  String get error_newPasswordSameAsCurrent =>
      '⚠ A nova senha não pode ser igual à senha atual.';

  @override
  String get validation_required => '⚠ Campo obrigatório';

  @override
  String get validation_strongPassword =>
      '⚠ Senha não atende ao padrão informado.';

  @override
  String get validation_alfanumeric =>
      '⚠ Campo não aceita caracteres especiais';

  @override
  String get validation_name => '⚠ Nome inválido';

  @override
  String get validation_phone => '⚠ Número inválido';

  @override
  String get validation_cellphone => '⚠ Número inválido';

  @override
  String get validation_passwordEquals =>
      '⚠ As senhas digitadas não coincidem.';

  @override
  String get validation_passwordMustBeDiff =>
      '⚠ A nova senha não pode ser igual a senha atual.';

  @override
  String get validation_notFound => '⚠ Não encontrado';

  @override
  String get validation_emailEquals => '⚠ Os e-mails digitados não coincidem.';

  @override
  String get validation_email => '⚠ E-mail inválido';

  @override
  String get validation_cpf => '⚠ CPF inválido';

  @override
  String get validation_cnpj => '⚠ CNPJ inválido';

  @override
  String get validation_numeric => '⚠ Número inválido';

  @override
  String get validation_number => '⚠ Número inválido';

  @override
  String get validation_greaterThanZeroDecimal =>
      '⚠ Insira um número maior que zero';

  @override
  String get validation_isInteger => '⚠ Insira um número inteiro';

  @override
  String get validation_greaterThanZero => '⚠ Insira um número maior que zero';

  @override
  String validation_maxNumber(Object value) {
    return '⚠ Número deve ser menor ou igual a $value.';
  }

  @override
  String validation_maxChars(Object value) {
    return '⚠ Esse campo deve ter no máximo $value caractere(s)';
  }

  @override
  String validation_maxAge(Object value) {
    return '⚠ Idade máxima $value anos';
  }

  @override
  String validation_minAge(Object value) {
    return '⚠ Idade mínima $value anos';
  }

  @override
  String validation_minNumber(Object value) {
    return '⚠ Número deve ser maior ou igual a $value.';
  }

  @override
  String validation_minChars(Object value) {
    return '⚠ Esse campo deve ter no mínimo $value caractere(s)';
  }

  @override
  String get validation_emailOrRegistration =>
      '⚠ E-mail ou matrícula inválido.';

  @override
  String get connectionRestored => '✓ Conexão reestabelecida';

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
  String get nextButton => 'Próximo';

  @override
  String get backButton => 'Voltar';

  @override
  String get loginAgain => 'Faça seu login novamente.';

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
  String get helloWelcome => 'Olá,\nseja bem vindo(a)!';

  @override
  String get forgotMyPassword => 'Esqueci minha senha';

  @override
  String get loginButton => 'Entrar';

  @override
  String get dontHaveAnAccount => 'Não possui uma conta?';

  @override
  String get createOne => ' Crie uma';

  @override
  String get institutionLabel => 'Instituição';

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
  String get passwordRequirementsTitle => 'Sua senha deve conter:';

  @override
  String get passwordRequirement_minLength => 'Mínimo de 8 caracteres';

  @override
  String get passwordRequirement_uppercase => 'Uma letra maiúscula';

  @override
  String get passwordRequirement_lowercase => 'Uma letra minúscula';

  @override
  String get passwordRequirement_specialChar =>
      'Um caractere especial (ex: !@#\$%)';

  @override
  String get recoverEmailSent => 'E-mail de recuperação enviado com sucesso!';

  @override
  String get recoverPassword => 'Recuperar Senha';

  @override
  String get recoverPasswordInstructions =>
      'Informe seu e-mail abaixo. Enviaremos as instruções para você redefinir a sua senha.';

  @override
  String get sendRecoverEmail => 'Enviar E-mail';

  @override
  String get verifyCodeTitle => 'Verificar Código';

  @override
  String get verifyCodeInstructions =>
      'Digite o código de 6 dígitos que enviamos para o seu e-mail.';

  @override
  String get verifyCodeButton => 'Verificar';

  @override
  String get resetPassword => 'Redefinir Senha';

  @override
  String get passwordResetSuccess => 'Senha redefinida com sucesso!';

  @override
  String get recoverCode => 'Código de Recuperação';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem!';

  @override
  String get newPassword => 'Nova Senha';

  @override
  String get confirmPassword => 'Confirmar Nova Senha';

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
  String get version => 'Versão';

  @override
  String get exit => 'Sair';

  @override
  String get seeYouSoon => 'Até logo...';

  @override
  String environmentValue(String env) {
    String _temp0 = intl.Intl.selectLogic(env, {
      'dev': 'Desenvolvimento',
      'stage': 'Teste',
      'prod': 'Produção',
      'other': 'Desconhecido',
    });
    return '$_temp0';
  }

  @override
  String unableToOpenUrlError(String url) {
    return 'Não foi possível acessar $url';
  }

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
  String get idealizationTextP4 => '.';

  @override
  String get roleMobileDeveloper => '(Desenvolvedor mobile)';

  @override
  String get roleBackendDeveloper => '(Desenvolvedor back-end)';

  @override
  String get roleMobileBackendDev => '(Desenvolvedor mobile & back-end)';

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
  String get excel_col_difference => 'Diferença';

  @override
  String get excel_col_variableA => 'Variável A';

  @override
  String get excel_col_variableB => 'Variável B';

  @override
  String get excel_col_curveCalculation => 'Cálc. Curva';

  @override
  String get excel_col_correctionFactor => 'Fator Correção';

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
  String get excel_footer_learnMore => '👨🏻‍💻 SAIBA MAIS:';

  @override
  String shareExperimentResultsFilename(String experimentName) {
    return 'Resultados do experimento \"$experimentName\"';
  }

  @override
  String get treatmentCreatedSuccess => 'Tratamento criado com sucesso!';

  @override
  String get registerNewTreatment => 'Cadastre um novo\ntratamento';

  @override
  String get treatmentIdentification => 'Identificação do tratamento';

  @override
  String get createTreatmentButton => 'Criar tratamento';

  @override
  String get errorLoadingTreatments => 'Erro ao carregar tratamentos';

  @override
  String get loadingTreatments => 'Carregando tratamentos...';

  @override
  String get treatmentsNotFound => 'Tratamentos não encontrados';

  @override
  String treatmentDeleted(String treatmentName) {
    return '$treatmentName excluído!';
  }

  @override
  String get deleteTreatmentTitle => 'Excluir o tratamento?';

  @override
  String get deleteTreatmentContent =>
      'Você tem certeza que deseja excluir este tratamento?';

  @override
  String treatmentsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tratamentos encontrados',
      one: '1 tratamento encontrado',
      zero: 'Nenhum tratamento encontrado',
    );
    return '🧪 $_temp0';
  }

  @override
  String createdOn(String date) {
    return 'Criado em $date';
  }

  @override
  String get deleteAccount => 'Excluir minha conta';

  @override
  String get deleteAccountTitle => 'Excluir minha conta';

  @override
  String get deleteAccountDescription =>
      'Esta ação é permanente e não poderá ser desfeita.';

  @override
  String get deleteAccountItemExperiments =>
      'Todos os seus experimentos, repetições e resultados serão excluídos';

  @override
  String get deleteAccountItemTreatments =>
      'Todos os seus tratamentos serão excluídos';

  @override
  String get deleteAccountItemAccess =>
      'Você perderá o acesso imediatamente e os dados não poderão ser recuperados';

  @override
  String get deleteAccountConfirmationLabel =>
      'Para confirmar, digite seu e-mail';

  @override
  String get deleteAccountConfirmationMismatch =>
      'O e-mail digitado não corresponde ao da sua conta.';

  @override
  String get deleteAccountConfirmButton => 'EXCLUIR MINHA CONTA';

  @override
  String get deleteAccountSuccess => 'Sua conta foi excluída.';

  @override
  String get deleteAccountNoConnection =>
      'Conecte-se à internet para excluir sua conta.';
}
