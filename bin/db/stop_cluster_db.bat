call %~dp0..\env.bat
set SQLTOOL="%JAVA_HOME%\bin\java" -cp %HSQL_PATH%;%~dp0sqltool-2.2.6.jar org.hsqldb.cmdline.SqlTool --rcFile=%~dp0sqltool.rc
%SQLTOOL% m1 shutdown.sql
%SQLTOOL% s1 shutdown.sql
%SQLTOOL% m2 shutdown.sql
%SQLTOOL% s2 shutdown.sql
%SQLTOOL% m3 shutdown.sql
%SQLTOOL% s3 shutdown.sql
