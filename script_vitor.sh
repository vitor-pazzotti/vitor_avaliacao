#!/bin/bash
# if [ -e "VitorPazzotti/" ]; then
#     echo "Pastas Existentes"
# else
#     echo "As pastas serao criadas"
    # Criando Pastas Locais
#Instalação de componentes
sudo apt-get install python3-pip
pip3 install requests
pip3 install beautifulsoup4

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

#Passos
#download do github
# if [ -e "vitor_avaliacao-master"]; then
#     echo "Repositorio Clonado"
# else
#     echo "Repositorio foi clonado"
wget -c https://github.com/vitor-pazzotti/vitor_avaliacao/archive/master.zip 
#unzip
unzip master.zip
#Apagando master zipada
rm -rf master.zip

#Movendo códigos .py para local desejado
sudo mv vitor_avaliacao-master/CryptoCrawler.py VitorPazzotti/bin
sudo mv vitor_avaliacao-master/dolar.py VitorPazzotti/bin

rm -rf vitor_avaliacao-master
# (crontab -l 2>/dev/null; echo "*/01 * * * * python3 VitorPazzotti/bin/CryptoCrawler.py") | crontab -
(crontab -l 2>/dev/null; echo "*/1 * * * * cd $PWD && /usr/bin/python3 $PWD/VitorPazzotti/bin/CryptoCrawler.py") | crontab -
#  python3 VitorPazzotti/bin/CryptoCrawler.py
#  (crontab -l 2>/dev/null; echo "*/01 * * * * python3 VitorPazzotti/bin/dolar.py") | crontab -
python3 VitorPazzotti/bin/dolar.py

# mv crypto_timestamp.csv VitorPazzotti/crawler_crypto
# mv dolar_data.csv VitorPazzotti/crawler_dolar

mv VitorPazzotti/crawler_crypto/crypto_timestamp.csv VitorPazzotti/crawler_crypto/consolidados
zip -r VitorPazzotti/crawler_crypto/consolidados/transferidos/transfer.zip VitorPazzotti/crawler_crypto/consolidados/crypto_timestamp.csv
zip -r VitorPazzotti/crawler_dolar/transferidos/transfer.zip VitorPazzotti/crawler_dolar/dolar_data.csv

# hdfs dfs -put $PWD/crypto_timestamp.csv /user/VitorPazzotti/input
# hdfs dfs -put $PWD/dolar_data.csv /user/VitorPazzotti/input

