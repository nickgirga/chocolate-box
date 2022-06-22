# build_tools/Windows
#### What is this script?
In this directory, you will find a build script for Windows on x86_64 machines. It is intended to be used in the MSYS2 environment to create an executable that can be used independently on MSYS2. It uses PyInstaller to collect the dependencies that Chocolate Box needs and places them in output directory with the EXE, so the resulting EXE can simply be run by the host Windows machine without needing any additional dependencies installed.


#### [Easy] How do I use it?
This script actually only exists because it makes building a new stable release for Windows much easier for me. The idea is that a new Windows build will be created for each major release. So you don't need to do anything!

You can download these stable releases [here](https://gitlab.com/nickgirga/chocolate-box/-/releases). Then, you just need to decompress the archive and launch the `chocolate-box.exe` file whenever you want to use Chocolate Box. ***Done!*** You can create a shortcut to this EXE file for ease of access.

You may also choose to build the application yourself if you so please. This may be useful if the official builds are not working well for you, you want to test out the latest features, or you want to help contribute to the project. For more information, see the [How do I build it myself?](#advanced-how-do-i-build-it-myself) section. ***Note: most users will not have to do this.***



#### [Advanced] How do I build it myself?
To build Chocolate Box for Windows, you must first install [MSYS2](https://msys2.org/). This will only be used for building the application and can be removed once we finish.

After MSYS2 has been installed, launch it. Now, update all of its packages using the following command:
```
pacman -Syyu
```
After the update finishes, restart MSYS2 and run the same update command again. Why? MSYS2 may have needed you to restart it to complete core updates before it could check for other updates. So, you may still have pending updates. If it says `there is nothing to do`, continue. If you had to apply more updates, restart MSYS2 again once it finishes.

Once you are all up-to-date, all you need to do to build the application is run the build script I created. You can do this with the following command:
```
bash -c "$(curl -fsSL https://gitlab.com/nickgirga/chocolate-box/-/raw/milk/build_tools/Windows/build-win-x86_64.sh)"
```
***Done!*** This will check for updates, install all the dependencies needed, build PyInstaller, and use it to gather all of the dependencies and drop them in the build directory along with an EXE file. Once it prints `Done!`, you know the build process has completed. It should tell you where you can find your new executable. If you have followed these steps exactly, you can find the output directory at the following path on the Windows host: `C:\msys64\home\$USER\chocolate-box\dist\chocolate-box\` (`$USER` being your username). You will need all of the files surrounding the EXE in that directory, so just cut the whole directory and move it somewhere outside of the MSYS2 file system (`C:\msys64\`). If this build is for distribution, you can simply compress the whole directory in an archive to send out.

Ensure every instance of MSYS2 is closed. It is now safe to remove MSYS2 (if you wish). Doing so will completely remove the `C:\msys64` directory, so ensure you have gotten the files you want out of there first.


#### How do I remove it?
"Installation" on Windows is not tracked in any way (e.g. registry, package manager, etc.). To "install" it, all a user does is decompress an archive. So, to "uninstall" it, all a user must do is delete the files that they decompressed from the archive. ***Done!***
