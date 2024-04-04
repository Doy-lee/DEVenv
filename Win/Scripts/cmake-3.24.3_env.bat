@echo off
setlocal
  set path_to_add=%devenver_root%\CMake\3.24.3\bin
  set path=%path_to_add%;%path%
  echo [DEVENVER] "%~dpnx0" is adding to path "%path_to_add%"
  call %*
endlocal
