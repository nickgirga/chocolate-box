#!/usr/bin/bash
# build-win-x86_64.sh
# by Nicholas Girga
# Builds a Chocolate Box executable for x86_64 Windows using MSYS2 and PyInstaller


# Variables
APP_VERSION="1.0"
PYINSTALLER_SOURCE="https://files.pythonhosted.org/packages/c9/41/fbb2f0e6e1934a47a99295d67ba178477f8809ae939c96608c711596f478/pyinstaller-5.1.tar.gz" # where the PyInstaller archive is downloaded from


# Check if MSYS2 environment
pacman -Qi msys2-runtime &> /dev/null && echo Building executable for Windows... || { echo ERROR!: This environment is not supported for building Chocolate Box for Windows. Please use MSYS2.; exit 1; }
echo


# Check if x86_64
if ! [ "`uname -m`" == "x86_64" ];
then
	echo ERROR!: This CPU architecture is not supported by this build script.
	exit 2
fi


# Update system packages
echo Updating System Packages...
pacman -Syyu --noconfirm
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to update the system packages!
	exit 3
fi
echo Finished Updating System Packages!
echo


# Install native dependencies
echo Installing Dependencies Using \`pacman\`...
pacman -S --noconfirm --needed wget mingw-w64-x86_64-python3 mingw-w64-x86_64-python-pip mingw-w64-x86_64-gtk3 mingw-w64-x86_64-python3-gobject
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to install dependencies using \`pacman\`!
	exit 4
fi
echo Finished Installing Dependencies Using \`pacman\`!
echo


# Install Python dependencies
echo Installing Dependencies Using \`pip3.exe\`...
/mingw64/bin/pip3.exe install wheel
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to install dependencies using \`pip.exe\`!
	exit 5
fi
echo Finished Installing Dependencies Using \`pip3.exe\`!
echo


# Install PyInstaller if Needed
if ! [ -f "/mingw64/bin/pyinstaller.exe" ];
then
	# Download PyInstaller
	echo Downloading PyInstaller...
	wget -O pyinstaller.tar.gz ${PYINSTALLER_SOURCE}
	if ! [ "$?" == "0" ];
	then
		echo ERROR!: Something happened while trying to download PyInstaller!
		exit 6
	fi
	echo Finished Downloading PyInstaller!
	echo


	# Extract PyInstaller
	echo Decompressing PyInstaller Archive...
	tar -xvf ./pyinstaller.tar.gz
	if ! [ "$?" == "0" ];
	then
		echo ERROR!: Something happened while trying to decompress the PyInstaller archive!
		exit 7
	fi
	echo Finished Decompressing PyInstaller Archive!
	echo


	# Build and Install PyInstaller
	echo Building and Installing PyInstaller...
	cd ./pyinstaller-5.1/
	/mingw64/bin/python3.exe setup.py install
	if ! [ "$?" == "0" ];
	then
		echo ERROR!: Something happened while trying to build and install PyInstaller!
		cd ../
		exit 8
	fi
	cd ../
	echo Finished Building and Installing PyInstaller!
	echo
fi


# Download Tarball
echo Downloading Chocolate Box $APP_VERSION...
wget https://gitlab.com/nickgirga/chocolate-box/-/archive/$APP_VERSION/chocolate-box-$APP_VERSION.tar.gz
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to clone the Chocolate Box repository using Git!
	exit 9
fi
echo Finished Downloading Chocolate Box $APP_VERSION!
echo


# Extract Tarball
echo Decompressing Chocolate Box $APP_VERSION Archive...
tar -xvf ./chocolate-box-$APP_VERSION.tar.gz
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to decompress the Chocolate Box $APP_VERSION archive!
	exit 15
fi
echo Finished Decompressing Chocolate Box $APP_VERSION Archive!
echo


# Build Windows Application Using PyInstaller
echo Building Chocolate Box for Windows...
cd ./chocolate-box-$APP_VERSION/
/mingw64/bin/pyinstaller.exe -i ./res/icon/icon_256.ico -w ./chocolate-box # build
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to build the application for Windows using PyInstaller!
	exit 10
fi
cp ./chocolate-box.ui "$PWD/dist/chocolate-box/chocolate-box.ui" # copy UI template
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to copy the UI template to the build directory!
	exit 11
fi
mkdir -p "$PWD/dist/chocolate-box/res/icon/" # create icon directory
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to create the local icon directory.
	exit 12
fi
cp ./res/icon/icon_128.png "$PWD/dist/chocolate-box/res/icon/icon_128.png" # copy about logo
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to copy the x128 icon!
	exit 13
fi
cp ./res/icon/icon_256.png "$PWD/dist/chocolate-box/res/icon/icon_256.png" # copy window icon
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to copy the x256 icon!
	exit 14
fi
echo Finished Building Chocolate Box for Windows!
echo
echo Executable can be found at \"$PWD/dist/chocolate-box/chocolate-box.exe\".
echo
echo Done!
