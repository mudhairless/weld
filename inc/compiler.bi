#ifndef __inc__compiler__bi__
#define __inc__compiler__bi__ 1

type compiler
        declare constructor
        declare constructor( byref rhs as const compiler )
        declare constructor( byref n as const string )
        declare destructor
        declare operator cast() as String

        as string name
        as string extensions
        as string compile_opts
        as string link_opts
        as string dylib_opts
        as string static_opts

        as ulong hash

        declare sub updatehash

end type

declare operator = ( byref lhs as compiler, byref rhs as compiler ) as integer
declare operator <> ( byref lhs as compiler, byref rhs as compiler ) as integer



#endif
