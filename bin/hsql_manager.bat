setlocal
call %~dp0env.bat
set HSQL_PATH=%RVEC_HOME%\server\rvec_server\modules\ext\ru.programpark.rvec.common-deps\org-hsqldb\hsqldb.jar
%JAVA_HOME%\bin\java -jar %HSQL_PATH%
endlocal