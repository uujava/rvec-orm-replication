#GENERATE ORM ONLY AFTER TOPOLOGY AND INCLUSTER REPLICATION CHECKED
# Person(name, description)
Module.recreate :ORMT_M_Person do   

  attribute :record_id do
    type :Integer
    allowed_class :long
    column "ID" do
      primary true
      type 'NUMERIC'
    end
  end
    
  attribute :name do
    type :Plain   
    allowed_class :string
    column 'NAME' do
      length 400
    end    
  end
  
  attribute :description do
    type :Plain   
    allowed_class :string
    column 'DESCR' do
      length 400
    end   
  end
 
  attribute :loan_ref do
    type :ReferenceArray
    allowed_class :ORMT_K_Loan
  end
  
  attribute :modified do
    type :Plain   
    allowed_class :date 
    column 'MODFD' do
      type 'TIMESTAMP'
    end
  end
  
end

# Loan(person:Person, bank, description, modified, value)
Module.recreate :ORMT_M_Loan do   

  attribute :record_id do
    type :Integer
    allowed_class :long
    column "ID" do
      primary true
      type 'NUMERIC'
    end
  end

  attribute :person do
    type :Reference
    allowed_class :ORMT_K_Person
    column 'PERSON_ID' do
      type 'NUMERIC'
    end
  end

  attribute :bank do
    type :Plain   
    allowed_class :string
    column 'BANK' do
      length 400
    end    
  end
  
  attribute :description do
    type :Plain   
    allowed_class :string
    column 'DESC' do
      length 400
    end   
  end

  attribute :modified do
    type :Plain   
    allowed_class :date 
    column 'MODFD' do
      type 'TIMESTAMP'
    end
  end

  attribute :value do
    type :Plain   
    allowed_class :int
    column 'VALUE' 
  end
  
end

Module.modify :ORMT_M_Person do   
  methods do 
    
    # read all persons
    def self.get_persons
      all_persons = []
      ::User::ORMT_Utils.on_orm :ORMT_M_Person do |orm|
        ::User::ORMT_Utils._records(orm, "", {}) do |row|
          all_persons << row
        end
      end
      all_persons
    end
    
    def self.add_person orm, name, description
      obj = nil
      obj = orm.create_object :ORMT_K_Person
      obj.name = name
      obj.description = description
      obj 
    end
    
    def self.each orm
      ::User::ORMT_Utils._records(orm, "", {}) do |row|
        yield row
      end
    end
  end
end

Module.modify :ORMT_M_Loan do   
  methods do 
    
    # read all persons
    def self.get_loans person_id
      person_loans = []
      ::User::ORMT_Utils.on_orm :ORMT_M_Person do |orm|
        ::User::ORMT_Utils._records(orm, "person.record_id = $person_id", { :person_id=> person_id}, :ORMT_K_Loan) do |row|
          person_loans << row
        end
      end
      person_loans
    end
    
    def self.add_loan orm, person, bank, value, descr, modified = Time.now     
      obj = orm.create_object :ORMT_K_Loan
      obj.bank = bank
      obj.value = value
      obj.description = descr
      obj.modified = modified
      obj.person = person
      obj 
    end
    
    def self.each orm, person_id
      ::User::ORMT_Utils._records(orm, "person.record_id = $person_id", { :person_id=> person_id}, :ORMT_K_Loan) do |row|
          yield row
      end
    end
  end
end

# register ORM stuff
::User::ORMT_Utils.module_eval do
   orm_classes = []
   orm_classes << create_class(:ORMT_M_Person)
   orm_classes << create_class(:ORMT_M_Loan)
   generate_orm 6, *orm_classes 
   create_indices :ORMT_M_Person, :ORMT_M_Loan, [['PERSON_ID'],['MODFD']]
end   

