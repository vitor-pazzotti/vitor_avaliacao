#!/bin/bash

sudo apt-get update > /dev/null 2>&1
sudo apt-get install zip unzip -y > /dev/null 2>&1
sudo apt-get install python3 -y > /dev/null 2>&1
sudo apt-get install python3-pip -y > /dev/null 2>&1
pip3 install requests > /dev/null 2>&1
pip3 install beautifulsoup4 > /dev/null 2>&1

mkdir -p VitorPazzotti
mkdir -p VitorPazzotti/bin
mkdir -p VitorPazzotti/crawler_crypto
mkdir -p VitorPazzotti/crawler_crypto/processados
mkdir -p VitorPazzotti/crawler_crypto/consolidados
mkdir -p VitorPazzotti/crawler_crypto/consolidados/transferidos
mkdir -p VitorPazzotti/crawler_dolar
mkdir -p VitorPazzotti/crawler_dolar/transferidos
mkdir -p VitorPazzotti/processados_json
mkdir -p VitorPazzotti/indexados

# Criação de Pcd $PWD && /usr/bin/astas no HDFS

hdfs dfs -mkdir /user/VitorPazzotti
hdfs dfs -mkdir /user/VitorPazzotti/input
hdfs dfs -mkdir /user/VitorPazzotti/input/processados
hdfs dfs -mkdir /user/VitorPazzotti/output
hdfs dfs -mkdir /user/VitorPazzotti/output/transferidos


wget -c https://github.com/vitor-pazzotti/vitor_avaliacao/archive/master.zip 
#unzip
unzip master.zip
#Apagando master zipada
rm -rf master.zip

#Movendo códigos .py para local desejado
mv vitor_avaliacao-master/CryptoCrawler.py VitorPazzotti/bin
mv vitor_avaliacao-master/dolar.py VitorPazzotti/bin

rm -rf vitor_avaliacao-master

echo "11 22 */1 * *  cd $PWD && /usr/bin/python3 $PWD/VitorPazzotti/bin/CryptoCrawler.py" >> /etc/crontab

echo "5 */1 * * * cd $PWD/VitorPazzotti/crawler_crypto && cp crypto_timestamp.csv"  >> /etc/crontab

echo "*/1 * * * * cd $PWD && /usr/bin/python3 $PWD/VitorPazzotti/bin/dolar.py" >> /etc/crontab

echo "12 22 */1 * * cd $PWD/VitorPazzotti/crawler_crypto && zip processados.zip crypto_timestamp.csv && mv processados.zip $PWD/VitorPazzotti/crawler_crypto/processados" >> /etc/crontab

echo "25 */1 * * *zip -r VitorPazzotti/crawler_crypto/consolidados/transferidos/transfer.zip VitorPazzotti/crawler_crypto/crypto_timestamp.csv" >> /etc/crontab

echo "16 22 */1 * * zip -r VitorPazzotti/crawler_dolar/transferidos/transfer.zip VitorPazzotti/crawler_dolar/dolar_data.csv" >> /etc/crontab

echo "25 */1 * * * cd $PWD/VitorPazzotti/crawler_crypto/consolidados && zip transferidos.zip crypto_timestamp.csv && mv transferidos.zip $PWD/VitorPazzotti/crawler_crypto/consolidados/transferidos" >> /etc/crontab

echo "14 22 */1 * * cd $PWD/VitorPazzotti/crawler_crypto/consolidados && hdfs dfs -put $PWD/VitorPazzotti/crawler_crypto/consolidados/crypto_timestamp.csv /user/VitorPazzotti/input" >> /etc/crontab

echo "14 22 */1 * * cd $PWD/VitorPazzotti/crawler_dolar && hdfs dfs -put $PWD/VitorPazzotti/crawler_dolar/dolar_data.csv /user/VitorPazzotti/input" >> /etc/crontab

echo "15 22 */1 * * hdfs dfs -cp /user/VitorPazzotti/input/crypto_timestamp.csv /user/VitorPazzotti/input/processados/crypto_timestamp.csv" >> /etc/crontab

echo "15 22 */1 * * hdfs dfs -cp /user/VitorPazzotti/input/dolar_data.csv /user/VitorPazzotti/input/processados/dolar_data.csv" >> /etc/crontab