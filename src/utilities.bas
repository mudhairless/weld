#include once "platform.bi"
#include once "ext/strings/strmanip.bi"

using ext
using ext.strings

function getAbsPath( byref p as const string ) as string

	dim as string ret = p
	var cd = curdir
	var fqstart = false
	
	#if CURPLATFORM = "unix"
		if ret[0] = asc("/") then fqstart = true
		replace(ret,"/./","/")
		if ret[0] = asc("~") then replace(ret,"~",environ("HOME"))
	#else
		replace(ret,"/","\")
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