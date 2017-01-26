# replicated table for business transactions
Module.recreate :ORMT_M_Transactions do
  #pk
  attribute :id do
    type :Plain
    allowed_class :long
    column 'ID' do
      primary true
      type 'BIGINT'
    end
  end  
  
  # transaction id - timestamp of the transaction
  attribute :tx_id do
    type :Plain   
    allowed_class :date
    column 'TX_ID' do
      type 'TIMESTAMP'
    end
  end
  
  # transaction type to separate transactions for different business data
  attribute :type do
    type :Plain   
    allowed_class :string
    column 'TYPE' do
      length 200
    end
  end
  
  # 0 - commited in source
  # 1 - processed in target
  attribute :flag do
    type :Plain   
    allowed_class :int
    column 'FLAG'    
  end  
end

Module.modify :ORMT_M_Transactions do   
  methods do
     def self.initialize
       const_set :LOAN, 'LOAN'
     end
     
     def self.find_unprocessed _tx_id, _max_id, _type, &block
       ::User::ORMT_Utils.on_orm :ORMT_M_Transactions do |orm|
         ::User::ORMT_Utils._records(orm, 
           "tx_id >= $last_id and tx_id <= $max_id and type = $type and flag = 0",
           {
             :last_id => _tx_id, 
             :max_id => _max_id,
             :type => _type,
           }
         ) do |tx| yield tx 
         end
       end
     end
     
     def self.mark_processed tx_id, type
       begin
         query_params= {:tx_id => Time.to_sql(tx_id), :type => type}
         ::User::ORMT_Utils.on_orm :ORMT_M_Transactions do |orm|
           ::User::ORMT_Utils._records(orm, "tx_id = $tx_id and type = $type", query_params) do |tx|
             $log.debug "mark processed #{tx}"
             tx.flag = 1
           end
         end     
       rescue Exception => ex
         $log.error "unable to mark processed tx_id #{tx_id}"
       end  
     end
  end      
      
end

# init constants
ORMT_M_Transactions.initialize

# register ORM stuff
::User::ORMT_Utils.install :ORMT_M_Transactions, [%w{TX_ID FLAG}]
