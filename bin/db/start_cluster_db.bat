setlocal
title orm_test_cluster_db
call %~dp0..\env.bat
set HSQL_PARAMS=--database.0 file:%CLUSTER1_HOME%\master\rvec --dbname.0 m1 ^
--database.1 file:%CLUSTER1_HOME%\slave\rvec  --dbname.1 s1 ^
--database.2 file:%CLUSTER2_HOME%\master\rvec --dbname.2 m2 ^
--database.3 file:%CLUSTER2_HOME%\slave\rvec   --dbname.3 s2 ^
--database.4 file:%CLUSTER3_HOME%\master\rvec --dbname.4 m3 ^
--database.5 file:%CLUSTER3_HOME%\slave\rvec   --dbname.5 s3 ^
--port 9001 --address localhost
"%JAVA_HOME%\bin\java" -Xmx512m -Xms128m -cp %HSQL_PATH% org.hsqldb.server.Server  %HSQL_PARAMS%
endlocal
