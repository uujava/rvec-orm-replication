setlocal
call %~dp0env.bat
jruby %~dp0cfg_path.rb %1 > %TMP_BAT%
call %TMP_BAT%
echo VAR_DIR: %VAR_DIR%
echo CFG_PATH: %CFG_PATH%
echo DEBUG_PORT: %DEBUG_PORT%
echo RVEC_HOME: %RVEC_HOME%
echo cleanup NETBEANS for %1
rmdir /q /s %VAR_DIR%\..\..
mkdir %VAR_DIR%
del /q %TMP_BAT%
endlocal