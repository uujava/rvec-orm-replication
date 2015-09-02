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
      length 20
    end
    allowed_class :string
  end

  attribute :qnt do
    type :Integer   
    allowed_class :int
    column 'QNT'
  end
  
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
      ::User::ORMT_Utils._records(orm, query, params) { |row| 
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
      ::User::ORMT_Utils._records(orm, query, params) { |row| 
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
      ::User::ORMT_Utils._records(orm, query, params) { |row| _result << row }      
      _result
    end
    
    def self.get_day_plan orm, plan_date=Date.today.next.to_time
      _result = []
      query = "year = $year and month = $month and day = $day and hour = null"
      params = {:year  => plan_date.year,:month  => plan_date.month,:day  => plan_date.day} 
      ::User::ORMT_Utils._records(orm, query, params) { |row| _result << row }      
      _result
    end
    
    def self.clear_all orm
      query = "1 = 1 "
      params = {} 
      ::User::ORMT_Utils._records(orm, query, params) { |row| delete_object row }      
    end
    
    def self.clear_hour_plan orm, plan_date=(Time.now + 7200)
      query = "delete from ORMT_K_RESOURCEPLAN where YEAR = #bind($year) and MONTH = #bind($month) and DAY = #bind($day) and hour = #bind($hour)"
      params = {:year  => plan_date.year,:month  => plan_date.month,:day  => plan_date.day, :hour => plan_date.hour} 
      ::User::ORMT_Utils._raw_records(orm, query, params) { |_| }      
    end
    
    def self.clear_day_plan orm, plan_date=Date.today.next.to_time
      query = "delete from ORMT_K_RESOURCEPLAN where YEAR = #bind($year) and MONTH = #bind($month) and DAY = #bind($day) and hour IS NULL"
      params = {:year  => plan_date.year,:month  => plan_date.month,:day  => plan_date.day} 
      ::User::ORMT_Utils._raw_records(orm, query, params) {|_| }   
    end
                
  end
end

::User::ORMT_Utils.install :ORMT_M_ResourcePlan, [%w{YEAR MONTH DAY HOUR}], 22

