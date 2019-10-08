call env.bat
echo table space USERS must be created in database!!
REM call %SQL_PLUS% %SYS_CRED%@%DB_URL% as SYSDBA %SQL_HOME%/create_db_user.sql M1
REM call %SQL_PLUS% %SYS_CRED%@%DB_URL% as SYSDBA %SQL_HOME%/create_db_user.sql S1
REM call %SQL_PLUS% M1/M1@%DB_URL% %SQL_HOME%/all.sql
REM call %SQL_PLUS% S1/S1@%DB_URL% %SQL_HOME%/all.sql
call %SQL_PLUS% %SYS_CRED%@%DB_URL% as SYSDBA %SQL_HOME%/create_db_user.sql M2
call %SQL_PLUS% %SYS_CRED%@%DB_URL% as SYSDBA %SQL_HOME%/create_db_user.sql S2
call %SQL_PLUS% M2/M2@%DB_URL% %SQL_HOME%/all.sql
call %SQL_PLUS% S2/S2@%DB_URL% %SQL_HOME%/all.sql