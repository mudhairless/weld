@IF "%fbc%"=="" (
    @echo Please run SET FBC=fbc32 or your preferred compiler first
    @goto :eof
)

@echo Clearing Old Build Files
@del src\*.o
@del weld.exe

@echo Build Objects
%fbc% -c -i inc -w all -g src/main.bas
%fbc% -c -i inc -w all -g src/compiler.bas
%fbc% -c -i inc -w all -g src/list-compiler.bas
%fbc% -c -i inc -w all -g src/module.bas
%fbc% -c -i inc -w all -g src/list-module.bas
%fbc% -c -i inc -w all -g src/parser.bas
%fbc% -c -i inc -w all -g src/utilities.bas

@echo Linking
%fbc% -m main src/main.o src/compiler.o src/list-compiler.o src/module.o src/list-module.o src/parser.o src/utilities.o weld.rc -x weld