@echo off
setlocal
  set path_to_add=%devenver_root%\NodeJS\18.15.0
  set path=%path_to_add%;%path%
  echo [DEVENVER] "%~dpnx0" is adding to path "%path_to_add%"
  call %*
endlocal
