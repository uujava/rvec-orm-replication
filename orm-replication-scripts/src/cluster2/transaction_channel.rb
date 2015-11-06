Dsl.run_file File.dirname(__FILE__)+"/../common/orm_test_utils.rb"
Dsl.run_file File.dirname(__FILE__)+"/../common/loan_transactions.rb" unless ::User.const_defined? :ORMT_M_TransactionChannelMerger
Dsl.run_file File.dirname(__FILE__)+"/../common/transaction_data.rb" unless ::User.const_defined? :ORMT_M_TransactionData
Dsl.run_file File.dirname(__FILE__)+"/../common/channel_reference.rb" unless ::User.const_defined? :ORMT_M_Channel

Plugin.stop "OrmReplication2"
# merger for transactions
::User::Module.recreate :ORMT_M_TransactionChannelMerger do
  methods do    
    
    def self.initialize
      const_set :TRANSACTION_CLASS, "ORMT_K_Transactions" 
      const_set :TRANSACTION_BLOCK, "ORMT_M_TransactionData"
      const_set :TRANSACTION_BLOCK_CLASS, "ORMT_K_TransactionData"
      const_set :DEFAULT_SCHEDULE, "0 0/5 * ? * *" # used when tx_count > 1
      const_set :TRANSACTION_QUERY, "tx_id > $last_id and tx_id <= $max_id and type= $type"
      const_set :INIT_SCHEDULE, "0/20 * * ? * *" # used when tx_count == 0 and tx_id + (1/24) < Time.now
      const_set :MAX_TX_COUNT, 10
      const_set :MAX_BLOCK, 3*3600 # max block to load from source
      const_set :INIT_TX_SEC,  24*3600  # initial replication start Time.now - INIT_TX_SEC
    end       
      
    def self.install
      initialize      
    end
    
    def get_blocks channel_id
      @channel = UserObject.get channel_id
      @data = @channel.data_object
      @records = [] # collect in memory, update on finish
      @data.next_block MAX_BLOCK, MAX_TX_COUNT
    end      

    def inserted new_record
      @records << new_record.tx_id
      super
    end

    def updated(old_record, new_record) 
      false
    end
    
    def deleted(old_record) 
      false
    end
    
    def finish is_error
      unless is_error
        if @records.empty?
          @data.touch_tx MAX_BLOCK
        else
          @data.update_internal @records
          $log.debug "added tx #{@data.inspect} last_tx: #{@data.tx_id}"          
        end
        if @data.tx_id + MAX_BLOCK > Time.now
          @channel.activate = false
          @channel.scheduler = DEFAULT_SCHEDULE
          @channel.activate = true
        end
      end
    end
  end
end

# Merger inherits default merger
UserClass.recreate :ORMT_K_TransactionChannelMerger do
  is :DefaultOrmReplicationMerger
  modules :ORMT_M_TransactionChannelMerger
end

# add reference from channel to some data object
::User::Module.recreate :ORMT_M_Channel do
  attribute :data_object do
    type :Reference
  end
end

::User::UserClass.modify ::OrmReplication::CHANNEL_CLASS do
  add_modules :ORMT_M_Channel
end rescue nil

::User::ORMT_M_TransactionChannelMerger.install

# create storage for transaction blocks      
module ::User::ORMT_M_TransactionChannelMerger
  
  ::User::Storage.recreate(TRANSACTION_BLOCK) {} 

  # create block data for LOAN transactions
  block_data = ::User::UserObject.create do
    is TRANSACTION_BLOCK_CLASS.to_sym
    into TRANSACTION_BLOCK
  end

  # start replication from init tx
  block_data.tx_id = Time.now - INIT_TX_SEC
  block_data.type = ::User::ORMT_M_Transactions::LOAN
      
  result = ::OrmReplication.upsert "ORMT_LOAN_TRANSACTIONS" do |channel|
    channel.cluster = "Cluster1"
    channel.orm_name = TRANSACTION_CLASS
    channel.orm_class = TRANSACTION_CLASS.to_sym
    channel.merger = :ORMT_K_TransactionChannelMerger
    channel.query = TRANSACTION_QUERY
    channel.scheduler = INIT_SCHEDULE
    channel.activate = true  
    channel.data_object = block_data
  end
  
  puts result.inspect

end

Plugin.start "OrmReplication2"