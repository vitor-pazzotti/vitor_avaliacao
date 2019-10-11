#!/bin/bash

sudo apt-get update -y > /dev/null 2>&1
sudo apt-get install zip unzip -y > /dev/null 2>&1
sudo apt-get install python3 -y > /dev/null 2>&1
sudo apt-get install python3-pip -y > /dev/null 2>&1
pip3 install requests > /dev/null 2>&1
pip3 install beautifulsoup4 > /dev/null 2>&1


mkdir vitorPazzotti
mkdir vitorPazzotti/bin
mkdir vitorPazzotti/crawler_crypto
mkdir vitorPazzotti/crawler_crypto/processados
mkdir vitorPazzotti/crawler_crypto/consolidados
mkdir vitorPazzotti/crawler_crypto/consolidados/transferidos
mdkir vitorPazzotti/crawler_dolar
mdkir vitorPazzotti/crawler_dolar/transferidos
mdkir vitorPazzotti/processados_json
mdkir vitorPazzotti/processados_json/indexados

##Pasta no HDFS
# hdfs -dfs mkdir user
# hdfs -dfs mkdir vitorPazzotti
# hdfs -dfs mkdir vitorPazzotti/input
# hdfs -dfs mkdir vitorPazzotti/input/processados
# hdfs -dfs mkdir vitorPazzotti/output
# hdfs -dfs mkdir vitorPazzotti/output/transferidos

wget -c https://github.com/vitor-pazzotti/vitor_avaliacao/archive/master.zip 
unzip master.zip
rm -rf master.zip

mv vitor_avaliacao-master/CryptoCrawler.py vitorPazzotti/bin
mv vitor_avaliacao-master/dolar.py vitorPazzotti/bin
rm -rf vitor_avaliacao-master

##Crontab de execucao do arquivo Crypto e dolar
(crontab -l 2>/dev/null; echo "*/2 * * * * cd $PWD && /usr/bin/python3 $PWD/vitorPazzotti/bin/CryptoCrawler.py") | crontab -
(crontab -l 2>/dev/null; echo "30 14 */1 * * cd $PWD && /usr/bin/python3 $PWD/vitorPazzotti/bin/dolar.py") | crontab -

(crontab -l 2>/dev/null; echo "32 14 */1 * * mv $PWD/vitorPazzotti/crawler_crypto/*.csv $PWD/vitorPazzotti/crawler_crypto/consolidados") | crontab -



