# build_tools/Arch
#### What is a "PKGBUILD"?
A `PKGBUILD` is usually a file that describes how the `makepkg` utility should construct a package to be installed with Arch Linux's package manager, `pacman`.
It provides your package manager with information such as which dependencies to install and what files to keep track of (in order to remove them upon uninstall). This is all facilitated by the package manager, `pacman`, but the `makepkg` tool helps us format the package correctly by simply providing it the information it needs in the `PKGBUILD` file.
This makes it easier for others to contribute to the packaging part of a project and it also makes it easier to audit unofficial apps before installing them, as you can see exactly how it was constructed and follow any source links to ensure it doesn't download anything strange.

#### [Easy] How do I use it?
These `PKGBUILD` files actually only exist because they're used for automatic packaging using GitLab CI. After every commit to the "[milk](https://gitlab.com/nickgirga/chocolate-box/-/tree/milk)" branch, a new package will be created and uploaded to GitLab for users to download. So you don't need to do anything!

You can download these bleeding edge packages [here](https://gitlab.com/nickgirga/chocolate-box/-/pipelines). Then, if you use a GUI package manager, you should be able to just open the file (double click) and press install. If you prefer the command line interface, you can use the following command:

```
pacman -U [package_name].pkg.tar.zst
```

(Replace `[package_name]` with the name of your package)

***Done!*** You can now launch Chocolate Box from the icon in the launcher or with the `chocolate-box` command!

Note: If you do not have a source port such as `chocolate-doom`, `crispy-doom`, `gzdoom`, or `zdoom` installed, you will need to install one before Chocolate Box can serve a purpose. If installed in non-standard location, you will need to specify its path in the `Executable` field when adding a new IWAD.

Optionally, you can build this package yourself. If the provided package is not working for you, building it yourself may help. For example, currently only x86_64 packages are being provided, so users with ARM-based machines will need to repackage it themselves. For more information, see the [How do I build it myself?](#advanced-how-do-i-build-it-myself) section. ***Note: most users will not have to do this.***

#### [Advanced] How do I build it myself?
***WARNING!: Only proceed if you are familiar with build automation tools!***

The `makepkg` utility comes with the `pacman` package. So, if your Arch Linux environment is using `pacman` to manage packages (it probably is), then it probably already has what we need.

Simply navigate to the directory that contains the `PKGBUILD` file and run `makepkg -s`. This will just install the needed dependencies and build the package. You can install it as you would a distributed package (as described in the [How do I use it?](#easy-how-do-i-use-it) section) or you can automatically install it after it finishes building by giving `makepkg` an additional `-i` option (e.g. `makepkg -si`).

***Done!*** You can now launch Chocolate Box from the icon in the launcher or with the `chocolate-box` command!

Note: `makepkg` has some other useful options that you may want to look into before building your package, such as `--rmdeps` (which will remove dependencies installed by `-s`). You can use `makepkg --help` or `man makepkg` to find more information.

#### How do I remove it?
The whole point of the `makepkg` utility is to create a package that can be installed by `pacman`! So, all you need to do is ask `pacman` to remove it. If you use a GUI package manager, just search for it and remove it. If you prefer the command line interface, you can use the following command:

```
pacman -Rs [package_name]
```

(Replace `[package_name]` with the name of your package)

The `-R` option just means remove and the `-s` option will recursively remove dependencies that are no longer needed. For more information about the other options that `pacman` provides, you can use `pacman --help` or `man pacman`.

Chocolate Box should now be gone. You will probably still have configuration files left over in the `$HOME/.config/chocolate-box` directory that you might want to remove.
