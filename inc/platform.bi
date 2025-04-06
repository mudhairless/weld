'platform.bi
'contains platform specific defines and other common defines

#ifndef __WELD_PLATFORM_BI__
#define __WELD_PLATFORM_BI__ -1

#define WELD_VERSION_MAJOR 0
#define WELD_VERSION_MINOR 99
#define WELD_VERSOIN_PATCH 9
#define WELD_VERSION_LABEL "alpha"

#ifdef WELD_VERSION_LABEL
    #define WELD_VERSION_S WELD_VERSION_MAJOR & "." & WELD_VERSION_MINOR & "." & WELD_VERSOIN_PATCH & "-" & WELD_VERSION_LABEL
#else
    #define WELD_VERSION_S WELD_VERSION_MAJOR & "." & WELD_VERSION_MINOR & "." & WELD_VERSOIN_PATCH
#endif


#define DEFAULT_BUILD_FILE "weld.it"

#define GIT_GET_COMMIT_HASH "git rev-parse --short HEAD"

#ifdef __fb_linux__
    #define SLASH "/"
    #define OTHERSLASH "\"
    #define EXE_EXT ""
    #define DLL_EXT ".so"
    #define PATH_SEP ":"
#endif

#ifdef __fb_win32__
    #define SLASH "\"
    #define OTHERSLASH "/"
    #define EXE_EXT ".exe"
    #define DLL_EXT ".dll"
    #define PATH_SEP ";"
#endif

#ifdef __fb_dos__
    #define SLASH "\"
    #define OTHERSLASH "/"
    #define EXE_EXT ".exe"
    #define DLL_EXT ".dll"
    #define PATH_SEP ";"
#endif

#ifdef __fb_win32__
    #define CURPLATFORM "win32"
    #define HOMEDIR_C environ("APPDATA") & "\weld\weld.config"
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

