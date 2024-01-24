# Enzitech App - Sistema de experimentos para cálculo de atividades enzimáticas do solo

![BCC - Coworking](https://img.shields.io/badge/BCC-Coworking-06BC67?logo=slack)
![last-commit](https://img.shields.io/github/last-commit/bcccoworkingufape/enzitech_app.svg)
![Dart - 3.2.3](https://img.shields.io/badge/Dart-3.2.3-02569B?logo=dart)
![Flutter - 3.16.8](https://img.shields.io/badge/Flutter-3.16.8-0175C2?logo=flutter)
![Android - Released](https://img.shields.io/badge/Android-Released-3DDC84?logo=android&logoColor=FFFFFF)
![iOS - In development](https://img.shields.io/badge/iOS-In_development-000000?logo=apple&logoColor=FFFFFF)

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.lohhans.enzitech&hl=pt"><img alt="Light" src="https://raw.githubusercontent.com/steverichey/google-play-badge-svg/266d2b2df26f10d3c00b8129a0bd9f6da6b19f00/img/pt-br_get.svg" width="45%"></a>
&nbsp; &nbsp; &nbsp; &nbsp;
  <a href="https://flutter.dev/"><img alt="Dark" src="https://github.com/bcccoworkingufape/enzitech_app/assets/30741312/63040ed9-9373-41bb-880d-99e80b182def" width="45%"></a>
</p>

![Enzitech](https://github.com/bcccoworkingufape/enzitech_app/assets/30741312/febe6481-6e75-4727-9aed-ce35601736e4)

## Desenvolvimento

Implementação de um aplicativo para cálculo de atividades enzimáticas do solo, iniciado na disciplina de "Gestão Ágil de Projetos de Software", no curso de [Ciência da Computação na Universidade Federal do Agreste de Pernambuco](http://www.ufape.edu.br/br/node/409), sob orientação do Prof. Dr. Rodrigo Gusmão de Carvalho Rocha.

Posteriormente este projeto tornou-se um [Trabalho de Conclusão de Curso](https://github.com/lohhans/tcc/tree/main), desenvolvido por [Armstrong Lohãns](https://github.com/lohhans) sob orientação também do do Prof. Dr. Rodrigo Gusmão de Carvalho Rocha. Alcançando assim o MVP planejado para o sistema que será utilizado pelo Laboratório de Enzimatologia e Microbiologia Agrícola/Ambiental (LEMA) da mesma instituição.

### Informações necessárias

- Ambiente configurado para desenvolvimento Flutter
- Executar `flutter pub get` para obter as dependencias do projeto
- Em `local.properties` adicionar as seguintes linhas ao fim do arquivo:

```properties
flutter.minSdkVersion=20
flutter.targetSdkVersion=34
flutter.compileSdkVersion=34
```

> Arquivo gerado em `enzitech_app\android\local.properties`

### Como gerar o log de alterações

Executar o comando abaixo no terminal, alterando para a data desejada afim de obter os últimos commits, no exemplo, substituir "YYYY-MM-DD" por uma data neste formato: "2023-12-31".

```bash
git --no-pager log --since=YYYY-MM-DD --date=format-local:'%d-%m-%Y %H:%M:%S' --pretty=format:'Desenvolvido por %an em %ad | %s' > lattest-changes.log
```