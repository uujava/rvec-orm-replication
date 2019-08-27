@echo off
set TEST_BIN=%~dp0
echo using test dir: %TEST_BIN%
set SHORTCUTS=%TEST_BIN%shortcuts
set TEST_DB=%TEST_BIN%db
cmd -new_console:d:%SHORTCUTS% -new_console:bt:ZK /K start_zk.lnk
call %TEST_DB%\sync_db.bat
cmd -new_console:d:%TEST_DB% -new_console:bt:CLUSTER_DB /K start_cluster_db.bat
sleep 3
cmd -new_console:d:%SHORTCUTS% -new_console:bt:M1 /K "m1.lnk /C"
sleep 5
cmd -new_console:d:%SHORTCUTS% -new_console:bt:M2 /K "m2.lnk /C"
sleep 5
cmd -new_console:d:%SHORTCUTS% -new_console:bt:S1 /K s1.lnk
sleep 5
cmd -new_console:d:%SHORTCUTS% -new_console:bt:S2 /K s2.lnk