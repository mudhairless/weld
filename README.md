# weld

## About
weld is a simple replacement for most uses of make and similiar tools. Unlike other systems weld is not a full blown, Turing complete language, it is just a simple way to describe most software sources. weld is still a young project but is fairly stable already.

A small bit of intelligence is also built right in (tm) so that weld can automagically build a simple project with sane defaults. The file format used by weld is based on the INI format so it's easy to read by humans. A sample weld.it (used to build weld itself) is shown here:

```
[weld]
files = main.bas, parser.bas, compiler.bas, module.bas
#this option can also be customized per platform, see WeldFileFormat
options = -w all -i /path/to/inc -p /path/to/lib/platform
main = main
#depends = no project level dependencies
type = exe
```

weld is stable enough at this point to ease your development. It supports incremental builds so if you only change one file you don't have to rebuild the whole thing, just the one file. weld is also fairly quick but performance isn't a main concern at this point it runs like a champ for me, anecdotally similar to GNU Make for similarly sized projects. 

## History
This was originally built in 2011 using the Extended Library but has been updated to remove that dependency and support modern compilers.

## Building with Weld
0. Run `git submodule init` to bring in dependencies or `git submodule update --remote` to update them.
1. Use the `bootstrap.sh` if this is the first time building or dependencies have updated
2. Run `weld` in the project directory

## Bootstrap Building on Windows
0. Run `git submodule init` to bring in dependencies or `git submodule update --remote` to update them.
1. Open a Command Prompt (if using powershell run "cmd" to get the proper support for batch file features used)
2. Define a variable for the FreeBASIC compiler to use: "SET FBC=fbc32" or "SET FBC=fbc64" for 32bit or 64bit support
3. Run bootstrap.bat

## Bootstrap Building on Unix (untested)
0. Run `git submodule init` to bring in dependencies or `git submodule update --remote` to update them.
1. Submodule Makefiles expect an `fbc` to be on the path, if you are using both 32 and 64 bit compilers you should create a symbolic link named fbc that points to the preferred compiler.
3. Run bootstrap.sh

## Installation
Copy weld.exe (windows/dos) or weld (unix) to a directory that is available on your PATH environment variable
