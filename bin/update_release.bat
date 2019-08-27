call %~dp0env.bat
rmdir /s/q %RVEC_HOME%
unzip %RELEASE_PATH% -d %RVEC_HOME%
rmdir /s/q %CLUSTER1_HOME%\.netbeans-master_cfg\.rvec-tmp
rmdir /s/q %CLUSTER1_HOME%\.netbeans-slave_cfg\.rvec-tmp
rmdir /s/q %CLUSTER1_HOME%\.netbeans-client_cfg\.rvec-tmp
rmdir /s/q %CLUSTER1_HOME%\.netbeans-master_cfg\.metadata
rmdir /s/q %CLUSTER1_HOME%\.netbeans-slave_cfg\.metadata
rmdir /s/q %CLUSTER1_HOME%\.netbeans-client_cfg\.metadata
rmdir /s/q %CLUSTER1_HOME%\.netbeans-master_cfg\var
rmdir /s/q %CLUSTER1_HOME%\.netbeans-slave_cfg\var
rmdir /s/q %CLUSTER1_HOME%\.netbeans-client_cfg\var
rmdir /s/q %CLUSTER2_HOME%\.netbeans-master_cfg\.rvec-tmp
rmdir /s/q %CLUSTER2_HOME%\.netbeans-slave_cfg\.rvec-tmp
rmdir /s/q %CLUSTER2_HOME%\.netbeans-master_cfg\var
rmdir /s/q %CLUSTER2_HOME%\.netbeans-master_cfg\.metadata
rmdir /s/q %CLUSTER2_HOME%\.netbeans-slave_cfg\.metadata
rmdir /s/q %CLUSTER2_HOME%\.netbeans-slave_cfg\var
rmdir /s/q %CLUSTER3_HOME%\.netbeans-master_cfg\.rvec-tmp
rmdir /s/q %CLUSTER3_HOME%\.netbeans-slave_cfg\.rvec-tmp
rmdir /s/q %CLUSTER3_HOME%\.netbeans-master_cfg\.metadata
rmdir /s/q %CLUSTER3_HOME%\.netbeans-slave_cfg\.metadata
rmdir /s/q %CLUSTER3_HOME%\.netbeans-master_cfg\var
rmdir /s/q %CLUSTER3_HOME%\.netbeans-slave_cfg\var
rmdir /s/q %CLUSTER4_HOME%\.netbeans-master_cfg\.rvec-tmp
rmdir /s/q %CLUSTER4_HOME%\.netbeans-slave_cfg\.rvec-tmp
rmdir /s/q %CLUSTER4_HOME%\.netbeans-master_cfg\.metadata
rmdir /s/q %CLUSTER4_HOME%\.netbeans-slave_cfg\.metadata
rmdir /s/q %CLUSTER4_HOME%\.netbeans-master_cfg\var
rmdir /s/q %CLUSTER4_HOME%\.netbeans-slave_cfg\var
copy /y rvec-log4j.xml %RVEC_HOME%\server\bin
