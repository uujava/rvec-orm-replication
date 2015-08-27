setlocal
call env.bat
set HSQL_PARAMS=--database.0 file:%CLUSTER1_HOME%\master\rvec --dbname.0 m1 ^
--database.1 file:%CLUSTER1_HOME%\slave\rvec  --dbname.1 s1 ^
--database.2 file:%CLUSTER2_HOME%\master\rvec --dbname.2 m2 ^
--database.3 file:%CLUSTER2_HOME%\slave\rvec   --dbname.3 s2 ^
--port 9001 --address localhost
%JAVA_HOME%\bin\java -Xmx256m -Xms128m -cp %RVEC_HOME%\server\rvec_server\modules\ext\ru.programpark.rvec.common-deps\org-hsqldb\hsqldb.jar org.hsqldb.server.Server  %HSQL_PARAMS%
endlocal
