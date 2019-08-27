define fromuser=&1
define touser=&2
define link_name=&fromuser||_LINK
connect sys/vegatek@ORA11 as SYSDBA

grant EXP_FULL_DATABASE to &fromuser;
grant IMP_FULL_DATABASE to &fromuser;
drop user &touser cascade;
drop directory DUMPDIR;
create directory DUMPDIR as 'E:\database\pump';
grant read, write on directory DUMPDIR to &fromuser;

connect &fromuser/&fromuser@ORA11
drop database link SYNCLINK;
create database link SYNCLINK connect to &fromuser identified by &fromuser using 'ORA11';

exit