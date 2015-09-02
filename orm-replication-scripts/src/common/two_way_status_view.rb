Module.recreate :ORMT_M_ClusterStatusTable do
  methods do
    def handleNotification ntf
      self.populate
    end
  end
end

Model.recreate :ORMT_ClusterStatusTable do
  modules :ORMT_M_ClusterStatusTable
	type :Table
	constraint do
		populate_by do         
      ::User::ORMT_M_ClusterStatus.get_statuses.each_with_index do |data, i|
        yield i, data        
      end    
    end
	end
	ui_describe do
    column :source do
			title 'кластер источник'
			type :String		
      mapping do
        cluster = at(0) 
        if ::User::ORMT_ClusterStatusTest.this_cluster == cluster
          'Local:'+cluster
        else
          cluster
        end
      end
		end
    column :target do
			title "кластер приемник"
			type :String		
      mapping do
        cluster = at(1) 
        if ::User::ORMT_ClusterStatusTest.this_cluster == cluster
          'Local:'+cluster
        else
          cluster
        end        
      end
		end
		column :status do
			title "Статус"
      type :Intger		
      mapping do
        at(2)
      end
      editable %q{at(1) == ::User::ORMT_ClusterStatusTest.this_cluster and at(0) == ::User::ORMT_ClusterStatusTest.this_cluster}
			editor :Plain, :Integer do         
			  	map_to do									
							value = this.get_text
              ::User::ORMT_M_ClusterStatus.set_this_status value.to_i
              ::User::ORMT_ClusterStatusTest.get_trigger.trigger_updated = Time.now
			  	end
			end
		end
		column :updated do
			title "Дата синхронизации статуса"
			type :Date
      mapping do
        Time.from_sql at(3)
      end
		end
	end
  # TODO use trigger object!!!
  subscribe :propertyAccount   
	subscribe_filter :propertyAccount, %q{::User::ORMT_ClusterStatusTest.create_filter}
end