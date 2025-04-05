#include once "file_iter.bi"

constructor FILE_ITER( byref path as string )

    p_pathname = path
    attrib = &h21

end constructor

constructor FILE_ITER( byref path as string, byval attrib_ as integer )

    p_pathname = path
    attrib = attrib_

end constructor

operator FILE_ITER.for( )

    p_latest = dir(p_pathname, attrib)

end operator

operator FILE_ITER.step( )

    p_latest = dir( )

end operator

operator FILE_ITER.next( byref end_cond as FILE_ITER ) as integer

    return p_latest <> end_cond.p_pathname

end operator

function FILE_ITER.filename( ) as string

    return p_latest

end function