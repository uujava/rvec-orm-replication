Module.recreate :ORMT_M_ResourcePlanTable do
  methods do
    def handleNotification ntf
        @updated = Time.now
        self.populate
    end
  end
end

Model.recreate :ORMT_ResourcePlanTable do
  modules :ORMT_M_ResourcePlanTable
	type :Table
	constraint do
		populate_by do   
      plan_updated = @updated
      unless plan_updated
        channel = ::OrmReplication.get(::User::ORMT_ChannelTest::PLAN_CLASS)
        
        if channel.stat
          plan_updated = Time.from_sql channel.stat.block_stat.last_time
        else
          plan_updated = Time.new 0
        end
      end

     ::User::ORMT_Utils.on_orm :ORMT_M_ResourcePlan do |orm|
        _count = -1
        get_day_plan(orm).each do |row|
          _count = _count + 1
          yield row.record_id, [[row.year,row.month, row.day].join('-'), "--#{row.hour}", row.resource, row.qnt, _count, plan_updated]
        end
        get_hour_plan(orm).each do |row|
          _count = _count + 1
          yield row.record_id, [[row.year,row.month, row.day].join('-'), row.hour, row.resource, row.qnt, _count, plan_updated]
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
			title "Синхронизирован"
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
	subscribe_filter :propertyAccount, %q{::User::ORMT_ChannelTest.create_plan_filter}
end