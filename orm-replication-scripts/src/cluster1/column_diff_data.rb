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
# Тестовый модуль для cluster1
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
  attribute :col_text1 do
    allowed_class :string
    column 'COL_TEXT1' do
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
end

Module.modify :ORMT_M_ColumnDiffRef do
  methods do
    def self.create_ref orm, id      
      if id != 0
        # исключаем ref для 0, чтобы протестировать корректность репликации нулевой ссылки
        record = orm.create_object :ORMT_K_ColumnDiffRef, id
        puts "created #{record.id} #{record}"
        return record
      end
    end 
    
    def self.update_ref ref
      puts "updated #{ref.id} #{ref}" if ref
    end
   
    def self.create_diff orm, id, ref      
      record = orm.create_object :ORMT_K_ColumnDiff, id
      record.col_date = Time.now
      record.col_text = "Text " + id
      record.col_text1 = "Cluster1 Text " + id
      record.diff_ref = ref
      puts "created #{record.id} #{record}"
    end 
    
    def self.update_diff diff
      diff.col_date = Time.now
      diff.col_text = "Updated " + diff.col_date
      diff.col_text1 = "Cluster1 Text " + diff.col_date
      puts "updated #{diff.id} #{diff}"
    end
   
    def self.change_diff count  
      diffs = {}
      reffs = {}    
      all_reffs = {}
      ::User::ORMT_Utils.on_orm :ORMT_M_ColumnDiffRef do |orm|
        orm.execute do
          type :ORMT_K_ColumnDiffRef
          result do |item|
            reffs[item.id] = item
            all_reffs[item.id] = item
          end
        end
        count.times do |i|
          if reffs[i]
            update_ref(diffs[i])
          else
            all_reffs[i] = create_ref(orm, i)
          end
          reffs.delete(i)
        end
      
        reffs.each do |k, v| 
          orm.delete_object v 
          puts "deleted #{k} #{v}"
        end

        orm.commit_changes
      end      
      
      ::User::ORMT_Utils.on_orm :ORMT_M_ColumnDiffRef do |orm|
        orm.execute do
          type :ORMT_K_ColumnDiff
          result do |item|
            diffs[item.id] = item
          end
        end
        count.times do |i|
          if diffs[i]
            update_diff(diffs[i])
          else
            create_diff(orm, i, all_reffs[i])
          end
          diffs.delete(i)
        end
      
        diffs.each do |k, v| 
          orm.delete_object v 
          puts "deleted #{k} #{v}"
        end

        orm.commit_changes
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