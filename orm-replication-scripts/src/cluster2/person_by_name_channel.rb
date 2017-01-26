Dsl.run_file File.dirname(__FILE__)+"/loan_channel.rb"  unless ::User.const_defined? :ORMT_K_TxMerger

# merger to test name in (?,?,..) query
Module.recreate :ORMT_M_PersonByNameMerger do;end
Module.modify :ORMT_M_PersonByNameMerger do
	methods do
    def get_blocks channel_id
      [::OrmReplication.create_block(:names  => ['P_2015-11-10 19:55:00 +0300','P_2015-11-10 19:45:00 +0300', 'P_2015-11-10 19:40:00 +0300']) ]
    end
    
    def query
      "SELECT * FROM ORMT_M_PERSON WHERE NAME in (#bind($names))"
    end
	end
end

UserClass.recreate :ORMT_K_PersonByNameMerger do
  is :DefaultOrmReplicationMerger
  modules :ORMT_M_PersonByNameMerger
end

cluster = "Cluster1"
orm_name = "ORMT_K_Person"

channels =  {
  "ORMT_PERSON_BY_NAME" => lambda do |channel|
    channel.cluster = cluster
    channel.orm_name = orm_name
    channel.orm_class = :ORMT_K_Person
    channel.merger = :ORMT_K_PersonByNameMerger
    channel.query = "name inxx $names"
    channel.scheduler = "0 0/2 * ? * *"
    channel.activate = true  
  end
}   

result = ::OrmReplication.bulk_upsert channels
puts result