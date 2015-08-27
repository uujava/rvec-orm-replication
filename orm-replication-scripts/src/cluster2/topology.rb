Host.recreate "DBHost" do
  interface 0 do
    ip "127.0.0.1"
  end
end

# TOPOLOGY RESERVE CLUSTER REQUIRED
ReserveCluster.recreate "Cluster2" do
	nodes "master2", "slave2"
end

# DB DEFINITIONS REQUIRED FOR INCLUSTER ORM REPLICATION
Database.recreate "MasterDB2" do
  description 'MasterDB2'
  protocol "jdbc:hsqldb:hsql://"
  host "DBHost"
  port 9001
  resource "m2"
  user "M2"
  password "M2"
end

Database.recreate "SlaveDB2" do
  description 'SlaveDB2'
  protocol "jdbc:hsqldb:hsql://"
  host "DBHost"
  port 9001
  resource "s2"
  user "S2"
  password "S2"
end

Host.recreate "Host_127.0.0.1" do
  interface 0 do
    ip "127.0.0.1"
  end
end

# TOPOLOGY SERVER NODES
ApplicationServer.recreate "master2" do
	protocol "drbfire:"
	host "Host_127.0.0.1"
	port 2010
	ntf_port 20010
  orm_port 21010
	data_source 'MasterDB2'
end

ApplicationServer.recreate "slave2" do
	protocol "drbfire:"
	host "Host_127.0.0.1"
	port 2011
	ntf_port 20011
  orm_port 21011
	data_source 'SlaveDB2'
end