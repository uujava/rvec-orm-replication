chcp 65001
REM set JAVA_HOME, JRUBY_HOME if not set
if "%JAVA_HOME% " == " " echo "set JAVA_HOME to jdk installation home folder " && exit
if "%JRUBY_HOME% " == " " echo "set JRUBY_HOME to jruby 1.7.4 installation home folder with patched rvec jruby.jar" && exit
set TMP_BAT=%~dp0~env_%RANDOM%temp.bat
set RELEASE_PATH=h:\code\rvec-production\target\rvec-sdk-ide-1.0(${env.BUILD_NUMBER}).zip
REM set RVEC_HOME=h:\data\rvec-release
REM set RVEC_HOME=h:\code\rvec-production\rt_pre
set RVEC_HOME=h:\code\rvec-production\rt
REM set RVEC_HOME2=%RVEC_HOME%
set RVEC_HOME2=h:\data\rvec-release
set HSQL_PATH=%RVEC_HOME%\server\rvec_server\modules\ext\ru.programpark.rvec.common-deps\org-hsqldb\hsqldb.jar
set CLUSTER1_HOME=%~dp0..\cluster1
set CLUSTER2_HOME=%~dp0..\cluster2
set CLUSTER3_HOME=%~dp0..\cluster3