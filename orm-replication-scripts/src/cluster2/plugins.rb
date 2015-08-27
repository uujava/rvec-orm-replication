OrmReplication.install

Plugin.recreate "OrmReplicaton2" do
   description "Test Orm Replication for Cluster1" 
   class_name '::OrmReplication::Plugin'
   topology_node "Cluster2"
   run true
end

Plugin.recreate "OrmReplicationTest2" do
  description "Quartz instance for OrmReplicationTests" 
  run true
   topology_node 'Cluster2'
   class_name "QuartzPlugin" 
   params :scheduler => :orm_repl_test2, :replication_mode => :memory
end 