Module.recreate :ORMT_M_ResourcePlan_Generator do
   methods do
     def execute ctx
      next_day = Date.today.next_day.to_time
      next_hour = Time.now.round + 7200
      $log.debug "start generate plans for day: #{next_day} hours: #{next_hour}"     
      ::User::ORMT_M_ResourcePlan.on_orm do |orm|
        generate_day_plan orm, next_day        
        generate_hour_plan orm, next_hour
      end
      ::User::ORMT_M_Trigger.get_trigger.plan_ready = Time.now
      $log.debug "splan ready for day: #{next_day} hours: #{next_hour}"
     end
   end
end
 
UserClass.recreate :ORMT_K_ResourcePlan_Generator do
 modules :ORMT_M_ResourcePlan_Generator
end

Module.recreate :ORMT_M_Trigger do
  
  attribute :name
  
  attribute :plan_ready
  
  methods do
     
    def self.install
      Storage.recreate(ORMT_M_Trigger.TRIGGER_STORAGE) {}
      UserObject.construct :ORMT_K_Trigger, ORMT_M_Trigger.TRIGGER_STORAGE do |obj|
        obj.name = ORMT_M_Trigger.TRIGGER_NAME
      end
    end

    def self.TRIGGER_NAME 
      'ORMT_GLOBAL_TRIGGER'
    end
    
    def self.TRIGGER_STORAGE 
      'ORMT_K_TRIGGER_STORAGE'
    end
    
    def self.get_trigger uid= ORMT_M_Trigger.TRIGGER_NAME
      trigger = nil
      Storage.each_object(ORMT_M_Trigger.TRIGGER_STORAGE) do |id, obj| 
        if obj.name == uid
          trigger = obj
          break          
        end
      end
      trigger
    end
    def self.create_plan_ready_filter uid = ORMT_M_Trigger.TRIGGER_NAME      
      AndComplexFilter.new ObjIdFilter.new(get_trigger.obj_id), PropertyFilter.new(:plan_ready)
    end    
  end
end
 
UserClass.recreate :ORMT_K_Trigger do
  modules :ORMT_M_Trigger
end

ORMT_M_Trigger.install

Job.recreate :orm_repl_test, "test.resource_plan" do   
   description "Triger resource plan generation"
   user_class :ORMT_K_ResourcePlan_Generator
   trigger 'test.test_trigger' do
     with_cron_schedule do
       cron_schedule "0/20 * * * * ?"
     end
   end
end