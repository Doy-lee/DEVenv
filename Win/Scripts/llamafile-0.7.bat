@echo off
setlocal
  set exe=C:\Home\Cloud\PC\Programs\llamafile\llamafile-0.7
  echo [DEVENVER] "%~dpnx0" is executing %exe%
  call %exe% %*
endlocal
