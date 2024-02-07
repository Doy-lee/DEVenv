@echo off
setlocal
  set path=%devenver_root%\NodeJS\12.22.12;%path%
  echo [DEVENVER] Executing script "%~dpnx0" with "%*"
  call %*
endlocal
