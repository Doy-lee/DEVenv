@echo off
setlocal
  set desired_path=%devenver_root%\..\..\Cryptomator\Dev\Win\RemedyBG\0_3_9_4
  set desired_exe=remedybg.exe

  set path=%desired_path%;%path%
  set exe_to_use=""
  for /f "delims=" %%a in ('where "$desired_path:%desired_exe%"') do ( set "exe_to_use=%%a")
  echo [DEVENVER] Executing script "%~dpnx0" with "%exe_to_use%"

  start /B %desired_exe% %*
endlocal
