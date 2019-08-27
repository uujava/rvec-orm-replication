# parent merger
Module.recreate :ORMT_M_ColumnDiffRefMerger do;end
Module.modify :ORMT_M_ColumnDiffRefMerger do
	methods do
    def get_blocks channel_id
      [::OrmReplication.create_block({}) ]
    end
  end
end

# merger to test columns
Module.recreate :ORMT_M_ColumnDiffMerger do;end
Module.modify :ORMT_M_ColumnDiffMerger do
	methods do
    def get_blocks channel_id
      [::OrmReplication.create_block({}) ]
    end
    
    def query
      'SELECT "ID", "COL_DATE", "COL_TEXT" FROM "ORMT_M_COLUMNDIFF"'
    end
    
    def fetchRows
      true
    end
	end
end

UserClass.recreate :ORMT_K_ColumnDiffMerger do
  is :DefaultOrmReplicationMerger
  modules :ORMT_M_ColumnDiffMerger
end

UserClass.recreate :ORMT_K_ColumnDiffRefMerger do
  is :DefaultOrmReplicationMerger
  modules :ORMT_M_ColumnDiffRefMerger
end
cluster = "Cluster1"
orm_name = "ORMT_K_ColumnDiffRef"

channels =  {
  "ORMT_M_COLUMNDIFF" => lambda do |channel|
    channel.cluster = cluster
    channel.orm_name = orm_name
    channel.orm_class = :ORMT_K_ColumnDiff
    channel.merger = :ORMT_K_ColumnDiffMerger
    channel.scheduler = "ORMT_M_COLUMNDIFFREF"
    channel.activate = true  
  end,
  "ORMT_M_COLUMNDIFFREF" => lambda do |channel|
    channel.cluster = cluster
    channel.orm_name = orm_name
    channel.orm_class = :ORMT_K_ColumnDiffRef
    channel.merger = :ORMT_K_ColumnDiffRefMerger
    channel.scheduler = "0 0/2 * ? * *"
    channel.query = "id != null"
    channel.activate = true  
  end
  
}   

storage_name = 'DiffReplication'
unless ::User::Storage.get_by_id storage_name
  Storage.recreate storage_name do
    description "ReplicationStorage: #{storage_name}"
    settings do
      table "objects"
    end
  end
end
result = ::OrmReplication.bulk_upsert channels, 'DiffReplication'
puts result