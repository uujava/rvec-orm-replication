setlocal
call %~dp0..\env.bat
"%JAVA_HOME%\bin\java" -jar %HSQL_PATH%
endlocal