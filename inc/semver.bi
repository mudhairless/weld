#ifndef __WELD_SEMVER_BI__
#define __WELD_SEMVER_BI__ -1

type SemVerRange
    public:
    as string major, minor, patch
    as boolean flexibleMinor, flexiblePatch

    declare static function parse (byref svrstr as const string) as SemVerRange
    declare operator cast() As string

    declare property isValid() as boolean

    private:
    as boolean is_valid
    declare constructor()
end type

''Class: SemVer
''Represents a Semantic Version 2.0.0 version as described at https://semver.org
type SemVer
    public:
    as ushort major, minor, patch
    as string prereleaselabel, build

    declare static function parse (byref svstr as const string) as SemVer
    declare function satisfies (byref svr as SemVerRange) as boolean
    declare operator cast() As string

    declare constructor (byref rhs as const SemVer)

    private: 
    declare constructor()
end type

declare operator < (byref lhs as const SemVer, byref rhs as const SemVer) as boolean
declare operator = (byref lhs as const SemVer, byref rhs as const SemVer) as boolean



#endif