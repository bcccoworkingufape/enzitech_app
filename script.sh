# TODO: Ajustar

if [ "$1" = "--help" -o "$1" = "-h" ]
then
    echo "Script para gerenciar o ENZITECH automaticamente.

⚠️  Este Script deve ficar na raiz do projeto, da seguinte forma:
.
|__ .vscode/
|__ android/
|__ assets/
|__ ios/
|__ lib/
|__ test/
|__ web/
|   [...]
|__ script.sh 👈👈👈

Uso: ./script.sh [argumentos]

Opções globais:
-a, --apple                     Faz com que o script rode a limpeza de arquivos do iOS;
-c, --cocoapods                 Faz com que o script rode a limpeza de arquivos do Mac/Cocoapods;
-f, --flutter                   Usa o Flutter nativo ao invés do FVM;
-h, --help                      Imprime esta informação de uso;

Atenção: o argumento -c (ou --cocoapods) só funciona se previamente usado o argumento -a (ou --apple);
Exemplo: ./script.sh -a -c (✅)  |  ./script.sh -c (❌)"

else
    if [ "$1" = "--apple" -o "$1" = "-a" ]
    then
        if [ "$2" = "--cocoapods" -o "$2" = "-c" ]
        then
            echo "☑️ ENZITECH SCRIPT ☑️\n💻+ EXECUTANDO FLUTTER CLEAN, PUB GET, REINSTALANDO COCOAPODS E ATUALIZANDO OS PODS NOS REPOSITÓRIOS...\n"
        else
            echo "☑️ ENZITECH SCRIPT ☑️\n💻+ EXECUTANDO FLUTTER CLEAN, PUB GET E ATUALIZANDO OS PODS NOS REPOSITÓRIOS...\n"
        fi
    else
        echo "☑️ ENZITECH SCRIPT ☑️\n💻 EXECUTANDO FLUTTER CLEAN E PUB GET NOS REPOSITÓRIOS...\n"
    fi

    if [ "$3" = "--flutter" -o "$3" = "-f" ]
        then
            flutter clean && flutter pub get && echo "✅ FLUTTER CLEAN\n"
        else
            f clean && f pub get && echo "✅ FLUTTER CLEAN\n"

        fi

    "🔀 REMOÇÃO DE BRANCHS INATIVAS" && git fetch --prune && echo "\n------------------------------------------------------------------------- \n"


    echo "💻 LIMPANDO ARQUIVOS DE BUILD DO ANDROID...\n"

    if [ -d "build" ]
    then
        rm -R build
        echo "✅ build removido!\n"
    else
        echo "⚠️  Não foi possível remover build: o diretório não existe.\n"
    fi

    if [ -d "android/app/build" ]
    then
        rm -R android/app/build
        echo "✅ android/app/build removido!\n"
    else
        echo "⚠️  Não foi possível remover android/app/build: o diretório não existe.\n"
    fi

    if [ "$1" = "--alpha" -o "$1" = "-a" ]
    then
        cd ios/
        if [ -d "Pods" ]
        then
            rm -rf Pods/ Podfile.lock
            echo "☑️ ios/Pods & Podfile.lock removidos!\n"

            if [ "$2" = "--cocoapods" -o "$2" = "-c" ]
            then
                echo "🔐 É NECESSÁRIO INSERIR SUA SENHA E CONFIRMAR A REMOÇÃO E REINSTALAÇÃO DO COCOAPODS A SEGUIR:\n"
                sudo gem uninstall cocoapods && sudo gem install cocoapods
                echo "\n☑️ COCOAPODS REINSTALADO!\n"
            fi

            echo " ATUALIZANDO PODS...\n"
            pod cache clean --all
            pod setup
            pod install --repo-update
            echo "\n☑️ PODS ATUALIZADOS!\n"

        else
            echo "⚠️  Não foi possível remover ios/Pods e arquivo Podfile.lock: o arquivo e diretório não existem.\n"
        fi

        echo "✅  𝙎𝘾𝙍𝙄𝙋𝙏 𝙁𝙄𝙉𝘼𝙇𝙄𝙕𝘼𝘿𝙊  ✅"
    else
        echo "✅  𝙎𝘾𝙍𝙄𝙋𝙏 𝙁𝙄𝙉𝘼𝙇𝙄𝙕𝘼𝘿𝙊  ✅"
    fi
fi