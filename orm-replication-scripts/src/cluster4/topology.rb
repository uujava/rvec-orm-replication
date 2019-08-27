Host.recreate "DBHost_3_231" do
  interface 0 do
    ip "192.168.3.231"
  end
end

Host.recreate "DBHost_3_232" do
  interface 0 do
    ip "192.168.3.232"
  end
end

# TOPOLOGY RESERVE CLUSTER REQUIRED
ReserveCluster.recreate "Cluster4" do
	nodes "master4", "slave4"
end

# DB DEFINITIONS REQUIRED FOR INCLUSTER ORM REPLICATION
Database.recreate "MasterDB4" do
  description 'MasterDB4'
  protocol "jdbc:postgresql://"
  host "DBHost_3_231"
  port 5432
  resource "rvec_database"
  user "orm_prod"
  password "orm_prod"
end

Database.recreate "SlaveDB4" do
  description 'SlaveDB4'
  protocol "jdbc:postgresql://"
  host "DBHost_3_232"
  port 5432
  resource "rvec_database"
  user "orm_prod"
  password "orm_prod"
end

Host.recreate "Host_127.0.0.1" do
  interface 0 do
    ip "127.0.0.1"
  end
end

# TOPOLOGY SERVER NODES
ApplicationServer.recreate "master4" do
	protocol "drbfire:"
	host "Host_127.0.0.1"
	port 2030
	ntf_port 20030
    orm_port 21030
	data_source 'MasterDB4'
end

ApplicationServer.recreate "slave4" do
	protocol "drbfire:"
	host "Host_127.0.0.1"
	port 2031
	ntf_port 20031
    orm_port 21031
	data_source 'SlaveDB4'
end