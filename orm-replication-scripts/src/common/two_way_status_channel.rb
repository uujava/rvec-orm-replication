Module.recreate :ORMT_ClusterStatusTest do
  methods do
    def self.initialize
      const_set :CHANNEL_PREFIX, "ORMT_ChannelStatus_"
    end
    
    def self.install
      initialize
      create_trigger
      create_channels      
    end
    
    def self.this_cluster
      $control.this_node.cluster
    end

    def self.create_channels
      _this_cluster = this_cluster
      channels = {}
      # создаем по каналу на каждый кластер в топологии, кроме своего
      ReserveCluster.each do |cluster|
        next if cluster ==  _this_cluster
        channel_name = CHANNEL_PREFIX + cluster
        channels[channel_name] = lambda do |channel|
          channel.cluster = cluster
          channel.orm_name = :ORMT_K_ClusterStatus.to_s
          channel.orm_class = :ORMT_K_ClusterStatus
          channel.merger = :ORMT_K_ClusterStatusMerger
          # читаем только те данные, которые генерит соответствующий кластер
          channel.query = "target = $target_cluster"
          channel.scheduler = "0/20 * * ? * *" 
          channel.activate = true  
        end
      end

      ::OrmReplication.bulk_upsert channels
      
    end
    
    def self.create_trigger
      unless(::User.const_get :ORMT_M_ClusterStatusTrigger rescue false)
        ::User::Module.recreate :ORMT_M_ClusterStatusTrigger do
          attribute :trigger_updated do
            type :Plain
          end
        end
      end

      unless(::User.const_get :ORMT_K_ClusterStatusTrigger  rescue false)
        ::User::UserClass.recreate :ORMT_K_ClusterStatusTrigger do
          modules :ORMT_M_ClusterStatusTrigger
        end
      end

      storage = ::User::Storage.get 'ClusterStatusTriggers'
      unless storage
        storage = ::User::Storage.create 'ClusterStatusTriggers' do
    
        end
      end
      if storage.objects.size == 0
        ::User::UserObject.create do
          is :ORMT_K_ClusterStatusTrigger
          into 'ClusterStatusTriggers'
        end
      end
      $log.debug "trigger for cluster status channel: #{get_trigger}"
    end
   
    def self.get_trigger
      ::User::Storage.each_object 'ClusterStatusTriggers' do |_, obj| 
        return obj        
      end
    end
    
    def self.create_filter
      AndComplexFilter.new ObjIdFilter.new(get_trigger.obj_id), PropertyFilter.new(:trigger_updated)
    end
  end
end


Module.recreate :ORMT_M_ClusterStatusMerger do
end

Module.modify :ORMT_M_ClusterStatusMerger do
  methods do
        
    def get_blocks channel_id
      $log.debug "get_blocks: #{channel_id}"
      @this_cluster = ::User::ORMT_ClusterStatusTest.this_cluster
      @updated = []
      @has_data = false
      channel = ::User::UserObject.get channel_id
      $log.debug "get_blocks: #{channel} updated:#{@updated} this_cluster=#{@this_cluster}"
      target = channel.name.gsub ::User::ORMT_ClusterStatusTest::CHANNEL_PREFIX, ''
      $log.debug "target cluster: #{target}"
      [OrmReplication.create_block({:target_cluster => target})]      
    end          
    
    def start(block)
      $log.debug "start #{block} updated:#{@updated}"
    end
 
    def get_key(record)
      key = "#{record.source}-#{record.target}"
      $log.debug "key: #{key}"
      key
    end
 
    def inserted(new_record)
      $log.debug "inserted #{new_record}  updated:#{@updated}"
      @has_data = true
      true
    end
 
    def updated(old_record, new_record)      
      # обновляем только записи не относящиеся к нашему кластеру
      updated = Time.from_sql(new_record.updated) > Time.from_sql(old_record.updated) and new_record.target != @this_cluster
      $log.debug "updated: #{updated} old: #{old_record} new: #{new_record} updated:#{@updated}"
      if updated
        @has_data = true
        old_record.status = new_record.status
        old_record.updated = new_record.updated
        # собираем изменения сгенерированные кластером источником
        if old_record.source == old_record.target
          $log.debug "cluster status change detected #{old_record}"
          @updated << [old_record.source, new_record.status]
        end
      end
      updated
    end
 
    def deleted(old_record)
      $log.debug "deleted: #{old_record} updated:#{@updated}"
      false
    end
 
    def stop error_status      
      $log.debug "stop: #{error_status} updated:#{@updated}"
    end
 
    def finish error_status
      $log.debug "finish: #{error_status} updated:#{@updated} this_cluster: #{@this_cluster}"
      _this_cluster = @this_cluster
      unless error_status
        # для кластер изменяем статус на прочитанный
        @updated.each do |cluster_status| 
          ::User::ORMT_Utils.on_orm ::User::ORMT_M_ClusterStatus do |orm|
            ::User::ORMT_M_ClusterStatus.set_status orm, cluster_status[0], _this_cluster, cluster_status[1]
          end
        end
        if @has_data
          ::User::ORMT_ClusterStatusTest.get_trigger.trigger_updated = Time.new
        end
      end
    end
  end
end

UserClass.recreate :ORMT_K_ClusterStatusMerger do  
  modules :ORMT_M_ClusterStatusMerger, :OrmReplicationMerger
end

ORMT_ClusterStatusTest.install