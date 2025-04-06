/'
[GLOBAL]
options = -w all -d NDEBUG=1
builddir = obj

[*gcc] #define a new compiler, in this case its our friend gcc
ext = c
compile = -pipe $opts -c $in -o $out
link = -pipe $opts $ins -o $out

[*fbc] #this is the default compiler, this definition is not needed.
ext = bas
compile = $opts -c $in -o $out
link = $opts $ins -x $out
dylib = -dylib $ins -x $out
static = -lib $ins -x $out

[all] #if not provided will default to the first output in the file
depends = weld

[weld]
files = main.bas, parser.bas #first file given is used with -m if type = exe, console or gui
options = -d FAKE_EXE=1
#depends = somelib
type = exe #other supported types for exes are "console" and "gui"

[fakedll]
files = ("src/*.bas")
type = dylib

[fakestatic]
files = parser.bas
type = static
'/

#include once "platform.bi"
#include once "compiler.bi"
#include once "module.bi"
#include once "list-compiler.bi"
#include once "list-module.bi"
#include once "parser.bi"
#include once "file.bi"
#include once "crt/string.bi"

declare sub listsections( inputf() as string, outputl() as string )
declare sub listkeys( byref section as const string, inputf() as string, outputkey() as string, outputval() as string )

destructor globals_t
        options = ""
        builddir = ""
end destructor

dim shared as globals_t GLOBALS
dim shared as complist COMPILERS

declare function findcompiler( byref x as const string ) as compiler ptr

sub parser_init( )

        dim as compiler defcomp

        if fileexists(GLOBAL_C) then

                var v = parse_buildspecfile( GLOBAL_C )
                if v <> null then delete v

                if fileexists( HOMEDIR_C ) andalso HOMEDIR_C <> GLOBAL_C then

                        var v = parse_buildspecfile( HOMEDIR_C )
                        if v <> null then delete v

                endif


                if GLOBALS.builddir = "" then GLOBALS.builddir = ".obj"

        elseif fileexists( HOMEDIR_C ) andalso HOMEDIR_C <> GLOBAL_C then

                var v = parse_buildspecfile( HOMEDIR_C )
                if v <> null then delete v

                if GLOBALS.builddir = "" then GLOBALS.builddir = ".obj"

        else

                defcomp.name = "fbc"
                defcomp.extensions = "bas"
                defcomp.compile_opts = "-d __WELD_BUILDN=$buildno $opts $main -c $in -o $out"
                defcomp.link_opts = "$opts $main $ins -x $out"
                defcomp.dylib_opts = "-dylib $opts $ins -x $out"
                defcomp.static_opts = "-lib $opts $ins -x $out"

                COMPILERS.PushBack( defcomp )

                GLOBALS.options = ""
                GLOBALS.builddir = ".obj"

        endif

end sub

sub reporterror( byval linen as uinteger, byref message as const string )

        var ff = freefile
        open err as ff
        print #ff, using "Error ###: &"; linen; message
        close
        end 2

end sub

function getTypeFromString( byref x as string ) as mtype

        select case lcase(x)
                case "exe"
                        return mtype.exe
                case "gui"
                        return mtype.gui
                case "console"
                        return mtype.console
                case "static"
                        return mtype.static_
                case "dylib"
                        return mtype.dylib
                case else
                        reporterror(__line__,"Invalid type: " & x)

        end select


end function

function parse_buildspecfile( byref bs_file as const string, _
                        byval ml as modlist ptr = 0 ) as modlist ptr

        var ff = freefile

        var res = open( bs_file, for binary, access read, as #ff )
        if res <> 0 then reporterror( __line__, "Unable to open file: " & bs_file )

        var curLine = ""
        var buildSpecFile = ""

        while not eof(ff)

                line input #ff, curLine
                buildSpecFile = buildSpecFile & chr(1) & curLine

        wend

        close #ff

        curLine = ""

        redim as string ffile()

        strings.split(buildSpecFile, ffile(), chr(1))

        buildSpecFile = ""

        dim as string sections()
        dim as string keys()
        dim as string values()

        var result = iif(ml = 0, new modlist, ml)

        listsections(ffile(), sections())
        if ubound(sections) = 0 then reporterror(__line__, "No Valid modules found in " & bs_file)

        for n as integer = lbound(sections) to ubound(sections)

                listkeys(sections(n), ffile(), keys(), values())

                select case lcase(sections(n))
                case "global"
                        for m as integer = lbound(keys) to ubound(keys)-1
                                select case lcase(trim(keys(m)))
                                case "options"
                                        GLOBALS.options = GLOBALS.options & " " & values(m)
                                case "builddir"
                                        GLOBALS.builddir = values(m)
                                case else
                                        reporterror(__line__, "Unrecognized directive: " & keys(m) & " in module GLOBAL" )
                                end select
                        next m


                case else
                        if left(sections(n),1) = "*" then
                                'compiler
                                dim zz as compiler
                                zz.name = right(sections(n),len(sections(n))-1)

                                var zzc = findcompiler(zz.name)

                                for m as integer = lbound(keys) to ubound(keys)-1

                                        select case lcase(trim(keys(m)))
                                        case "ext"
                                                zz.extensions = values(m)
                                                zzc = findcompiler(zz.extensions)
                                        case "compile"
                                                zz.compile_opts = values(m)
                                        case "link"
                                                zz.link_opts = values(m)
                                        case "dylib"
                                                zz.dylib_opts = values(m)
                                        case "static"
                                                zz.static_opts = values(m)
                                        case else
                                                reporterror(__line__, "Unrecognized directive: " & keys(m) & " in module *" & sections(n) )
                                        end select
                                next m

                                if zzc = 0 then
                                        COMPILERS.PushBack( zz )
                                else
                                        if zzc->name = "" then zzc->name = zz.name
                                        if zz.extensions <> "" then zzc->extensions = zz.extensions
                                        if zz.compile_opts <> "" then zzc->compile_opts = zz.compile_opts
                                        if zz.link_opts <> "" then zzc->link_opts = zz.link_opts
                                        if zz.dylib_opts <> "" then zzc->dylib_opts = zz.dylib_opts
                                        if zz.static_opts <> "" then zzc->static_opts = zz.static_opts
                                endif


                        else
                                'module
                                dim zx as module
                                zx.name = sections(n)

                                for m as integer = lbound(keys) to ubound(keys) - 1
                                        platformdecider:
                                        select case lcase(trim(keys(m)))
                                        case "link_options"
                                                zx.l_opts = trim(values(m))

                                        case "options"
                                                zx.c_opts = trim(values(m))

                                        case "files"
                                                zx.files = trim(values(m))
                                                #if CURPLATFORM = "unix"
                                                strings.replace(zx.files,"\","/")
                                                #endif

                                        case "depends"
                                                zx.depends = trim(values(m))

                                        case "output"
                                                zx.output_ = trim(values(m))

                                        case "type"
                                                zx.type_ = getTypeFromString(values(m))

                                        case "main"
                                                zx.main_ = trim(values(m))

                                        case else
                                                var tempstr = trim(keys(m))
                                                if tempstr[0] = 64 then 'asc("@")
                                                        var sloc = instr(tempstr,":")
                                                        if sloc > 0 then
                                                                var plat = mid(tempstr,2,sloc-2)
                                                                var nkey = mid(tempstr,sloc+1)
                                                                if plat = CURPLATFORM then
                                                                        keys(m) = nkey
                                                                        goto platformdecider
                                                                endif

                                                        else
                                                                reporterror(__line__, "Malformed directive: " & keys(m) & " in module " & sections(n) )
                                                        endif

                                                else

                                                        reporterror(__line__, "Unrecognized directive: " & keys(m) & " in module " & sections(n) )
                                                endif

                                        end select
                                next m

                                (result)->PushBack( zx )

                        end if
                end select

        next n


        return result

end function


sub listsections( inputf() as string, outputl() as string )

        var count = 0

        for n as integer = lbound(inputf) to ubound(inputf)

                var x = left(trim(inputf(n)),1)
                if x = "[" then
                        if instr(trim(inputf(n)),"]") then count += 1
                end if

        next n

        redim outputl(count)

        if count = 0 then return
        var count2 = 0
        for n as integer = lbound(inputf) to ubound(inputf)

                var x = left(trim(inputf(n)),1)
                if x = "[" then
                        var y = instr(trim(inputf(n)),"]")
                        if y < 1 then return
                        outputl(count2) = mid(trim(inputf(n)),2,y-2)
                        count2 += 1
                end if

        next

end sub

sub listkeys( byref section as const string, inputf() as string, outputkey() as string, outputval() as string )

        var count = 0
        var thisSection = ""

        for n as integer = lbound(inputf) to ubound(inputf)

                var thisLine = trim(inputf(n))
                var testChar = left(thisLine,1)
                if testChar = "#" then goto endwend
                if testChar = "[" then
                        testChar = right(thisLine,1)
                        var y = instr(trim(inputf(n)),"]")
                        if y < 1 then return
                        'Found a section name
                        thisSection = mid(thisLine,2,y-2)
                else
                        var strSep = instr(thisLine,"=")
                        if strSep > 0 then
                                if thisSection = section then count += 1
                        end if
                end if
                endwend:
        next

        redim outputkey(count)
        redim outputval(count)

        var countx = 0

        for n as integer = lbound(inputf) to ubound(inputf)

                var thisLine = trim(inputf(n))
                var testChar = left(thisLine,1)
                if testChar = "#" then goto endwendx
                if testChar = "[" then
                        testChar = right(thisLine,1)
                        var y = instr(trim(inputf(n)),"]")
                        if y < 1 then return
                        'Found a section name
                        thisSection = mid(thisLine,2,y-2)
                else
                        var strSep = instr(thisLine,"=")
                        if strSep > 0 then
                                if thisSection = section then
                                        outputkey(countx) = trim(mid(thisLine,1,strSep-1))
                                        outputval(countx) = trim(mid(thisLine,strSep+1))
                                        countx+=1
                                end if
                        end if
                end if
                endwendx:
        next

end sub
