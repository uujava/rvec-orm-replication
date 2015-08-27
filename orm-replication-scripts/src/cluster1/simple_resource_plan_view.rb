Module.recreate :ORMT_M_ResourcePlanTable do
  methods do
    def handleNotification ntf
        self.populate
    end
  end
end

Model.recreate :ORMT_ResourcePlanTable do
  modules :ORMT_M_ResourcePlanTable
	type :Table
	constraint do
		populate_by do      
      plan_ready = ::User::ORMT_M_Trigger.get_trigger.plan_ready
      ::User::ORMT_M_ResourcePlan.on_orm do |orm|
        _count = -1
        get_day_plan(orm).each do |row|
          _count = _count + 1
          yield row.record_id, [[row.year,row.month, row.day].join('-'), "--#{row.hour}", row.resource, row.qnt, _count, plan_ready]
        end
        get_hour_plan(orm).each do |row|
          _count = _count + 1
          yield row.record_id, [[row.year,row.month, row.day].join('-'), row.hour, row.resource, row.qnt, _count, plan_ready]
        end
      end
		end    
	end
	ui_describe do
    column :num do
			title "Номер"
			type :Integer		
      mapping do
        at(4) + 1
      end
		end
    column :plan_ready do
			title "Модифицирован"
			type :Date		
      mapping do
        at(5)
      end
		end
		column :plan_date do
			title "Дата"
			type :Date		
      mapping do
        at(0)
      end
		end
		column :hour do
			title "Час"
			type :Integer
      mapping do
        at(1)
      end
		end
 		column :resource do
			title "Ресурс"
			type :String
      mapping do
        at(2)
      end
		end
 		column :qnt do
			title "Количество"
			type :Integer
      mapping do
        at(3)
      end
		end
	end
  subscribe :propertyAccount
	subscribe_filter :propertyAccount, %q{::User::ORMT_M_Trigger.create_plan_ready_filter}
end