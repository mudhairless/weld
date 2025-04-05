@IF "%fbc%"=="" (
    @echo Please run SET FBC=fbc32 or your preferred compiler first
    @goto :eof
)

@echo Clearing Old Build Files
@del src\*.o
@del .obj\*.o
@del weld.exe
@del bootstrap-weld.exe
@del inc\options.bi
@del lib\libfbeoptions.a

@echo Building Submodules
@cd submodules\fbeoptions
@cmd /c winbuild-release.bat
@cd ..\..
@copy submodules\fbeoptions\inc\options.bi inc
@copy submodules\fbeoptions\lib\libfbeoptions.a lib



@echo Build Objects
%fbc% -c -i inc -w all -g -m main src/main.bas
%fbc% -c -i inc -w all -g src/compiler.bas
%fbc% -c -i inc -w all -g src/list-compiler.bas
%fbc% -c -i inc -w all -g src/module.bas
%fbc% -c -i inc -w all -g src/list-module.bas
%fbc% -c -i inc -w all -g src/parser.bas
%fbc% -c -i inc -w all -g src/utilities.bas
%fbc% -c -i inc -w all -g src/crc32.bas
%fbc% -c -i inc -w all -g src/file_iter.bas

@echo Linking
%fbc% -p lib -m main src/main.o src/crc32.o src/file_iter.o src/compiler.o src/list-compiler.o src/module.o src/list-module.o src/parser.o src/utilities.o weld.rc -x bootstrap-weld.exe

@echo Making Final exe
@bootstrap-weld.exe

@echo Cleaning Bootstrap Build Files
@del src\*.o
@del bootstrap-weld.exe