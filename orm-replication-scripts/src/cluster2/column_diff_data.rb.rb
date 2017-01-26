Dsl.run_file File.dirname(__FILE__)+"/../common/orm_test_utils.rb"

# Тест поддержки sql template с разными именами колонок

# для проверки референсных атрибутов
Module.recreate :ORMT_M_ColumnDiffRef do
  # общие колонки
  attribute :id do
    allowed_class :long
    column 'ID' do
      primary true
    end
  end    
end
# Тестовый модуль cluster2 c дополнительными колонками
Module.recreate :ORMT_M_ColumnDiff do
  # общие колонки
  attribute :id do
    allowed_class :long
    column 'ID' do
      primary true
    end
  end  
  
  attribute :col_date do
    allowed_class :date
    column 'COL_DATE' 
  end
  
  attribute :col_text do
    allowed_class :string
    column 'COL_TEXT' do
      length 200
    end
  end
  
  # колонка для cluster1
  attribute :diff_ref do
    type :Reference
    column 'DIFF_REF'
    allowed_class :ORMT_K_ColumnDiffRef
  end
 
  attribute :diff_ref_id do
    type :Integer
    allowed_class :long
    column 'DIFF_REF' do
    end
  end
  
  # колонка только для cluster2
  attribute :sync_time do
    allowed_class :date
    column 'SYNC_TIME' do
      length 200
    end
  end  
end

Module.modify :ORMT_M_ColumnDiffRef do
  methods do        
    def self.print_diff 
      ::User::ORMT_Utils.on_orm :ORMT_M_ColumnDiffRef do |orm|
        orm.execute do
          type :ORMT_K_ColumnDiffRef
          result do |item|
            puts item
          end
        end
      end
      ::User::ORMT_Utils.on_orm :ORMT_M_ColumnDiffRef do |orm|
        orm.execute do
          type :ORMT_K_ColumnDiff
          result do |item|
            puts item
          end
        end
      end
    end
  end
end


# register ORM stuff
::User::ORMT_Utils.module_eval do
   orm_classes = []
   orm_classes << create_class(:ORMT_M_ColumnDiffRef)
   orm_classes << create_class(:ORMT_M_ColumnDiff)
   generate_orm *orm_classes 
   create_indices :ORMT_M_ColumnDiffRef, :ORMT_M_ColumnDiff, [['ID'],['ID']]
end   