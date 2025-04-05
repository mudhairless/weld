#include "compiler.bi"
#include "list-compiler.bi"
#include "hash.bi"

operator compiler.cast() as string

        var ret = "[*" & this.name & !"]\n"
        ret = ret & "ext = " & this.extensions & !"\n"
        ret = ret & "compile = " & this.compile_opts & !"\n"
        ret = ret & "link = " & this.link_opts & !"\n"
        ret = ret & "dylib = " & this.dylib_opts & !"\n"
        ret = ret & "static = " & this.static_opts & !"\n"
        ret = ret & "# hash: " & hex(this.hash)

        return ret

end operator


constructor compiler()
end constructor

constructor compiler( byref n as const string )
        this.name = n
end constructor

constructor compiler( byref rhs as const compiler )

        this.name = rhs.name
        this.extensions = rhs.extensions
        this.compile_opts = rhs.compile_opts
        this.link_opts = rhs.link_opts
        this.dylib_opts = rhs.dylib_opts
        this.static_opts = rhs.static_opts

        updatehash

end constructor

destructor compiler

        this.name = ""
        this.extensions = ""
        this.compile_opts = ""
        this.link_opts = ""
        this.dylib_opts = ""
        this.static_opts = ""

end destructor

sub compiler.updatehash()

        this.hash = crc32( @(this.name[0]), len(this.name), -1 )
        this.hash = crc32( @(this.extensions[0]), len(this.extensions), this.hash )
        this.hash = crc32( @(this.compile_opts[0]), len(this.compile_opts), this.hash )
        this.hash = crc32( @(this.link_opts[0]), len(this.link_opts), this.hash )
        this.hash = crc32( @(this.dylib_opts[0]), len(this.dylib_opts), this.hash )
        this.hash = crc32( @(this.static_opts[0]), len(this.static_opts), this.hash )

end sub

operator = ( byref lhs as compiler, byref rhs as compiler ) as integer

        lhs.updatehash
        rhs.updatehash
        if lhs.hash = rhs.hash then return true
        return false

end operator

operator <> ( byref lhs as compiler, byref rhs as compiler ) as integer

        lhs.updatehash
        rhs.updatehash
        if lhs.hash = rhs.hash then return false
        return true

end operator
