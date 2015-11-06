# Hold last transaction status
# Use local cache to avoid excessive db pulling
# avoid storing MORE than MAX_TX_COUNT in db
Module.recreate :ORMT_M_TransactionData do
  attribute :tx_id
  attribute :type 
end

Module.modify :ORMT_M_TransactionData do
    
  methods do
    
    def self.initialize 
      transient :transactions  # holds ordered linked tx_id list 
      transient :lock
    end
    
    #TODO implement policy to cleanup processed in DB
    def get_internal force = false
      @lock ||= Monitor.new
      if force
        @lock.synchronzie do
          @transactions = nil
        end
      end
      unless @transactions
        from_db = []
        ::User::ORMT_M_Transactions.find_unprocessed tx_id, Time.now, type  do |obj|
            from_db << [Time.from_sql(obj.tx_id), obj.flag]          
        end
      
        from_db.sort! {|t1, t2| t1[0] <=> t2[0]} 
        @lock.synchronize do 
          @transactions = from_db 
        end
      end
      @transactions
    end
       
    def update_internal tx_ids
      return if tx_ids.empty?
      
      tx_ids.sort!  {|t1, t2| t1[0] <=> t2[0]}
      
      latest_data = get_internal
      
      @lock.synchronize do
        latest_data = latest_data.clone
      end
      
      last = latest_data.last
      last_tx = last ? last[0] : tx_ids.first-1
      tx_ids.each do |tx|
        next if tx <= last_tx
        latest_data << [tx,0]
      end

      @lock.synchronize do
        @transactions = latest_data
      end
    end
    
    # use local cache to avoid excessive db pulling
    # safe as always will run from single quartz thread 
    # due to @DisallowConcurrentExecution for MergeBlockJob
    def next_block max_block, max_count
      return [] if unprocessed_count > max_count
      internal = get_internal.last
      last_id = internal ? internal[0] : tx_id
      curr_time = Time.now
      max_id = (curr_time - tx_id) > max_block ? tx_id + max_block : curr_time
      [
        ::OrmReplication.create_block(          
          :last_id  => last_id,
          :max_id  => max_id,
          :type => type
        )
      ]
    end 
    
    def mark_processed tx_id      
      @lock.synchronize do
        idx = -1
        latest_data = get_internal
        latest_data.each_with_index do |x, i|
          if x[0] == tx_id
            x[1] = 1
            idx = i
            break
          end
        end          
        if idx == -1
          $log.warn "illegal orm transaction cache state: #{tx_id} #{self.tx_id} #{latest_data.inspect}"
        else
          if idx > 1
            @transactions = latest_data[idx..-1]
          end
        end
      end
      ::User::ORMT_M_Transactions.mark_processed tx_id, type
    end
    
    def next_unprocessed
      get_internal.each { |tx| return tx[0] if tx[1] == 0 }
      nil
    end
    
    def unprocessed_count
      unprocessed = 0 
      get_internal.each { |tx| unprocessed+=1 if tx[1]==0 }
      return unprocessed
    end
    
    # shift tx_id for block 
    def touch_tx max_block
      now = Time.now
      if unprocessed_count == 0
        new_tx = self.tx_id + max_block
        if new_tx < now + max_block
          $log.debug "touch_tx #{tx_id} #{max_block} new tx: #{new_tx}"
          self.tx_id = new_tx
        end
      end
      self.tx_id
    end
  end
end

::User::ORMT_M_TransactionData.initialize
::User::ORMT_Utils.create_class :ORMT_M_TransactionData