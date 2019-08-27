OrmReplication.install

Plugin.recreate "OrmDiffReplication" do
   description "Diff Replication for Cluster4" 
   class_name '::OrmReplication::Plugin'
   topology_node "Cluster4"
   params :storage => 'DiffReplication'
   run false
end
