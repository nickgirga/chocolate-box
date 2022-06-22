#!/usr/bin/bash
# build-win-x86_64.sh
# by Nicholas Girga
# Builds a Chocolate Box executable for x86_64 Windows using MSYS2 and PyInstaller


# Variables
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
pacman -S --noconfirm --needed wget git mingw-w64-x86_64-python3 mingw-w64-x86_64-python-pip mingw-w64-x86_64-gtk3 mingw-w64-x86_64-python3-gobject
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


# Clone Chocolate Box Repository
echo Cloning Chocolate Box repository...
git clone https://gitlab.com/nickgirga/chocolate-box.git
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to clone the Chocolate Box repository using Git!
	exit 9
fi
echo Finished cloning Chocolate Box repository!
echo


# Build Windows Application Using PyInstaller
echo Building Chocolate Box for Windows...
cd ./chocolate-box/
/mingw64/bin/pyinstaller.exe -w ./chocolate-box
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to build the application for Windows using PyInstaller!
	exit 10
fi
cp ./chocolate-box.ui "$PWD/dist/chocolate-box/chocolate-box.ui"
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to copy the UI template to the build directory!
	exit 11
fi
cp -r ./res/ "$PWD/dist/chocolate-box/res/"
if ! [ "$?" == "0" ];
then
	echo ERROR!: Something happened while trying to copy the resources directory to the build directory!
	exit 12
fi
echo Finished Building Chocolate Box for Windows!
echo
echo Executable can be found at \"$PWD/dist/chocolate-box/chocolate-box.exe\".
echo
echo Done!