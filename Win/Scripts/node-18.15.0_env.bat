@echo off
setlocal
  set path=%devenver_root%\NodeJS\18.15.0;%path%
  echo [DEVENVER] Executing script "%~dpnx0" with "%exe_to_use%"
  call %*
endlocal
