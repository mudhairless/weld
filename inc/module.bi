#ifndef __inc_module_bi__
#define __inc_module_bi__ -1


enum mtype explicit
        exe = 0 'default
        console = 2
        gui = 4
        dylib = 8
        static_ = 16
end enum


type module
        declare constructor
        declare constructor( byref rhs as const module )
        declare destructor

        as string name
        as string c_opts
        as string files
        as string depends
        as string output_
        as string main_
	as uinteger buildno
        as mtype type_

        as uinteger hash

        declare sub updatehash

end type

declare operator = ( byref lhs as module, byref rhs as module ) as integer
declare operator <> ( byref lhs as module, byref rhs as module ) as integer

#endif
