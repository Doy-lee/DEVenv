@echo off
setlocal
  set desired_path=%devenver_root%\NodeJS\16.19.0
  set desired_exe=yarn

  set path=%desired_path%;%path%
  set exe_to_use=""
  for /f "delims=" %%a in ('where "$desired_path:%desired_exe%"') do ( set "exe_to_use=%%a")
  echo [DEVENVER] Executing script "%~dpnx0" with "%exe_to_use%"

  call %desired_exe% %*
endlocal
