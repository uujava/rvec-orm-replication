chcp 1251
echo remap %1:%2
sqlplus -S /nolog "@prepare.sql" %1 %2

if errorlevel 0 (
	expdp USERID='%1^/%1@ORA11' directory=DUMPDIR DUMPFILE=%1.dmp network_link=SYNCLINK SCHEMAS=%1 REUSE_DUMPFILES=y
	if errorlevel 0 (
		impdp USERID='%1/%1@ORA11' directory=DUMPDIR DUMPFILE=%1.dmp SCHEMAS=%1 remap_schema=%1^:%2 table_exists_action=replace
		if errorlevel 0 (
			sqlplus -S /nolog "@alter_user.sql" %2
		)
	)
)