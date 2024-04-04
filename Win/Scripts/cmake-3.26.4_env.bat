@echo off
setlocal
  set path_to_add=%devenver_root%\CMake\3.26.4\bin
  set path=%path_to_add%;%path%
  echo [DEVENVER] "%~dpnx0" is adding to path "%path_to_add%"
  call %*
endlocal
