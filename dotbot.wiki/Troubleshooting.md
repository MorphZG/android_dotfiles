# Fix links not successfully setup in Git Bash with Git for Windows
Native Windows symlinks are only created on Windows Vista/2008 and later, and only on filesystems supporting reparse points like NTFS. In order to maintain backwards compatibility, users must explicitely requests creating them. This is done by setting the environment variable for MSYS to contain the string winsymlinks:native or winsymlinks:nativestrict. Without this setting, 'ln -s' may copy the file instead of making a link to it.

In order enable these symbolic links, run git bash as administrator, then:
    
    export MSYS=winsymlinks:nativestrict
    ./install

# Colorized output hard to read?

If your terminal's colors don't mesh appropriately with the colors used by dotbot pass `--no-color` to the install command to suppress colorization.

# Python 2

Dotbot v1.19.2 ([b04a3f1](https://github.com/anishathalye/dotbot/commit/b04a3f1844a315ec01ddc25e2585390ba5019399)) is the latest version of Dotbot that maintains Python 2 compatibility. Python 2 [was EOLed](https://www.python.org/doc/sunset-python-2/) on 1 January 2020, over three years ago. If you need Python 2 compatibility, you can keep using this older version of Dotbot.