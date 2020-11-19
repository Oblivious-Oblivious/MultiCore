rem Install Qt
echo "--------------------------"
echo "Installing Qt Framework..."
echo "--------------------------"
rem Via the installer or grap the spesific .DDL's or .SO's
echo "--------------------------"
echo "Qt Framework is installed."
echo "--------------------------"

rem Install libtins
echo
echo "--------------------------"
echo "Installing Tins library..."
echo "--------------------------"

rem apt-get install -y libpcap-dev libssl-dev cmake
rem git clone https://github.com/mfontanini/libtins.git

cd libs
cd libtins
mkdir build
cd build
cmake ../ -DPCAP_ROOT_DIR=../../winpcap -DLIBTINS_ENABLE_CXX11=1
make
make install
cd ../..
cp libtins/build/lib/libtins.so libs/
mv libtins libs/
echo "--------------------------"
echo "Tins library is installed."
echo "--------------------------"

### Install Qml-Ruby ###
echo
echo "----------------------"
echo "Installing Qml-Ruby..."
echo "----------------------"
gem install qml -- --with-qmake=/opt/Qt/5.11.1/gcc_64/bin/qmake
echo "----------------------"
echo "Qml-Ruby is installed."
echo "----------------------"

### Install PCRE ###
echo
echo "--------------------------"
echo "Installing PCRE library..."
echo "--------------------------"
apt-get install -y libpcre3-dev
tar -xvjf pcre-8.00.tar.bz2
cd pcre-8.00
./configure
make
make install
cd ../
mv pcre-8.00.tar.bz2 pcre-8.00/
chmod 644 pcre-8.00
mv pcre-8.00 libs/
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
echo "--------------------------"
echo "PCRE library is installed."
echo "--------------------------"

### Install Swig ###
echo
echo "------------------"
echo "Installing Swig..."
echo "------------------"
apt-get install -y autotools-dev automake
#git clone https://github.com/swig/swig.git swig-3.0.12
tar -xvzf swig-3.0.12.tar.gz
cd swig-3.0.12
#./autogen.sh
./configure
make
make install
cd ..
mv swig-3.0.12.tar.gz swig-3.0.12/
mv swig-3.0.12 libs/
echo "------------------"
echo "Swig is installed."
echo "------------------"
