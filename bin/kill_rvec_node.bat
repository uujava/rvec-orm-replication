setlocal
call %~dp0env.bat
jruby.exe %~dp0cfg_path.rb %1 > %TMP_BAT%
call %TMP_BAT%
echo VAR_DIR: %VAR_DIR%
echo CFG_PATH: %CFG_PATH%
echo DEBUG_PORT: %DEBUG_PORT%
echo RVEC_HOME: %RVEC_HOME%
for %%i in ("%VAR_DIR%/../..") do set PID_PATH=%%~fi/pid
set WSLENV=PID_PATH/p
del %TMP_BAT%
wsl taskkill.exe /PID `cat  $PID_PATH` /F
endlocal