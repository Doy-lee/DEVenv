@ECHO OFF
@rem LLVM installation path
IF "%dp0%"=="" (SET LLVM=".\bin") ELSE (SET LLVM=%dp0%\bin)
@rem SET LLVM="C:\Program Files\LLVM\bin\"
IF NOT EXIST "%LLVM%" (
	ECHO LLVM not found at %LLVM%\bin
	EXIT /b
)

PUSHD "%LLVM%"

@rem delete MSVC runtime library
DEL api-ms*.dll
DEL concrt140.dll
DEL msvcp140*.dll
DEL ucrtbase.dll
DEL vcruntime140*.dll

@rem make symbolic link
DEL clang++.exe
MKLINK /H clang++.exe clang-cl.exe

DEL clang.exe
MKLINK /H clang.exe clang-cl.exe

DEL clang-cpp.exe
MKLINK /H clang-cpp.exe clang-cl.exe

DEL lld-link.exe
MKLINK /H lld-link.exe lld.exe

DEL ld.lld.exe
MKLINK /H ld.lld.exe lld.exe

DEL ld64.lld.exe
MKLINK /H ld64.lld.exe lld.exe

DEL wasm-ld.exe
MKLINK /H wasm-ld.exe lld.exe

DEL llvm-lib.exe
MKLINK /H llvm-lib.exe llvm-ar.exe

DEL llvm-ranlib.exe
MKLINK /H llvm-ranlib.exe llvm-ar.exe

@rem DEL libiomp5md.dll
@rem MKLINK /H libiomp5md.dll libomp.dll

POPD

@rem Python lldb
PUSHD lib\site-packages\lldb

IF EXIST _lldb.pyd (
	DEL _lldb.pyd
	MKLINK /H _lldb.pyd ..\..\..\bin\liblldb.dll
)
@rem LLVM 14.0.0
IF EXIST _lldb.cp310-win_amd64.pyd (
	DEL _lldb.cp310-win_amd64.pyd
	MKLINK /H _lldb.cp310-win_amd64.pyd ..\..\..\bin\liblldb.dll
)
IF EXIST _lldb.cp310-win32.pyd (
	DEL _lldb.cp310-win32.pyd
	MKLINK /H _lldb.cp310-win32.pyd ..\..\..\bin\liblldb.dll
)

DEL lldb-argdumper.exe
MKLINK /H lldb-argdumper.exe ..\..\..\bin\lldb-argdumper.exe

POPD

@rem LLVM 8.0 and later no longer contains this folder
@rem MKDIR msbuild-bin
@rem PUSHD msbuild-bin
@rem
@rem DEL cl.exe
@rem MKLINK /H cl.exe ..\bin\clang.exe
@rem POPD
