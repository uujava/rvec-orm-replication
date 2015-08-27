#GENERATE ORM ONLY AFTER TOPOLOGY AND INCLUSTER REPLICATION CHECKED
Module.recreate :ORMT_M_ResourcePlan do 
  attribute :record_id do
    type :Integer
    allowed_class :long
    column "ID" do
      primary true
    end
  end
 
  attribute :year do
    type :Integer
    column 'YEAR'
    allowed_class :int
  end

  attribute :day do
    type :Integer
    column 'DAY'
    allowed_class :int
  end

  attribute :month do
    type :Integer
    column 'MONTH'
    allowed_class :int
  end
   
  attribute :hour do
    type :Integer
    column 'HOUR'
    allowed_class :int
  end

  attribute :resource do
    type :Plain
    column 'RESOURCE' do
      length 10
    end
    allowed_class :string
  end

  attribute :qnt do
    type :Integer   
    allowed_class :int
    column 'QNT'
  end
  
end

UserClass.recreate  :ORMT_K_ResourcePlan do
  modules :ORMT_M_ResourcePlan
  table 'ORMT_K_RESOURCEPLAN'
end

# utility methods
Module.modify :ORMT_M_ResourcePlan do
  methods do
    def self.resources
      ['ice cream', 'hamburger', 'cola' , 'coffee', 'shrimps', 'beef']
    end
    
    def self.generate_hour_plan orm, hour_date            
      query = "year = $year and month = $month and day = $day and hour = $hour"
      params = {
        :year  => hour_date.year,
        :month  => hour_date.month,
        :day  => hour_date.day,
        :hour => hour_date.hour        
      } 
      update = false
      _records(orm, query, params) { |row| 
        update = true
        row.qnt = rand 50
      }      
      unless update
        resources.each do |res|
          rec = orm.create_object :ORMT_K_ResourcePlan
          rec.year = hour_date.year
          rec.month = hour_date.month
          rec.day = hour_date.day
          rec.hour = hour_date.hour
          rec.resource = res
          rec.qnt = rand 50
        end          
      end
    end
    
    def self.generate_day_plan orm, date
      query = "year = $year and month = $month and day = $day and hour = null"
      params = {
        :year  => date.year,
        :month  => date.month,
        :day  => date.day        
      } 
      update = false
      _records(orm, query, params) { |row| 
        update = true
        row.qnt = rand 50*24
      }  
      unless update
        resources.each do |res|
          rec = orm.create_object :ORMT_K_ResourcePlan
          rec.year = date.year
          rec.month = date.month
          rec.day = date.day
          rec.hour = nil
          rec.resource = res
          rec.qnt = rand 50*24
        end      
      end
    end

    def self.get_hour_plan orm, plan_date=(Time.now + 7200)
      _result = []
      query = "year = $year and month = $month and day = $day and hour = $hour"
      params = {:year  => plan_date.year,:month  => plan_date.month,:day  => plan_date.day, :hour => plan_date.hour} 
      _records(orm, query, params) { |row| _result << row }      
      _result
    end
    
    def self.get_day_plan orm, plan_date=Date.today.next.to_time
      _result = []
      query = "year = $year and month = $month and day = $day and hour = null"
      params = {:year  => plan_date.year,:month  => plan_date.month,:day  => plan_date.day} 
      _records(orm, query, params) { |row| _result << row }      
      _result
    end
    
    def self.clear_all orm
      query = "1 = 1 "
      params = {} 
      _records(orm, query, params) { |row| delete_object row }      
    end
    
    def self.clear_hour_plan orm, plan_date=(Time.now + 7200)
      query = "delete from ORMT_K_RESOURCEPLAN where YEAR = #bind($year) and MONTH = #bind($month) and DAY = #bind($day) and hour = #bind($hour)"
      params = {:year  => plan_date.year,:month  => plan_date.month,:day  => plan_date.day, :hour => plan_date.hour} 
      _raw_records(orm, query, params) { |_| }      
    end
    
    def self.clear_day_plan orm, plan_date=Date.today.next.to_time
      query = "delete from ORMT_K_RESOURCEPLAN where YEAR = #bind($year) and MONTH = #bind($month) and DAY = #bind($day) and hour IS NULL"
      params = {:year  => plan_date.year,:month  => plan_date.month,:day  => plan_date.day} 
      _raw_records(orm, query, params) {|_| }   
    end
    
    def self._records(orm, orm_query, query_params, &block)
      orm.execute do
        type :ORMT_K_ResourcePlan   
        query orm_query
        query_params.each do |k,v|
          param k, v          
        end
        result &block
      end
    end
    
    def self._raw_records(orm, orm_query, query_params, &block)
      orm.execute do
        type :ORMT_K_ResourcePlan   
        query orm_query
        query_params.each {|k,v| param k, v}          
        sql_result &block
      end
    end
        
    def self.on_orm &block
      orm = ::User::ORM.get 'ORMT_K_ResourcePlan'
      begin        
        module_exec orm, &block
        orm.commit_changes
      rescue Exception => ex
        puts "Unable process orm block #{ex} #{ex.backtrace}"
        orm.rollback_changes rescue nil
        raise ex
      ensure
        orm.done
      end
    end
    
    def self.install
      msg = ::User::ORM.generate 'ORMT_K_ResourcePlan' do
        useclasses :ORMT_K_ResourcePlan
        generate_db_schema do
          drop_tables true    
          fk_constraints true
        end
        version 21
      end

      puts msg
      puts "wait binary comitted"
      sleep 5
      puts "creating indices"
      create_indices
    end
    
    def self.create_indices
      orm = ::User::ORM.get "ORMT_K_ResourcePlan"
      begin    
        table = "ORMT_K_RESOURCEPLAN"
        idx = table+'IDX1'  
        idx_query = "CREATE INDEX #{idx} ON #{table} (YEAR, MONTH, DAY, HOUR)"
        drop_query = "DROP INDEX #{idx}"
        begin
          orm.execute do
            query drop_query
            row_result do |row|
              $log.debug "ORM test index #{idx} on #{table} dropped"
            end
          end
        rescue Exception => ex
          $log.debug "ORM test index  #{idx} on #{table} does not exists: #{ex.cause}"
        end
        begin
          orm.execute do
            query idx_query
            row_result do |row|
              $log.debug  "ORM test index  #{idx} on #{table} created"
            end
          end
        rescue Exception => ex
          $log.error "Error creating ORM test index  #{idx} on #{table}: #{ex.cause}"
        end
      ensure
        orm.done
      end
    end
  end
end


ORMT_M_ResourcePlan.install

