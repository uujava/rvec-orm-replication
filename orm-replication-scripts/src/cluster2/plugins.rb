OrmReplication.install

Plugin.delete "OrmReplicaton2" rescue nil

Plugin.recreate "OrmReplication2" do
   description "Test Orm Replication for Cluster2" 
   class_name '::OrmReplication::Plugin'
   topology_node "Cluster2"
   run false
end

Plugin.recreate "OrmDiffReplication" do
   description "Diff Replication for Cluster2" 
   class_name '::OrmReplication::Plugin'
   topology_node "Cluster2"
   params :storage => 'DiffReplication'
   run false
end

Plugin.recreate "OrmReplicationTest2" do
  description "Quartz instance for OrmReplicationTests" 
  run false
  topology_node 'Cluster2'
  class_name "QuartzPlugin" 
  params :scheduler => :orm_repl_test2, :replication_mode => :memory
end 