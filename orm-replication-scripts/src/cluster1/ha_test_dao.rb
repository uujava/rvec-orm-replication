Dsl.run_file File.dirname(__FILE__)+"/../common/orm_test_utils.rb"

# Тест поддержки HA для ORM

Module.recreate :ORMT_M_HaTest do
  # общие колонки
  attribute :id do
    allowed_class :long
    column 'ID' do
      primary true
    end
  end 
  attribute :node do
    allowed_class :string
    column 'NODE' do
      length 30
    end
  end
end

Module.recreate :ORMT_M_HaTestRow do
  # общие колонки
  attribute :id do
    allowed_class :long
    column 'ID' do
      primary true
    end
  end  
  
  attribute :parent do
    type :Reference
    column 'PARENT' 
    allowed_class :ORMT_K_HaTest
  end
 
  attribute :parent_id do
    allowed_class :long
    column 'PARENT' do
    end
  end
end

Module.modify :ORMT_M_HaTest do
  methods do
    def self.clean idGap = 0, nodeName = $control.this_node.name         
      isOracle = true
      maxId = $control.get_data_provider.get_next_uobj_id - idGap
      puts "clean test data for #{nodeName} idGap: #{idGap}"
      if isOracle
        puts "clean rows on oracle"
        ::User::ORMT_Utils.on_orm :ORMT_M_HaTest do |orm|
          orm.execute do
            param :nodeName, nodeName
            param :maxId, maxId
            query 'DELETE FROM "ORMT_M_HATESTROW" R WHERE R."PARENT" IN (SELECT "ID" FROM "ORMT_M_HATEST" T WHERE T."NODE"=#bind($nodeName)) and R."ID" < #bind($maxId)'
            row_result do |item|
              puts "deleted #{item}"
            end
          end
        end
      end
      # cascade on hsql!!!
      ::User::ORMT_Utils.on_orm :ORMT_M_HaTest do |orm|
        orm.execute do
          param :nodeName, nodeName
          param :maxId, maxId
          query 'DELETE FROM "ORMT_M_HATEST" WHERE "NODE" = #bind($nodeName) and "ID" < #bind($maxId)'          
          row_result do |item|
            puts "deleted #{item}"
          end
        end
      end
    end      
    
    def self.generate cols = 3, rows = 7
      node = $control.this_node.name
      ::User::ORMT_Utils.on_orm :ORMT_M_HaTest do |orm|
        cols.times do |c|
          p = orm.create_object :ORMT_K_HaTest, next_id 
          p.node = node
          rows.times do |i|
            row = orm.create_object :ORMT_K_HaTestRow, next_id 
            row.parent = p
          end
        end
        orm.commit_changes
      end
    end    
    
    def self.next_id
      id = $control.get_data_provider.get_next_uobj_id 
      #avoid null when load_server shutdown
      if id
        id
      else
        sleep 1
        next_id
      end
    end
    
    def self.check
      data = {}
      ::User::ORMT_Utils.on_orm :ORMT_M_HaTest do |orm|
        orm.execute do
          query 'select T."NODE" as "NODE", count(*) as "CNT" FROM "ORMT_M_HATEST" T LEFT JOIN "ORMT_M_HATESTROW" R ON T."ID"=R."PARENT" GROUP BY T."NODE"'
          row_result do |item|
            data[item['NODE']] = item['CNT']
          end
        end
      end   
      return data
    end
  end
end  
# register ORM stuff
::User::ORMT_Utils.module_eval do
  orm_classes = []
  orm_classes << create_class(:ORMT_M_HaTest)
  orm_classes << create_class(:ORMT_M_HaTestRow)
  generate_orm *orm_classes
  create_indices :ORMT_M_HaTest,:ORMT_M_HaTest, [['NODE']]
  #  create_indices :ORMT_M_HaTest,:ORMT_M_HaTestRow, [['PARENT']] 
end   