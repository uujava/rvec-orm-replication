call env.bat
rmdir /s/q %RVEC_HOME%
unzip %RELEASE_PATH% -d %RVEC_HOME%
rmdir /s/q %CLUSTER1_HOME%\.netbeans-master_cfg
rmdir /s/q %CLUSTER1_HOME%\.netbeans-slave_cfg
rmdir /s/q %CLUSTER2_HOME%\.netbeans-slave_cfg
rmdir /s/q %CLUSTER2_HOME%\.netbeans-master_cfg
rmdir /s/q %CLUSTER3_HOME%\.netbeans-slave_cfg
rmdir /s/q %CLUSTER3_HOME%\.netbeans-master_cfg
copy /y rvec-log4j.xml %RVEC_HOME%\server\bin
