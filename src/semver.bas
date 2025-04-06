#include once "semver.bi"

enum semver_parse_state explicit
    parse_major
    parse_minor
    parse_patch
    parse_prereleaselabel
    parse_build
end enum

constructor SemVer
end constructor

constructor SemVer (byref rhs as const SemVer)
    this.major = rhs.major
    this.minor = rhs.minor
    this.patch = rhs.patch
    this.prereleaselabel = rhs.prereleaselabel
    this.build = rhs.build
end constructor

function char_valid_for_state(byval state as semver_parse_state, byref char as string) as boolean
    dim as string lchar = lcase(char)
    select case state
        case semver_parse_state.parse_major, semver_parse_state.parse_minor, semver_parse_state.parse_patch
            return char >= "0" AND char <= "9"

        case semver_parse_state.parse_prereleaselabel, semver_parse_state.parse_build:
            return (char >= "0" AND char <= "9") OR (lchar >= "a" AND lchar <= "z") OR (char = "-") OR (char = ".")

    end select
    return false
end function

function SemVer.parse(byref svstr as const string) as SemVer
    dim as SemVer result
    dim as semver_parse_state state = semver_parse_state.parse_major
    dim as string buffer

    for n as uinteger = 0 to len(svstr) - 1
        var curChar = chr(svstr[n])
        if (char_valid_for_state(state, curChar)) then
            buffer = buffer & curChar
        else
            select case state
                case semver_parse_state.parse_major
                    result.major = cushort(buffer)
                    buffer = ""
                    state = semver_parse_state.parse_minor

                case semver_parse_state.parse_minor
                    result.minor = cushort(buffer)
                    buffer = ""
                    state = semver_parse_state.parse_patch

                case semver_parse_state.parse_patch
                    result.patch = cushort(buffer)
                    buffer = ""
                    if (curChar = "-") then
                        state = semver_parse_state.parse_prereleaselabel
                    end if
                    if (curChar = "+") then
                        state = semver_parse_state.parse_build
                    end if

                case semver_parse_state.parse_prereleaselabel
                    result.prereleaselabel = buffer
                    buffer = ""
                    if (curChar = "+") then
                        state = semver_parse_state.parse_build
                    end if

                case semver_parse_state.parse_build
                    result.build = buffer
                    buffer = ""

            end select
        end if
    next n

    if (buffer <> "") then
        select case state
            case semver_parse_state.parse_patch
                result.patch = cushort(buffer)

            case semver_parse_state.parse_prereleaselabel
                result.prereleaselabel = buffer

            case semver_parse_state.parse_build
                result.build = buffer

        end select
    end if

    return result
end function

operator SemVer.cast() As string
    var result = "" & this.major & "." & this.minor & "." & this.patch
    if (this.prereleaselabel <> "") then
        result = result & "-" & this.prereleaselabel
    end if
    if (this.build <> "") then
        result = result & "+" & this.build
    end if
    return result
end operator

operator < (byref lhs as const SemVer, byref rhs as const SemVer) as boolean
    var major = cast(boolean, lhs.major < rhs.major)
    var minor = cast(boolean, lhs.minor < rhs.minor)
    var patch = cast(boolean,lhs.patch < rhs.patch)
    dim as boolean pre = false
    if (lhs.prereleaselabel <> "" AND rhs.prereleaselabel <> "") then
        pre = cast(boolean, lhs.prereleaselabel < rhs.prereleaselabel)
    else
        if (lhs.prereleaselabel = "") then
            pre = false
        else
            pre = true
        end if
    end if
        
    return major or minor or patch or pre
end operator

operator = (byref lhs as const SemVer, byref rhs as const SemVer) as boolean
    return (lhs.major = rhs.major) AND (lhs.minor = rhs.minor) AND (lhs.patch = rhs.patch) AND (lhs.prereleaselabel = rhs.prereleaselabel)
end operator

function SemVer.satisfies (byref svr as SemVerRange) as boolean
    var major = cast(boolean, cushort(svr.major) = this.major)
    var minor = false
    var patch = false
    
    if (cushort(svr.minor) = this.minor) then
        minor = true
    else
        if (svr.flexibleMinor OR svr.minor = "*" OR svr.minor = "x") then
            if (svr.flexibleMinor AND svr.minor <> "*" AND svr.minor <> "x") then
                var cminor = cushort(svr.minor)
                ? "Cminor: ";
                ? cminor
                if (cminor >= this.minor) then
                    minor = true
                end if
            else
                minor = true
            end if
        end if
    end if

    if (cushort(svr.patch) = this.patch) then
        patch = true
    else
        if (svr.flexiblePatch OR svr.patch = "*" OR svr.patch = "x") then
            if (svr.flexiblePatch AND svr.patch <> "*" AND svr.patch <> "x") then
                if (cushort(svr.patch) >= this.patch) then
                    patch = true
                end if
            else
                patch = true
            end if
        end if
    end if
    
    return major AND minor AND patch
end function

constructor SemVerRange()
end constructor

function SemVerRange.parse(byref svrstr as const string) as SemVerRange
    dim as SemVerRange result
    dim as semver_parse_state state = semver_parse_state.parse_major
    dim as string buffer, curChar

    for n as uinteger = 0 to len(svrstr) - 1
        curChar = chr(svrstr[n])
        if (char_valid_for_state(state, curChar)) then
            buffer = buffer & curChar
        else
            select case state
                case semver_parse_state.parse_major
                    if (curChar = "^") then
                        result.flexibleMinor = true
                    else
                        if (curChar = "~") then
                            result.flexiblePatch = true
                        else
                            result.major = buffer
                            buffer = ""
                            state = semver_parse_state.parse_minor
                        end if
                    end if                    

                case semver_parse_state.parse_minor
                    if (curChar = "x") then
                        result.minor = curChar
                    else
                        result.minor = buffer
                        
                    end if
                    buffer = ""
                    state = semver_parse_state.parse_patch

                case semver_parse_state.parse_patch
                    if (curChar = "x") then
                        result.patch = curChar
                    else
                        result.patch = buffer
                    end if
                    buffer = ""
                    state = semver_parse_state.parse_patch

            end select
        end if
    next n

    if (buffer <> "") then
        select case state
            case semver_parse_state.parse_minor
                result.minor = buffer
                result.patch = "x"

            case semver_parse_state.parse_patch                
                result.patch = buffer

        end select
    else
        select case state
            case semver_parse_state.parse_minor
                result.minor = "x"
                result.patch = "x"
            
            case semver_parse_state.parse_patch
                result.patch = "x"
        end select
    end if

    result.is_valid = result.major <> "" AND result.minor <> "" AND result.patch <> ""

    return result
end function

operator SemVerRange.cast() As string
    var result = "" & this.major & "." & this.minor & "." & this.patch
    if (this.flexibleMinor) then
        result = "^" & result
    end if
    if (this.flexiblePatch) then
        result = "~" & result
    end if
    return result
end operator

property SemVerRange.isValid() as boolean
    return this.is_valid
end property