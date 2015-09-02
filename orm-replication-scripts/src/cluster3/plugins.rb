OrmReplication.install

Plugin.recreate "OrmReplicaton3" do
   description "Test Orm Replication for Cluster3" 
   class_name '::OrmReplication::Plugin'
   topology_node "Cluster3"
   run true
end