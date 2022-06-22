# build_tools/Ubuntu
#### What is *this* "PKGBUILD"?
*This* `PKGBUILD` (not to be confused with [this](build_tools/Arch/PKGBUILD) one) is a file that describes how the `makedeb` utility should construct a package to be installed with `dpkg` or `apt`.
It provides your package manager with information such as which dependencies to install and what files to keep track of (in order to remove them upon uninstall). This is all facilitated by the package manager, `apt` (`dpkg` won't resolve dependencies by itself), but the `makedeb` tool helps us format the package correctly by simply providing it the information it needs in the `PKGBUILD` file.
This makes it easier for others to contribute to the packaging part of a project and it also makes it easier to audit unofficial apps before installing them, as you can see exactly how it was constructed and follow any source links to ensure it doesn't download anything strange.

#### [Easy] How do I use it?
These `PKGBUILD` files actually only exist because they're used for automatic packaging using GitLab CI. After every commit to the "[milk](https://gitlab.com/nickgirga/chocolate-box/-/tree/milk)" branch, a new package will be created and uploaded to GitLab for users to download. So you don't need to do anything!

You can download these bleeding edge packages [here](https://gitlab.com/nickgirga/chocolate-box/-/pipelines). Then, if you use a GUI package manager, you should be able to just open the file (double click) and press install. If you prefer the command line interface, you can use the following command:

```
apt install ./[package_name].deb
```

(Replace `[package_name]` with the name of your package)

***Done!*** You can now launch Chocolate Box from the icon in the launcher or with the `chocolate-box` command!

Note: If you do not have a source port such as `chocolate-doom`, `crispy-doom`, `gzdoom`, or `zdoom` installed, you will need to install one before Chocolate Box can serve a purpose. If installed in non-standard location, you will need to specify its path in the `Executable` field when adding a new IWAD.

Optionally, you can build this package yourself. If the provided package is not working for you, building it yourself may help. For example, currently only x86_64 packages are being provided, so users with ARM-based machines will need to repackage it themselves. For more information, see the [How do I build it myself?](#advanced-how-do-i-build-it-myself) section. ***Note: most users will not have to do this.***

#### [Advanced] How do I build it myself?
***WARNING!: Only proceed if you are familiar with build automation tools!***

The `makedeb` utility doesn't actually come with Ubuntu. At the time of writing, a single command can be pasted and run to set it up entirely. You can find this command on the website for `makedeb`: [makedeb.org](https://www.makedeb.org/).

After installing `makedeb`, navigate to the directory that contains the `PKGBUILD` file and run `makedeb -s`. This will just install the needed dependencies and build the package. You can install it as you would a distributed package (as described in the [How do I use it?](#easy-how-do-i-use-it) section) or you can automatically install it after it finishes building by giving `makedeb` an additional `-i` option (e.g. `makedeb -si`).

***Done!*** You can now launch Chocolate Box from the icon in the launcher or with the `chocolate-box` command!

Note: `makedeb` has some other useful options that you may want to look into before building your package, such as `--rm-deps` (which will remove dependencies installed by `-s`). You can use `makedeb --help` or `man makedeb` to find more information.

#### How do I remove it?
The whole point of the `makedeb` utility is to create a package that can be installed by `apt`! So, all you need to do is ask `apt` to remove it. If you use a GUI package manager, just search for it and remove it. If you prefer the command line interface, you can use the following commands:

```
apt remove [package_name] && apt autoremove
```

(Replace `[package_name]` with the name of your package)

The `autoremove` command will recursively remove dependencies that are no longer needed. For more information about the other options that `apt` provides, you can use `apt --help` or `man apt`.

Chocolate Box should now be gone. You will probably still have configuration files left over in the `$HOME/.config/chocolate-box` directory that you might want to remove.
