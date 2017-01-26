OrmReplication.install

Plugin.delete "OrmReplicaton" rescue nil
Plugin.recreate "OrmReplication" do
   description "Test Orm Replication for Cluster1" 
   class_name '::OrmReplication::Plugin'
   topology_node "Cluster1"
   run false
end

Plugin.recreate "OrmReplicationTest" do
  description "Quartz instance for OrmReplicationTests" 
  run false
   topology_node 'Cluster1'
   class_name "QuartzPlugin" 
   params :scheduler => :orm_repl_test, :replication_mode => :memory
end 