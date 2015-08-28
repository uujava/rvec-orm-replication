Module.recreate :ORMT_ChannelTest do
  methods do    
    
    def self.initialize
      const_set :PLAN_CLASS, "ORMT_K_ResourcePlan"
    end       
      

    def self.install
      initialize
      channels = {
        PLAN_CLASS => lambda do |channel|
          channel.cluster = "Cluster1"
          channel.orm_name = PLAN_CLASS
          channel.orm_class = PLAN_CLASS.to_sym
          channel.merger = :ORMT_K_ResourcePlanMerger
          channel.query = "year = $year and day = $day and month = $month and hour = $hour" # ORM query. Parameters supplied by block generator
          channel.scheduler = "5/15 * * ? * *" 
          channel.activate = true  
        end
      }

      ::OrmReplication.bulk_upsert channels

    end
    
    def self.create_plan_filter 
      create_filter PLAN_CLASS
    end
    
    def self.create_filter channel_name      
      channel = ::OrmReplication.get channel_name      
      raise "Channel not found #{channel_name}" unless channel
      AndComplexFilter.new PropertyFilter.new(:stat), ObjIdFilter.new(channel.obj_id)
    end
  end
end

Module.recreate :ORMT_M_ResourcePlanMerger do
  methods do
    def get_blocks
      time = Time.now + 7200
      date = Date.today.next_day.to_time
      [
        ::OrmReplication.create_block(          
            :year  => time.year,
            :month  => time.month,
            :day  => time.day,
            :hour => time.hour
           ),
        ::OrmReplication.create_block(           
            :year  => date.year,
            :month  => date.month,
            :day  => date.day,
            :hour => nil          
        )
      ]
    end      
  end
end

UserClass.recreate :ORMT_K_ResourcePlanMerger do
  is :DefaultOrmReplicationMerger
  modules :ORMT_M_ResourcePlanMerger
end

ORMT_ChannelTest.install
