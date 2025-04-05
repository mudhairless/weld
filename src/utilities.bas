#include once "platform.bi"
#include once "parser.bi"

function getAbsPath( byref p as const string ) as string

	dim as string ret = p
	var cd = curdir
	var fqstart = false
	
	#if CURPLATFORM = "unix"
		if ret[0] = asc("/") then fqstart = true
		str_replace(ret,"/./","/")
		if ret[0] = asc("~") then str_replace(ret,"~",environ("HOME"))
	#else
		str_replace(ret,"/","\")
		if instr(ret,":\") > 0 then fqstart = true
	#endif
	
	if fqstart = false then
		ret = cd & SLASH & ret
	endif
	
	
	
	return ret

end function

function getCanonicalPath( byref p as const string ) as string

	function = p

end function