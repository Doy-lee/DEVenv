@echo off
setlocal
  set desired_path=%devenver_root%\raddbg\trunk
  set desired_exe=raddbg.exe

  set path=%desired_path%;%path%
  set exe_to_use=""
  for /f "delims=" %%a in ('where "$desired_path:%desired_exe%"') do ( set "exe_to_use=%%a")
  echo [DEVENVER] Executing script "%~dpnx0" with "%exe_to_use%"

  start /B %desired_exe% --user:%desired_path%\..\doylet.raddbg_user %*
endlocal
