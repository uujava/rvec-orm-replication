
Module.recreate :ORMT_Utils do   
  methods do
    
    def self._records(orm, orm_query, query_params, target_class = orm.bin_name.to_sym, &block)
      orm.execute do
        type target_class
        query orm_query
        query_params.each do |k,v|
          param k, v          
        end
        result &block
      end
    end
    
    def self._raw_records(orm, orm_query, query_params,target_class = orm.bin_name.to_sym, &block)
      orm.execute do
        type target_class 
        query orm_query
        query_params.each {|k,v| param k, v}          
        row_result &block
      end
    end
        
    def self.on_orm orm_module, &block
      orm = ::User::ORM.get orm_class(orm_module)
      orm_module = ::User.const_get orm_module.to_sym unless orm_module.class == ::Module
      begin        
        orm_module.module_exec orm, &block
        orm.commit_changes
      rescue Exception => ex
        puts "Unable process orm block #{ex} #{ex.backtrace}"
        orm.rollback_changes rescue nil
        raise ex
      ensure
        orm.done
      end
    end
    
    # соглашение: 
    # имя модуля - префикс ORMT_M_
    # имя класса == имя ORM - префикс ORMT_К_
    # имя таблицы - upcase имя модуля
    # индексы - массив массивов имен колонок
    def self.install orm_module, indices
      orm_class = create_class(orm_module)
      generate_orm orm_class
      create_indices orm_module, orm_module, indices if indices and !indices.empty?
    end

    def self.generate_orm *orm_classes 
      sleep 2
      cls_sym = orm_classes.map {|c| c.to_sym}
      puts "classes for binary: #{cls_sym}"
      msg = ::User::ORM.generate cls_sym[0].to_s do
        useclasses *cls_sym
        generate_db_schema do
          drop_tables true    
          fk_constraints true
        end
      end
      puts msg
           
      puts "wait binary #{cls_sym[0]} for module #{cls_sym} comitted"
      sleep 5

    end
    
    def self.create_class orm_module
      orm_module = orm_module.to_s      
      orm_class = orm_class(orm_module)
      puts "create class: #{orm_class} for module: #{orm_module}"
      UserClass.recreate  orm_class.to_sym do
        modules orm_module.to_sym
        table orm_module.upcase
      end
      orm_class
    end
    
    def self.orm_class orm_module
      orm_module = orm_module.name if orm_module.class == ::Module
      raise "Имя модуля не соответствует соглашению ORMT_M_: #{orm_module}" unless /ORMT_M_/.match orm_module
      orm_module.to_s.gsub /(.*?\:\:)?ORMT_M_(.*)/, 'ORMT_K_\2'
    end
    
    def self.create_indices base_module, orm_module, indices      
      
      puts "creating indices #{base_module}:#{orm_module} #{indices}"
      
      orm = ::User::ORM.get orm_class(base_module)
      begin
        indices.each_with_index do |columns, i|
          table = orm_module.upcase
          idx = table+'_IDX'  + i
          idx_query = "CREATE INDEX #{idx} ON #{table} (#{columns.join(', ')})"
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
        end
      ensure
        orm.done
      end
    end
  end
end
