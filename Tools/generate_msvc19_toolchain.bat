@echo off
setlocal

REM
REM Generate Standalone MSVC 2017/2019 x86/x64 Toolchain from VS Installation
REM
REM Collects the necessary includes, binaries, DLLs and libs to around ~300mb on
REM disk from a VS installation that can invoke cl, and link as you typically
REM would after calling "vcvarsall.bat x64"
REM
REM This script generates the helper scripts within the generated toolchain.
REM cl_[x64|x86].bat:       Invokes the compiler with required environment variables set
REM link_[x64|x86].bat:     Invokes the linker with required environment variables set
REM msvc_env_[x64|x86].bat: Setups the environment variables for the toolchain.
REM                         i.e. "call msvc_env_x64.bat" to set the current
REM                         session's environment variables for compiling with
REM                         the toolchain, akin to "vcvarsall.bat x64"
REM
REM Information about the necessary files and steps adapted from
REM Krouzu's Isolating MSVC19 https://gist.github.com/krouzu/19ddd4cb989264b11c7b3ba48c159be0
REM Paul Houle's Isolating MSVC14 Script
REM
REM For other Visual Studio versions, you may need to update the version numbers.
REM

REM Configuration (NOTE: Update arch to either, "x86", "x64" or "x86 x64" for both toolchains).
set arch=x86 x64

REM Source Directories (NOTE: Update the directories for your desired version)
set vs_version=2019
set msvc_version=14.28.29910
set win_sdk_version=10.0.19041.0

set vs_root=C:\Program Files (x86)\Microsoft Visual Studio\%vs_version%\Community
set vs1=%vs_root%\VC\Tools\MSVC\%msvc_version%
set vs2=C:\Program Files (x86)\Windows Kits\10\bin\%win_sdk_version%
set vs3=C:\Program Files (x86)\Windows Kits\10\Include\%win_sdk_version%
set vs4=C:\Program Files (x86)\Windows Kits\10\Lib\%win_sdk_version%
set dll1=%vs_root%\Common7\Tools\api-ms-win-*.dll
set dll2=C:\Windows\System32\*140*.dll
set dll3=C:\Windows\System32\ucrtbase*.dll
set dll4=C:\Windows\System32\VsGraphicsHelper.dll

REM Destination Directory
set dest=%~1
if "%dest%"=="" echo Usage: %~nx0 ^<output folder^>
if "%dest%"=="" goto :eof

if exist "%dest%" echo Directory "%dest%" already exists, exiting.
if exist "%dest%" goto :eof

REM Path/File Exist Check
for %%a in ("%vs1%" "%vs2%" "%dll1%" "%dll2%" "%dll3%" "%dll4%" "%vs3%" "%vs4%") do (
    if not exist %%a echo Required file or path not found: %%a
    if not exist %%a goto :eof
)

set copy_cmd=xcopy /I /S

REM MSVC Includes
%copy_cmd% "%vs1%\include" "%dest%\include"
%copy_cmd% "%vs3%\ucrt\*" "%dest%\include"
%copy_cmd% "%vs3%\shared\*" "%dest%\sdk\include"
%copy_cmd% "%vs3%\um\*" "%dest%\sdk\include"

REM MSVC Binaries/Libraries/DLLs
for %%a in (%arch%) do (
    %copy_cmd% "%vs1%\bin\Hostx64\%%a" "%dest%\bin\%%a"
    %copy_cmd% "%vs1%\lib\%%a" "%dest%\lib\%%a"

    %copy_cmd% "%vs2%\%%a" "%dest%\sdk\bin\%%a"

    %copy_cmd% "%vs4%\ucrt\%%a" "%dest%\lib\%%a"
    %copy_cmd% "%vs4%\um\%%a" "%dest%\sdk\lib\%%a"

    %copy_cmd% "%dll1%" "%dest%\sdk\bin\%%a"
    %copy_cmd% "%dll2%" "%dest%\sdk\bin\%%a"
    %copy_cmd% "%dll3%" "%dest%\sdk\bin\%%a"
    %copy_cmd% "%dll4%" "%dest%\sdk\bin\%%a"

    REM Generate Compiler/Linker Scripts
    setlocal EnableDelayedExpansion
    set msvc_env_script="%dest%\msvc_env_%%a.bat"
    set cl_script="%dest%\cl_%%a.bat"
    set link_script="%dest%\link_%%a.bat"

    for %%b in (!msvc_env_script! !cl_script! !link_script!) do (
        echo @echo off>> %%b
    )

    for %%b in (!cl_script! !link_script!) do (
        echo setlocal>> %%b
    )

    for %%b in (!msvc_env_script! !cl_script! !link_script!) do (
        echo set msvc_root=%%~dp0>> %%b
        echo set include=%%msvc_root%%\include;%%msvc_root%%\sdk\include>> %%b
        echo set lib=%%msvc_root%%\lib\%%a;%%msvc_root%%\sdk\lib\%%a>> %%b
        echo set path=%%msvc_root%%\bin\%%a;%%path%%>> %%b
    )

    echo cl %%*>> !cl_script!
    echo link %%*>> !link_script!
)
