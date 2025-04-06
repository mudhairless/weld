#ifndef __inc_parser_bi__
#define __inc_parser_bi__ -1

#include "list-compiler.bi"
#include "list-module.bi"
#include once "strings/split.bi"
#include once "strings/manip.bi"

type globals_t
        declare destructor
        as string options, builddir
        as boolean clean, dele
end type


type complist as fbe_List_compiler
type modlist as fbe_List_module


extern GLOBALS as globals_t
extern COMPILERS as complist

declare sub parser_init( )
declare function parse_buildspecfile( byref fake_f as const string, byval ml as modlist ptr = 0 ) as modlist ptr

#endif
