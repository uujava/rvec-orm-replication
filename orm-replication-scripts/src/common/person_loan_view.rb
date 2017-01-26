Module.recreate :ORMT_M_PersonTable do
  methods do
    def handleNotification ntf
      self.populate
    end
  end
end

Model.recreate :ORMT_PersonTable do
  modules :ORMT_M_PersonTable
	type :Table
	constraint do
		populate_by do         
      ::User::ORMT_M_Person.get_persons.each_with_index do |data, i|
        yield i, [data.record_id, data.name, data.description, data.modified]
      end    
    end
	end
	ui_describe do
    column :user do
			title 'Клиент'
			type :String		
      mapping do
        at(1) 
      end
		end
    column :target do
			title "Паспортные Данные"
			type :String		
      mapping do
        at(2) 
      end
		end
    column :modified do
			title "Изменен"
			type :Date		
      mapping do
        at(3) 
      end
		end
	end
end

Model.recreate :ORMT_LoanTable do
  modules :ORMT_M_PersonTable
	type :Table
  parameters "person_id"
	constraint do
		populate_by do         
      ::User::ORMT_M_Loan.get_loans(@person_id).each_with_index do |data, i|
        #Note! call to data.person do single sql request to person table
        yield i, [data.record_id, data.person, data.bank, data.value, data.modified, data.description]
      end    
    end
	end
	ui_describe do
    column :bank do
			title 'Банк'
			type :String		
      mapping do
        at(2) 
      end
		end
    column :loan do
			title "Кредит(руб)"
			type :String		
      mapping do
        at(3) 
      end
		end
    column :date do
			title "Дата"
			type :Date		
      mapping do
        at(4) 
      end
		end
    column :description do
			title "Описание"
			type :Date		
      mapping do
        at(5) 
      end
		end
	end
  synchronization do
	  to :ORMT_PersonTable
	  action_on_change do 
      set_parameter 'person_id', obj[0]
      populate 
	  end
	end
end

JRScene.recreate :Panel, :ORMT_LoanScene do
	layout :Border
	size 900, 600
  
  add :Panel do
    layout :Mig
    border :Empty do
      width 4, 4, 4, 4
    end
    
    add :Panel, "north" do
      layout :Mig, "ins 10"
      
      add :Label, "north" do
        text "Клиенты:"
      end
      
      add :Table, "hmin 200, hmax 300, dock center" do
        scrolling :vertical => true, :horizontal => false
        model :ORMT_PersonTable
      end
    end
    
    add :Panel, "dock center" do
      layout :Mig, "ins 10"
      
      add :Label, "north" do
        text "Кредиты:"
      end
      
      add :Table, "hmin 400, hmax 600,  dock center" do
        scrolling :vertical => true, :horizontal => false
        model :ORMT_LoanTable
      end
    end
  end
	
end