setlocal
call %~dp0env.bat
jruby %~dp0cfg_path.rb %1 > %TMP_BAT%
call %TMP_BAT%
del /q %TMP_BAT%

set RVEC_MEMORY_OPT=-J-Xms128m -J-Xmx512m ^
-J-XX:+UseCMSInitiatingOccupancyOnly ^
-J-XX:CMSInitiatingOccupancyFraction=65 ^
-J-XX:+PrintGC ^
-J-XX:+PrintGCDetails ^
-J-XX:+PrintGCDateStamps ^
-J-Xloggc:%VAR_DIR%\gc.log ^
-J-XX:+UseGCLogFileRotation ^
-J-XX:NumberOfGCLogFiles=10 ^
-J-XX:GCLogFileSize=10000K ^
-J-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=%DEBUG_PORT%

rmdir /q /s %VAR_DIR%
mkdir %VAR_DIR%
del /q %TMP_BAT%
%RVEC_HOME%\server\bin\start.bat -Usu -P"super user" -D%CFG_PATH% %2 %3 %4 %5 %6 %7 %8 %9
endlocal