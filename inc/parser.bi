#ifndef __inc_parser_bi__
#define __inc_parser_bi__ -1

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
declare function parse_fakefile( byref fake_f as const string, byval ml as modlist ptr = 0 ) as modlist ptr
declare function str_split (byref s as const string, result() as string, byref delimiter as const string, byval limit as integer = -1) as integer
declare Sub str_replace (subject As String, oldtext As const String, newtext As const String)

#endif
