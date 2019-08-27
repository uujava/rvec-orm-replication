call %~dp0..\env.bat
set SQLTOOL="%JAVA_HOME%\bin\java" -cp %HSQL_PATH%;%~dp0sqltool-2.2.6.jar org.hsqldb.cmdline.SqlTool --rcFile=%~dp0sqltool.rc
%SQLTOOL% m1 shutdown.sql
%SQLTOOL% s1 shutdown.sql
%SQLTOOL% m2 shutdown.sql
%SQLTOOL% s2 shutdown.sql
%SQLTOOL% m3 shutdown.sql
%SQLTOOL% s3 shutdown.sql

set PATH_FROM=master
set PATH_TO=slave

rmdir /s/q %CLUSTER1_HOME%\%PATH_TO%
rmdir /s/q %CLUSTER2_HOME%\%PATH_TO%
rmdir /s/q %CLUSTER3_HOME%\%PATH_TO%
xcopy /s/y/I %CLUSTER1_HOME%\%PATH_FROM% %CLUSTER1_HOME%\%PATH_TO%
xcopy /s/y/I %CLUSTER2_HOME%\%PATH_FROM% %CLUSTER2_HOME%\%PATH_TO%
xcopy /s/y/I %CLUSTER3_HOME%\%PATH_FROM% %CLUSTER3_HOME%\%PATH_TO%
