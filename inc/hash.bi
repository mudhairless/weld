#ifndef __inc__hash__bi__
#define __inc__hash__bi__ 1

declare function crc32 overload ( byval buf as const any ptr, byval buf_len as uinteger, byval crc as ulong ) as ulong
declare function crc32 overload ( byref buf as const string ) as ulong

#endif