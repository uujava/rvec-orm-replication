require NBStarter.config_dir+"/dburls"
dbkey = ENV['DB_ALIAS'] || 'hsql'
dburl = DBURLS[:m1][dbkey.downcase.to_sym]

master_url = DBURLS[:m1][dbkey.downcase.to_sym]
slave_url = DBURLS[:s1][dbkey.downcase.to_sym]

(db_protocol_master, master_ip, db_port_master, master_resource, master_separator) = parse_url master_url
(db_protocol_slave, slave_ip, db_port_slave, slave_resource, slave_separator) = parse_url slave_url

rise " worng #{master_url} #{slave_url}" if db_protocol_master != db_protocol_slave
  
Host.recreate "DBHostMaster" do
  interface 0 do
    ip master_ip
  end
end

Host.recreate "DBHostSlave" do
  interface 0 do
    ip slave_ip
  end
end
# DB DEFINITIONS REQUIRED FOR INCLUSTER ORM REPLICATION
Database.recreate "MasterDB" do
  description 'MasterDB'
  protocol db_protocol_master
  port db_port_master.to_i
  resource master_resource  
  host "DBHostMaster"
  user "M1"
  password "M1"
  separator master_separator
end

# DB DEFINITIONS REQUIRED FOR INCLUSTER ORM REPLICATION
Database.recreate "SlaveDB" do
  description 'SlaveDB'
  protocol db_protocol_slave
  port db_port_slave.to_i
  resource slave_resource
  host "DBHostSlave"
  user "S1"
  password "S1"
  separator slave_separator
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
