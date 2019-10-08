require NBStarter.config_dir+"/../cluster-common/dburls"
dbkey = ENV['DB_ALIAS'] || 'hsql'
dburl = DBURLS[:m2][dbkey.downcase.to_sym]

master_url = DBURLS[:m2][dbkey.downcase.to_sym]
slave_url = DBURLS[:s2][dbkey.downcase.to_sym]

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
Database.recreate "MasterDB2" do
  description 'MasterDB2'
  protocol db_protocol_master
  port db_port_master.to_i
  resource master_resource  
  host "DBHostMaster"
  user "M2"
  password "M2"
  separator master_separator
end

# DB DEFINITIONS REQUIRED FOR INCLUSTER ORM REPLICATION
Database.recreate "SlaveDB2" do
  description 'SlaveDB2'
  protocol db_protocol_slave
  port db_port_slave.to_i
  resource slave_resource
  host "DBHostSlave"
  user "S2"
  password "S2"
  separator slave_separator
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

# TOPOLOGY RESERVE CLUSTER REQUIRED
ReserveCluster.recreate "Cluster2" do
	nodes "master2", "slave2"
end