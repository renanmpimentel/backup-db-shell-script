#!/bin/bash
U_PASTA="/home/user/backup-db" 
U_DATA=$(/bin/date +%d-%m-%Y--%H-%M-%S)
U_CAMINHO="backup-$U_DATA.sql"
U_HOST="localhost"
U_USER="root"
U_PASSWORD="******"
U_DATABASE="nome_do_bando_de_dados"
#
erro=""
#
cd $U_PASTA
#
# Faz o backup do MySQL
#
mysqldump -h $U_HOST -u $U_USER -p$U_PASSWORD $U_DATABASE > $U_CAMINHO
# 
# $? Código de retorno do último comando executado
# 
if [ $? -ne 0 ]
then
    erro="Erro na geracao do SQL"
fi
# 
# Compacta o arquivo
#
if [ "$erro" == "" ]
then
    gzip $U_CAMINHO
    if [ $? -ne 0 ]
    then
        erro="Erro ao compactar o SQL"
    fi
fi
#
# Apaga arquivos antigos e mantem apenas os 'n' ultimos
#
n=10
c=0
for i in *.sql.gz
do
    let c=$c+1
done

if [ $c -gt $n ]
then
    for i in *.sql.gz
    do
        if [ $c -le $n ]
        then
            break
        fi
        rm $i
        let c=$c-1
    done
fi
#
# Volta para a pasta anterior
# 
cd -