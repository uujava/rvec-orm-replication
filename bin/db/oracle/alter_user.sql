connect sys/vegatek@ORA11 as SYSDBA
define touser=&1
alter user &touser identified by &touser;
host 
exit