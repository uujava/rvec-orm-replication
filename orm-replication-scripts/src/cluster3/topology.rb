Host.recreate "DBHost" do
  interface 0 do
    ip "127.0.0.1"
  end
end

# TOPOLOGY RESERVE CLUSTER REQUIRED
ReserveCluster.recreate "Cluster3" do
	nodes "master3", "slave3"
end

# DB DEFINITIONS REQUIRED FOR INCLUSTER ORM REPLICATION
Database.recreate "MasterDB3" do
  description 'MasterDB3'
  protocol "jdbc:hsqldb:hsql://"
  host "DBHost"
  port 9001
  resource "m3"
  user "M3"
  password "M3"
end

Database.recreate "SlaveDB3" do
  description 'SlaveDB3'
  protocol "jdbc:hsqldb:hsql://"
  host "DBHost"
  port 9001
  resource "s3"
  user "S3"
  password "S3"
end

Host.recreate "Host_127.0.0.1" do
  interface 0 do
    ip "127.0.0.1"
  end
end

# TOPOLOGY SERVER NODES
ApplicationServer.recreate "master3" do
	protocol "drbfire:"
	host "Host_127.0.0.1"
	port 2020
	ntf_port 20020
  orm_port 21020
	data_source 'MasterDB3'
end

ApplicationServer.recreate "slave3" do
	protocol "drbfire:"
	host "Host_127.0.0.1"
	port 2021
	ntf_port 20021
  orm_port 21021
	data_source 'SlaveDB3'
end