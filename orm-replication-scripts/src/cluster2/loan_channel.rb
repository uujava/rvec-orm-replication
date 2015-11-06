Dsl.run_file File.dirname(__FILE__)+"/../common/person_loan.rb" unless ::User.const_defined? :ORMT_M_Person
Dsl.run_file File.dirname(__FILE__)+"/../common/channel_reference.rb" unless ::User.const_defined? :ORMT_M_Channel
Dsl.run_file File.dirname(__FILE__)+"/transaction_channel.rb" unless ::User.const_defined? :ORMT_M_TransactionChannelMerger


# merger with transactions
Module.recreate :ORMT_M_TxMerger do
  methods do    
        
    def get_blocks channel_id
      @channel = ::User::UserObject.get channel_id
      @data = @channel.data_object
      @tx_id = @data.next_unprocessed 
      $log.debug "start tx_id: #{@tx_id}  for channel #{@channel}"
      [
        ::OrmReplication.create_block(          
          :last_tx  => @tx_id
        )
      ]
    end      
   
  end
end

Module.recreate :ORMT_M_TxRootMerger do
  
  methods do
    def finish is_error
      unless is_error
        @data.mark_processed @tx_id        
        $log.debug "finished tx_id: #{@tx_id}  for channel #{@channel.name}"
      end
    end    
  end
end

# Merger inherits default merger
UserClass.recreate :ORMT_K_TxRootMerger do
  is :DefaultOrmReplicationMerger
  modules :ORMT_M_TxMerger, :ORMT_M_TxRootMerger
end

UserClass.recreate :ORMT_K_TxMerger do
  is :DefaultOrmReplicationMerger
  modules :ORMT_M_TxMerger
end

data_object = ::OrmReplication.get("ORMT_LOAN_TRANSACTIONS").data_object
cluster = "Cluster1"
orm_name = "ORMT_K_Person"

channels =  {
  "ORMT_PERSON" => lambda do |channel|
    channel.cluster = cluster
    channel.orm_name = orm_name
    channel.orm_class = :ORMT_K_Person
    channel.merger = :ORMT_K_TxMerger
    channel.query = "loan_ref.modified = $last_tx"
    channel.scheduler = "ORMT_LOAN"
    channel.activate = true  
    channel.data_object = data_object
  end,
  "ORMT_LOAN" => lambda do |channel|
    channel.cluster = cluster
    channel.orm_name = orm_name
    channel.orm_class = :ORMT_K_Loan
    channel.merger = :ORMT_K_TxRootMerger
    channel.query = "modified = $last_tx"
    channel.scheduler = "0/20 * * ? * *" # actually scheduled by data_object.next_unprocessed
    channel.activate = true  
    channel.data_object = data_object
  end
}   

result = ::OrmReplication.bulk_upsert channels
puts result
