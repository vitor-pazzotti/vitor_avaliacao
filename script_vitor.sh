#!/bin/bash

# Criando Pastas Locais
mkdir -p VitorPazzotti
mkdir -p VitorPazzotti/bin
mkdir -p VitorPazzotti/crawler_crypto
mkdir -p VitorPazzotti/crawler_crypto/processados
mkdir -p VitorPazzotti/crawler_crypto/consolidados
mkdir -p VitorPazzotti/crawler_crypto/consolidados/transferidos
mkdir -p VitorPazzotti/crawler_dolar
mkdir -p VitorPazzotti/processados_json
mkdir -p VitorPazzotti/indexados

# Criação de Pastas no HDFS
hdfs dfs -mkdir user/VitorPazzotti
hdfs dfs -mkdir user/VitorPazzotti/input
hdfs dfs -mkdir user/VitorPazzotti/input/processados
hdfs dfs -mkdir user/VitorPazzotti/output
hdfs dfs -mkdir user/VitorPazzotti/output/transferidos

#Instalação de componentes
pip install beautifulsoup4

#Passos
#download do github
wget -c https://github.com/vitor-pazzotti/vitor_avaliacao/archive/master.zip
#unzip
unzip master.zip
#Apagando master zipada
rm -rf master.zip
#Movendo códigos .py para local desejado
cp vitor_avaliacao-master/CryptoCrawler.py /VitorPazzotti/bin 
cp vitor_avaliacao-master/dolar.py /VitorPazzotti/bin 
#Executando programa python e passando o csv como resposta para pasta certa.
python3 CryptoCrawler.py
cp /VitorPazzotti/bin/crypto_timestamp.csv VitorPazzotti/crawler_crypto
python3 dolar.py
cp /VitorPazzotti/bin/dolar_data.csv VitorPazzotti/crawler_dolar





