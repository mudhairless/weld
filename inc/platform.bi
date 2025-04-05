'platform.bi
'contains platform specific defines and other common defines

#ifndef __WELD_PLATFORM_BI__
#define __WELD_PLATFORM_BI__ -1

#define FAKE_BS_VERSION_S "0.99.8"

#define FAKEFILENAME "weld.it"
#ifdef __fb_linux__
#define SLASH "/"
#define EXE_EXT ""
#define DLL_EXT ".so"
#define PATH_SEP ":"
#else
#define SLASH "\"
#define EXE_EXT ".exe"
#define DLL_EXT ".dll"
#define PATH_SEP ";"
#endif

#ifdef __fb_win32__
#define CURPLATFORM "win32"
#define HOMEDIR_C environ("APPDATA") & "\weld.config"
#define GLOBAL_C exepath & "\global.config"
#elseif defined(__fb_dos__)
#define CURPLATFORM "dos"
#define HOMEDIR_C exepath & "\weld.cfg"
#define GLOBAL_C HOMEDIR_C
#else
#define CURPLATFORM "unix"
#define HOMEDIR_C environ("HOME") & "/.weld.config"
#define GLOBAL_C "/etc/weld/global.config"
#endif

#endif

