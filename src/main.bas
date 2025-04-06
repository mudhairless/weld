#define fbext_NoBuiltinInstanciations() 1

#include once "platform.bi"
#include once "compiler.bi"
#include once "module.bi"
#include once "file.bi"
#include once "fbefile/file_iter.bi"
#include once "parser.bi"
#include once "options.bi"

dim shared as string gFakefile
dim shared as string gModToBuild
dim shared as string gCurDir
dim shared as string gCurMod

declare sub printstatus( byval numtoadd as uinteger = 0 )
declare function findmod( byref search as const string, byval mods as modlist ptr ) as module ptr
declare function dobuild( byval mtb as module ptr, byval allmods as modlist ptr ) as integer

gCurDir = curdir()
gFakefile = gCurDir & SLASH & FAKEFILENAME
gModToBuild = ""

var iOpts = options.Parser
iOpts.setHelpHeader(!"weld - The (not just) FreeBASIC build system.\nCopyright 2025 Ebben Feagan \n\nUsage: weld [options] [module-to-build]\nIf [module-to-build] is then name of a module in the file weld.it then if will be built,\nif the name passed has an extension then the file weld.it will be built normally,\nas if no module was passed.")
var v = iOpts.addBool("v","version","Display the program's version.")
var vv = iOpts.addBool("cc","copyright","Display the program's copyright.")
var f = iOpts.addOption("f","file",true,,,,!"File to use instead of the default \"weld.it\".")
var r = iOpts.addBool("r","run","Ignore's the module-to-build argument and tries to run the default module if appropriate.")
var c = iOpts.addBool("c","clean","Removes any intermediate files generated by the build process.")
var d = iOpts.addBool("cd","delete","Removes all files generated by weld including executables and libraries.")
var g = iOpts.addBool("g","debug","Build with debug information. Add's -g to [GLOBAL]'s options in practice.")
var ag =iOpts.addOption("a","auto",true,,,,!"Attempt to automatically generate a weld.it for\n the extension passed for files in the current directory only.")
var m = iOpts.addOption("am","auto-main",true,,,,"Used with -a/--auto to set the main file in an executable, use no extension.")
var o = iOpts.addOption("ao","auto-output",true,,,,"Used with -a/--auto to set the output file, use no extension. (optional)")
var t = iOpts.addOption("at","auto-type",true,,,,!"Used with -a/--auto to set the output type, defaults to 'exe' (optional).\nOptions are: exe, console, gui, dylib and static")
var dumpit = iOpts.addBool("dc","dump-compilers","Prints a list of all supported compilers to std-out")
iOpts.setHelpFooter(!"Additional help using weld can be found by reading \n\"format.txt\" distributed with weld.\nweld is Free Software distributed under the terms of the BSD license.")

iOpts.parse( __FB_ARGC__, __FB_ARGV__ )

if  iOpts.isSet(ag) then
        if iOpts.isSet(o) = false and iOpts.isSet(m) = false then
                ? "ERROR: You must specify at least a main file (-am,--auto-main) or an output file (-ao,--auto-output) or both."
                end __line__
        endif
endif

if iOpts.isSet(ag) andalso (iOpts.isSet(m) orelse iOpts.isSet(o)) then

        var agext = iOpts.getArg(ag)
        if agext = "" then
                ? "ERROR: no extension specified for auto-generation."
                end __line__
        endif
        var am = ""
        var ao = ""
        if iOpts.isSet(m) then am = iOpts.getArg(m)
        var at = "exe"
        if fileexists(gFakefile) then
                ? "ERROR: weld.it already exists."
                end __line__
        endif
        if iOpts.isSet(o) then
                ao = iOpts.getArg(o)
        else
                ao = am
        endif
        if iOpts.isSet(t) then
                at = iOpts.getArg(t)
        endif


        open FAKEFILENAME for binary access write as #1
        print #1, "#Generated Automagically by weld " & FAKE_BS_VERSION_S
        print #1, "#Edit this file to you heart's content."
        print #1, using "[&]"; ao
        print #1, "files = ";
        var outstr = ""
        for n as fbe.FILE_ITER = fbe.FILE_ITER("*." & agext, fbe.fbeNormal ) to ""
                outstr = outstr & n.filename & ", "
        next
        outstr = left(trim(outstr),len(outstr)-2)
        print #1, outstr
        print #1, using "type = &"; at
        print #1, using "output = &"; ao
        if iOpts.isSet(m) then
                print #1, using "main = &"; am
        endif

        print #1, "#depends = enter dependencies here seperated by comma and remove this comment and #"
        close #1

endif

#ifndef __WELD_BUILDN
#define __WELD_BUILDN &hDEADBEEF
#endif

if iOpts.isSet(v) then
        ? "weld - The (not just for) FreeBASIC build system."
        ? using "Version: & Build: &";  FAKE_BS_VERSION_S; CURPLATFORM & "-" & hex(__WELD_BUILDN)
        ? using "Built with &."; __FB_SIGNATURE__
        ? "System Config Paths:"
        ? using "    Global Config: &, Present? &"; GLOBAL_C; iif(fileexists(GLOBAL_C), "Y", "N")
        ? using "    User Config: &, Present? &"; HOMEDIR_C; iif(fileexists(HOMEDIR_C), "Y", "N")
        end 0
endif

if iOpts.isSet(vv) then
        ? "weld - The (not just for) FreeBASIC build system."
        ? "Copyright (c) 2025, Ebben Feagan"
        ? "All rights reserved."
        ?
        ? "Redistribution and use in source and binary forms, with or without"
        ? !"modification, are permitted provided that the following conditions\n are met:"
        ?
        ? "Redistributions of source code must retain the above copyright"
        ? "notice, this list of conditions and the following disclaimer."
        ?
        ? "Redistributions in binary form must reproduce the above copyright"
        ? "notice, this list of conditions and the following disclaimer in the"
        ? "documentation and/or other materials provided with the distribution."
        ?
        ? "Neither the name of the HMCsoft nor the names of its contributors may"
        ? "be used to endorse or promote products derived from this software without"
        ? "specific prior written permission."
        ?
        ? !"THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"as is\""
        ? "AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE "
        ? "IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE"
        ? "DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE "
        ? "FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL "
        ? "DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR "
        ? "SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER "
        ? "CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,"
        ? "OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF"
        ? "THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
        ?
        end 0
endif


if iOpts.isSet(f) then
        gFakefile = iOpts.getArg(f)

endif

if iOpts.isSet(c) then
        GLOBALS.clean = true
endif
if iOpts.isSet(d) then
        GLOBALS.dele = true
endif

gModToBuild = iOpts.getRemainder()
if iOpts.isSet(r) orelse instr(gModToBuild,".") > 0 then gModToBuild = ""

parser_init()

'have to set this after parser_init because it clears GLOBALS.options
if iOpts.isSet(g) then
        GLOBALS.options = "-g"
endif

if iOpts.isSet(dumpit) then
        print using "_# Found ### compilers."; COMPILERS.Size
        print

        var iter = COMPILERS.Begin()

        while iter <> COMPILERS.End_()

                print *(iter.Get()) 'casts to string
                iter.Increment
                print

        wend

        end 0
endif

if not(fileexists(gFakefile)) then
        'let's see if there's a src dir and try to build there too...
        if not(chdir("src")) then
                var cres = 0
                cres = chain(command(0))
                if cres > 0 then
                        end cres
                elseif cres = 0 then
                        end
                else
                        ? "ERROR: Unable to locate " & gFakefile
                        ? "*** Build can not proceed. ***"
                        end __line__
                endif
        endif
endif

var mods = parse_fakefile(gFakefile)
if mods = 0 then
        ? "ERROR: Unknown error parsing " & gFakefile
        ? "*** Try finding an old priest and a young priest. ***"
        end __line__
endif
if mods->Size = 0 then
        ? "ERROR: No Modules specified in " & gFakefile
        ? "*** Maybe you have to blow in it like a Nintendo? ***"
        end __line__
endif

var thismod = findmod(gModToBuild,mods)
if GLOBALS.dele = true orelse GLOBALS.clean = true then
        print "Cleaning Up... [  0%]"
else
        print "Compiling... [  0%]"
endif
if (not GLOBALS.clean) then printstatus(1)
var ret = dobuild(thismod, mods)
if ret <> 0 then
        ? using "Error ### during Build."; ret
endif

if iOpts.isSet(r) andalso thismod->type_ < 8 then

        shell thismod->name & EXE_EXT

endif

while true 'ensure progress gets to 100%
        printstatus
wend


'** END OF MAIN

function findmod( byref search as const string, byval mods as modlist ptr ) as module ptr

        if search = "" then

                var iter = mods->Begin()

                return iter.get()

        endif


        var iter = mods->Begin()

        while iter <> mods->End_()

                var x = iter.Get()

                if x->name = search then return x

                iter.Increment

        wend

        ? using "ERROR: Module: & not found in weld.it: &"; search; gFakefile
        ? "*** Build can not proceed. ***"
        end __line__
        return 0

end function

function findcompiler( byref x as const string ) as compiler ptr

        static as string lastx
        static as compiler ptr lastc
        static as boolean doit = true

        if doit = false andalso lastx = x then
                return lastc
        end if

        var iter = COMPILERS.Begin()

        while iter <> COMPILERS.End_()
                
                var z = iter.get()
                if instr(z->extensions, x) > 0 then
                        var ts = z->name
                        z->name = trim(environ(z->name)) & EXE_EXT
                        if z->name = EXE_EXT then
                                z->name = ts & EXE_EXT
                        end if
                        if (not (fileexists(z->name))) then
                                var path_e = environ("PATH")
                                dim paths_e() as string
                                str_split(path_e, paths_e(), PATH_SEP)

                                for n as integer = lbound(paths_e) to ubound(paths_e)
                                
                                        if fileexists(paths_e(n) & SLASH & z->name) then
                                                z->name = paths_e(n) & SLASH & z->name
                                                exit for
                                        end if
                                next n
                        end if     
                        

                        lastx = x
                        lastc = z
                        doit = false
                        return z
                endif

                iter.Increment
        wend

        return 0

end function

sub printstatus( byval numtoadd as uinteger = 0 )

        static numtotal as uinteger = 0
        static numleft as uinteger = 0

        if numtoadd <> 0 then
                numtotal += numtoadd
        else
                numleft += 1
                var t = int((numleft/numtotal)*100)
                if t>100 then
                        end 0
                endif
                locate csrlin-1,1
                if GLOBALS.dele = true orelse GLOBALS.clean = true then
                        print using "Cleaning Up... [(&) ###%]&"; gCurMod; t; space(20)
                else
                        print using "Compiling... [(&) ###%]&"; gCurMod; t; space(20)
                endif

        endif

end sub


sub compile( byref fi as const string, byref fo as const string, byval m as const module ptr, byval c as const compiler ptr, byref mf as const string )

        var compile_str = ""


        if GLOBALS.clean = true orelse GLOBALS.dele = true then
                kill fo
                printstatus
                return
        endif


        if fileexists(fo) = 0 orelse filedatetime(fi) > filedatetime(fo) then

                compile_str = c->compile_opts
                str_replace(compile_str,"$in",fi)
                str_replace(compile_str,"$out",fo)
                str_replace(compile_str,"$buildno",str(m->buildno))
                str_replace(compile_str,"$opts", GLOBALS.options & " " & m->c_opts)
                if m->type_ < mtype.dylib then
                        str_replace(compile_str,"$main", " -m " & mf)
                else
                        str_replace(compile_str,"$main","")
                endif
'                ? c->name & " " & trim(compile_str)
                var ret = exec( c->name, trim(compile_str) )
                if ret > 0 then
                        ? "ERROR: Building " & fi & " failed."
                        end ret
                elseif ret = -1 then

                        ? using "ERROR: Unable to locate compiler, ensure & is in your PATH";  c->name
                        ? using "If & is already in your PATH double check it is in the form: path\to\compiler"; c->name
                        ?       "putting 'compiler name' on the end with no extension."
                        end __line__
                endif
                printstatus

        endif



end sub

function dobuild( byval mtb as module ptr, byval allmods as modlist ptr ) as integer

        if (not GLOBALS.clean) then printstatus(1)

        if (mtb->depends <> "") then
                'got to build/clean dependancies first

                dim dependd() as string
                str_split(mtb->depends, dependd(), ",")
                if (not GLOBALS.clean) then printstatus(ubound(dependd))
                for n as integer = lbound(dependd) to ubound(dependd)
                        dependd(n) = trim(dependd(n))
                        var grue = findmod(dependd(n),allmods)
                        if grue = 0 then
                                ? using !"ERROR: Unable to locate dependancy \"&\" for module \"&\""; dependd(n); mtb->name
                                end __line__
                        endif
                        var fjai = dobuild(grue,allmods)
                        if fjai <> 0 then
                                ? using !"ERROR: Unable to build dependancy \"&\" for module \"&\""; dependd(n); mtb->name
                                end __line__
                        endif
                next n


        endif

        if (mtb->files = "") then return 0
        
        if (GLOBALS.builddir <> "") then
                if (GLOBALS.clean = false andalso GLOBALS.dele = false) then
                        mkdir GLOBALS.builddir
                endif
        endif

        gCurMod = mtb->name

        var modbuildcntfile = GLOBALS.builddir & SLASH & gCurMod & ".cnt"
        var modbuildcnt = 1u

        if fileexists( modbuildcntfile ) then

                var bff = freefile
                open modbuildcntfile for input access read as #bff
                input #bff, modbuildcnt
                close #bff
                modbuildcnt += 1
                open modbuildcntfile for output access write as #bff
                write #bff, modbuildcnt
                close #bff

        else

                var bff = freefile
                open modbuildcntfile for output access write as #bff
                write #bff, modbuildcnt
                close #bff

        endif

        mtb->buildno = modbuildcnt

        dim files() as string
        dim files_o() as string

        var type_ = mtb->type_

        if left(mtb->files,1) = "(" then
                ? "not implemented atm"
        endif

        str_split(mtb->files, files(), ",")
        printstatus(ubound(files))

        redim files_o(ubound(files))

        var mainf = left(files(0),instr(files(0),".")-1)
        if mtb->main_ <> "" then mainf = mtb->main_

        for n as integer = lbound(files) to ubound(files)
                var cext = right(files(n),len(files(n))-instr(files(n),"."))

                files_o(n) = left(files(n),len(files(n))-len(cext)) & "o"
                str_replace(files_o(n), SLASH, "_")
                str_replace(files_o(n), OTHERSLASH, "_")
                if GLOBALS.builddir <> "" then
                        files_o(n) = GLOBALS.builddir & SLASH & trim(files_o(n))
                end if


                var comp = findcompiler(cext)
                if comp = 0 then
                        ? "ERROR: Compiler not found for extension: " & cext
                        return __line__
                endif

                compile( files(n), files_o(n), mtb, comp, mainf )
        next n

        var olist = str_join(files_o()," ")

        var compiler_str = ""
        var comp = findcompiler(right(files(0),len(files(0))-instr(files(0),".")))
        if comp = 0 then
                ? "ERROR: Default compiler not found for module: " & mtb->name
                return __line__
        endif
        select case type_
                case mtype.exe
                        compiler_str = trim(comp->link_opts)
                        str_replace(compiler_str,"$main"," -m " & mainf)
                case mtype.console
                        compiler_str = trim(comp->link_opts)
                        str_replace(compiler_str,"$opts","$opts -s console")
                        str_replace(compiler_str,"$main"," -m " & mainf)
                case mtype.gui
                        compiler_str = trim(comp->link_opts)
                        str_replace(compiler_str,"$opts","$opts -s gui")
                        str_replace(compiler_str,"$main"," -m " & mainf)

                case mtype.dylib
                        compiler_str = trim(comp->dylib_opts)        

                case mtype.static_
                        compiler_str = trim(comp->static_opts)

        end select

        var repopts = trim(GLOBALS.options & " " & mtb->c_opts & " " & mtb->l_opts)
        str_replace(compiler_str,"$opts", repopts)
        str_replace(compiler_str,"$ins",olist)

        if mtb->output_ = "" then
                select case type_
                        case mtype.exe, mtype.console, mtype.gui
                                str_replace(compiler_str,"$out",mtb->name & EXE_EXT)
                        case else
                                str_replace(compiler_str,"$out",mtb->name )
                end select

        else
                select case type_
                        case mtype.exe, mtype.console, mtype.gui
                                str_replace(compiler_str,"$out",mtb->output_ & EXE_EXT)
                        case else
                                str_replace(compiler_str,"$out",mtb->output_ )
                end select
        endif

        if GLOBALS.dele = true then
                printstatus
                select case type_
                        case mtype.exe, mtype.console, mtype.gui
                                if mtb->output_ = "" then
                                        kill mtb->name & EXE_EXT
                                else
                                        kill mtb->output_ & EXE_EXT
                                endif
                        case mtype.dylib
                                if mtb->output_ = "" then
                                        kill "lib" & mtb->name & dll_EXT
                                else
                                        kill "lib" & mtb->output_ & dll_EXT
                                endif
                        case mtype.static_
                                if mtb->output_ = "" then
                                        kill "lib" & mtb->name & ".a"
                                else
                                        kill "lib" & mtb->output_ & ".a"
                                endif
                end select

        elseif GLOBALS.clean <> true andalso GLOBALS.dele <> true then
                '? comp->name & " " & trim(compiler_str)
                var ret = exec(comp->name, trim(compiler_str))
                printstatus
                return ret
        endif
        return 0



end function
