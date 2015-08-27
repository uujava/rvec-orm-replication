Host.recreate "DBHost" do
  interface 0 do
    ip "192.168.3.28"
  end
end

# DB DEFINITIONS REQUIRED FOR INCLUSTER ORM REPLICATION
Database.recreate "MasterDB" do
  description 'MasterDB'
  #protocol "jdbc:hsqldb:hsql://"
  protocol "jdbc:oracle:thin:@"
  host "DBHost"
  port 1521
  resource "rvec.programpark.ru"
  user "orm_m1"
  password "orm_m1"
end

# DB DEFINITIONS REQUIRED FOR INCLUSTER ORM REPLICATION
Database.recreate "SlaveDB" do
  description 'SlaveDB'
  #protocol "jdbc:hsqldb:hsql://"
  protocol "jdbc:oracle:thin:@"
  host "DBHost"
  port 1521
  resource "rvec.programpark.ru"
  user "orm_s1"
  password "orm_s1"
end

Host.recreate "Host_192.168.3.163" do
  interface 0 do
    ip "192.168.3.163"
  end
end

Host.recreate "Host_192.168.3.156" do
  interface 0 do
    ip "192.168.3.156"
  end
end

# TOPOLOGY SERVER NODES
ApplicationServer.recreate "master" do
	protocol "drbfire:"
	host "Host_192.168.3.163"
	port 2000
	ntf_port 20000
	orm_port 21000
	data_source 'MasterDB'
end

ApplicationServer.recreate "slave" do
	protocol "drbfire:"
	host "Host_192.168.3.156"
	port 2001
	ntf_port 20001
  orm_port 21001
	data_source 'SlaveDB'
end

# TOPOLOGY RESERVE CLUSTER REQUIRED
ReserveCluster.recreate "Cluster1" do
	nodes "master", "slave"
end

OrmReplication.install

Plugin.recreate "OrmReplicaton" do
   description "Test Orm Replication for Cluster1" 
   class_name '::OrmReplication::Plugin'
   topology_node "Cluster1"
   run true
end

Plugin.recreate "OrmReplicationTest" do
  description "Quartz instance for OrmReplicationTests" 
  run true
   topology_node 'Cluster1'
   class_name "QuartzPlugin" 
   params :scheduler => :orm_repl_test, :replication_mode => :memory
end 