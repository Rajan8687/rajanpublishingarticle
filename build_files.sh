# echo "BUILD START"
# python3.13 -m pip install -r requirements.txt
# python3.13 manage.py collectstatic --noinput --clear
# echo "BUILD END"


#!/bin/bash
echo "BUILD START"

# Install Python 3.13
apt-get update && apt-get install -y build-essential zlib1g-dev libssl-dev
wget https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tgz
tar -xzf Python-3.13.0.tgz
cd Python-3.13.0
./configure --enable-optimizations
make altinstall
cd ..

python3.13 -m pip install --upgrade pip
python3.13 -m pip install -r requirements.txt
python3.13 manage.py collectstatic --noinput --clear

echo "BUILD END"