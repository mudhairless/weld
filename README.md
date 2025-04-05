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

## Bootstrap Building on Windows

1. Open a Command Prompt (if using powershell run "cmd" to get the proper support for batch file features used)
2. Define a variable for the FreeBASIC compiler to use: "SET FBC=fbc32" or "SET FBC=fbc64" for 32bit or 64bit support
3. Run bootstrap.bat
4. Copy weld.exe to a directory on the PATH

