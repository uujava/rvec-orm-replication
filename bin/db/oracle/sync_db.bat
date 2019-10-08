chcp 1251
echo remap %1:%2
call env.bat
call %SQL_PLUS% %SYS_CRED%@%DB_URL% as SYSDBA @prepare_link.sql %1 %2

REM linux:
REM mkdir /home/oracle/pump
REM export PU1=S1
REM export PU2=M1
REM expdp USERID=$PU1/$PU1@$ORACLE_SID directory=DUMPDIR DUMPFILE=$PU1.dmp network_link=SYNCLINK SCHEMAS=$PU1 REUSE_DUMPFILES=y consistent=y
REM impdp USERID=$PU1/$PU1@$ORACLE_SID directory=DUMPDIR DUMPFILE=$PU1.dmp SCHEMAS=$PU1 remap_schema=$PU1:$PU2 table_exists_action=replace

if errorlevel 0 (
	%EXPDP% USERID='%1^/%1@%DB_URL%' directory=DUMPDIR DUMPFILE=%1.dmp network_link=SYNCLINK SCHEMAS=%1 REUSE_DUMPFILES=y flashback_time=systimestamp
	if errorlevel 0 (
		%IMPDP% USERID='%1/%1@%DB_URL%' directory=DUMPDIR DUMPFILE=%1.dmp SCHEMAS=%1 remap_schema=%1^:%2 table_exists_action=replace
		if errorlevel 0 (
			%SQL_PLUS% %SYS_CRED%@%DB_URL% as SYSDBA @alter_user.sql %2
		)
	)
)