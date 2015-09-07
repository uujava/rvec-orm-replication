Host.recreate "DBHost" do
  interface 0 do
    ip "127.0.0.1"
  end
end

# DB DEFINITIONS REQUIRED FOR INCLUSTER ORM REPLICATION
Database.recreate "MasterDB" do
  description 'MasterDB'
  protocol "jdbc:hsqldb:hsql://"
  host "DBHost"
  resource "m1"
  user "M1"
  password "M1"
end

# DB DEFINITIONS REQUIRED FOR INCLUSTER ORM REPLICATION
Database.recreate "SlaveDB" do
  description 'SlaveDB'
  protocol "jdbc:hsqldb:hsql://"  
  host "DBHost"
  resource "s1"
  user "S1"
  password "S1"
end

Host.recreate "Host_127.0.0.1" do
  interface 0 do
    ip "127.0.0.1"
  end
end
# TOPOLOGY SERVER NODES
ApplicationServer.recreate "master" do
	protocol "drbfire:"
	host "Host_127.0.0.1"
	port 2000
	ntf_port 20000
	orm_port 21000
	data_source 'MasterDB'
end

ApplicationServer.recreate "slave" do
	protocol "drbfire:"
	host "Host_127.0.0.1"
	port 2001
	ntf_port 20001
  orm_port 21001
	data_source 'SlaveDB'
end

ApplicationServer.recreate "client" do
	protocol "drbfire:"
	host "Host_127.0.0.1"
	port 4000
	ntf_port 40000
end

# TOPOLOGY RESERVE CLUSTER REQUIRED
ReserveCluster.recreate "Cluster1" do
	nodes "master", "slave"
end