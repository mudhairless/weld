type FILE_ITER

    declare constructor( byref path as string )
    declare constructor( byref path as string, byval attrib_ as integer )

    declare operator for( )
    declare operator step( )
    declare operator next( byref end_cond as FILE_ITER ) as integer

    ''Function: filename
    ''Returns the current filename.
    ''
    ''Returns:
    ''string containing the latest filename.
    ''
    declare function filename( ) as string
'private:

    as string p_pathname, p_latest
    as integer attrib

end type