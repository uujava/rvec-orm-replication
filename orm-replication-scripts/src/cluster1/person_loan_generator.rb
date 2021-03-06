Dsl.run_file File.dirname(__FILE__)+"/../common/orm_test_utils.rb"
Dsl.run_file File.dirname(__FILE__)+"/../common/loan_transactions.rb"
Dsl.run_file File.dirname(__FILE__)+"/../common/person_loan.rb"

Module.recreate :ORMT_M_Loan_Generator do
  methods do
    def self.initialize
      java_import 'java.util.LinkedList'
    end
    
    def execute ctx      
      # create one additional person and add loans to 10 last persons
      # on_orm provides single transation
      tx_id = Time.new
      
      # single transaction for loan and persons
      ::User::ORMT_Utils.on_orm :ORMT_M_Person do |orm|
        # not optimal as it iterates over all persons!
        persons = LinkedList.new 
        
        ORMT_M_Person.each orm do |person|
          if persons.size < 9
            persons.add person 
          else
            persons.removeFirst
            persons.add person
          end
        end
                
        # add loans for last 9 persons
        persons.each do |person|
          person.modified = tx_id
          ORMT_M_Loan.add_loan orm, person, 'Bank', rand(100), 'Test loan ' + tx_id, tx_id
        end
        
        # add new one        
        person = ORMT_M_Person.add_person orm, tx_id
        ORMT_M_Loan.add_loan orm, person, 'Bank', rand(100), 'Test loan ' + tx_id, tx_id

      end
      # insert transaction record
      ::User::ORMT_Utils.on_orm :ORMT_M_Transactions do |orm|
        tx = orm.create_object :ORMT_K_Transactions
        tx.tx_id = tx_id
        tx.flag = 0 #new trasaction
        tx.type = ::User::ORMT_M_Transactions::LOAN
      end
    end
  end
end

::User::ORMT_Utils.create_class :ORMT_M_Loan_Generator

# run commons/loan_test.rb to install orm objects for test
Job.recreate :orm_repl_test, "test.loan_generator" do   
  description "Triger loan generation"
  user_class :ORMT_K_Loan_Generator
  trigger 'test.loan_trigger' do
    with_cron_schedule do
      cron_schedule "0 0/5 * * * ?"
    end
  end
end
