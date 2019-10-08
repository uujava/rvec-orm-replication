define fromuser=&1
define touser=&2

--define fromuser=S1
--define touser=M1
define sid=ORCLCDB
define link_name=&fromuser||_LINK
connect sys/Oradoc_db1@&sid as SYSDBA

grant EXP_FULL_DATABASE to &fromuser;
grant IMP_FULL_DATABASE to &fromuser;
drop user &touser cascade;
drop directory DUMPDIR;
create directory DUMPDIR as '/home/oracle/pump';
grant read, write on directory DUMPDIR to &fromuser;

connect &fromuser/&fromuser@&sid
drop database link SYNCLINK;
create database link SYNCLINK connect to &fromuser identified by &fromuser using '&sid';

exit