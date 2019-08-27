call env.bat
call %SQL_PLUS% %SYS_CRED%@%DB_URL% as SYSDBA %SQL_HOME%/create_db_user.sql M1
call %SQL_PLUS% %SYS_CRED%@%DB_URL% as SYSDBA %SQL_HOME%/create_db_user.sql S1
call %SQL_PLUS% M1/M1@%DB_URL% %SQL_HOME%/all.sql
call %SQL_PLUS% S1/S1@%DB_URL% %SQL_HOME%/all.sql