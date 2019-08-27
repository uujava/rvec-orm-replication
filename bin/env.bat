chcp 65001
REM set JAVA_HOME, JRUBY_HOME if not set
call java7.bat
if "%JAVA_HOME% " == " " echo "set JAVA_HOME to jdk installation home folder " && exit
if "%JRUBY_HOME% " == " " echo "set JRUBY_HOME to jruby 1.7.4 installation home folder with patched rvec jruby.jar" && exit
set TMP_BAT=%~dp0~env_%RANDOM%temp.bat
REM set RELEASE_PATH=c:\Users\kozyr\Downloads\rvec-sdk-ide-1.0(release-707).zip 
REM set RELEASE_PATH=c:\Users\user\Downloads\rvec-sdk-ide-1.0(release-707).zip 
set RELEASE_PATH=h:\code\rvec-production\target\rvec-sdk-ide-1.0(${env.BUILD_NUMBER}).zip
REM set RVEC_HOME=h:\code\rvec-production\rt
set RVEC_HOME=h:\data\rvec-release
set RVEC_HOME1=%RVEC_HOME%
REM set RVEC_HOME1=h:\code\rvec-production\rt
set RVEC_HOME2=%RVEC_HOME%
REM set RVEC_HOME2=h:\code\rvec-production\rt
set RVEC_HOME3=%RVEC_HOME%
REM set RVEC_HOME3=h:\code\rvec-production\rt
set HSQL_PATH=%RVEC_HOME%\server\rvec_server\modules\ext\ru.programpark.rvec.common-deps\org-hsqldb\hsqldb.jar
set CLUSTER1_HOME=%~dp0..\cluster1
set CLUSTER2_HOME=%~dp0..\cluster2
set CLUSTER3_HOME=%~dp0..\cluster3
set CLUSTER4_HOME=%~dp0..\cluster4
set SRC_DIR=%~dp0/../orm-replication-scripts/src
REM valid DB: [hsql],vm,oraclee,pgsql,db01
set DB_ALIAS=oraclee