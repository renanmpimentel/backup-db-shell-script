#!/bin/bash
U_PASTA="/home/user/backup-db" 
U_DATA=$(/bin/date +%d-%m-%Y--%H-%M-%S)
U_CAMINHO="backup-$U_DATA.sql"
U_HOST="localhost"
U_USER="root"
U_PASSWORD="ingasoft"
U_DATABASE="bunker"
#
erro=""
#
cd $U_PASTA
#
# Fazer o backup usando o mysqldump
# mysqldump --opt -h [servidor do banco] -u [usuario] -p [database] > backup.sql 
#
mysqldump -h $U_HOST -u $U_USER -p$U_PASSWORD $U_DATABASE > $U_CAMINHO
# 
# $? Código de retorno do último comando executado
# -ne (Diferente)
# 
if [ $? -ne 0 ]
then
    erro="Erro na geracao do SQL"
fi
# 
# Compacta o arquivo com o gzip, veja se o gzip está instalado em seu sistema
# Debian/Ubuntu -> apt-get install gzip
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
#
# let -> Adiciona ou remove valores de uma variável
# -gt (Maior que)
# -le (Menor igual)
#
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