#include "module.bi"
#include "list-module.bi"
#include "hash.bi"

constructor module()
        this.type_ = mtype.exe
end constructor

constructor module( byref rhs as const module )

        this.name = rhs.name
        this.c_opts = rhs.c_opts
        this.files = rhs.files
        this.depends = rhs.depends
        this.output_ = rhs.output_
        this.type_ = rhs.type_
        this.main_ = rhs.main_

        updatehash

end constructor

destructor module

        this.name = ""
        this.c_opts = ""
        this.files = ""
        this.depends = ""
        this.output_ = ""
        this.main_ = ""

end destructor

sub module.updatehash()

        this.hash = crc32( @(this.name[0]), len(this.name), -1 )
        this.hash = crc32( @(this.c_opts[0]), len(this.c_opts), this.hash )
        this.hash = crc32( @(this.files[0]), len(this.files), this.hash )
        this.hash = crc32( @(this.depends[0]), len(this.depends), this.hash )
        if this.output_ = "" then
                this.hash = crc32( @(this.name[0]), len(this.name), this.hash )
        else
                this.hash = crc32( @(this.output_[0]), len(this.output_), this.hash )
        endif
        this.hash = crc32( @(this.main_[0]), len(this.main_), this.hash )
        this.hash = crc32( @(this.type_), sizeof(mtype), this.hash )

end sub

operator = ( byref lhs as module, byref rhs as module ) as integer

        lhs.updatehash
        rhs.updatehash
        if lhs.hash = rhs.hash then return true
        return false

end operator

operator <> ( byref lhs as module, byref rhs as module ) as integer

        lhs.updatehash
        rhs.updatehash
        if lhs.hash = rhs.hash then return false
        return true

end operator
