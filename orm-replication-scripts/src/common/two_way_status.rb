#GENERATE ORM ONLY AFTER TOPOLOGY AND INCLUSTER REPLICATION CHECKED
Module.recreate :ORMT_M_ClusterStatus do   

  attribute :record_id do
    type :Integer
    allowed_class :long
    column "ID" do
      primary true
    end
  end
  
  attribute :source do
    type :Plain
    column 'SOURCE' do
      length 400     
    end
    allowed_class :string
  end

  attribute :target do
    type :Plain   
    allowed_class :string
    column 'TARGET' do
      length 400
    end    
  end
  
  attribute :status do
    type :Integer   
    allowed_class :int
    column 'STATUS'
  end
  
  attribute :updated do
    type :Time   
    allowed_class :date
    column 'UPDATED' do
      type 'TIMESTAMP'
    end
  end  

end
# utility methods
Module.modify :ORMT_M_ClusterStatus do
  methods do
    def self.initialize
      const_set :RUNNING, 1
      const_set :UPDATING, 2
      const_set :ERROR, 4
    end
    
    def self.register
      self_cluster = ::User::ORMT_ClusterStatusTest.this_cluster
      ::User::ORMT_Utils.on_orm self do |orm|
        set_status orm, self_cluster, self_cluster, RUNNING
      end
    end
    
    def self.set_this_status value
      self_cluster = ::User::ORMT_ClusterStatusTest.this_cluster
      ::User::ORMT_Utils.on_orm self do |orm|
        set_status orm, self_cluster, self_cluster, value
      end
    end
    
    
    # performance issue: at least two db query per call (select/update)
    # not a problem for given application
    # for bulk operations separate methods must be implemented
    def self.set_status orm, source, target, status
      query = "source = $source and target = $target"
      params = {
        :source  => source,
        :target  => target       
      } 
      update = false
      ::User::ORMT_Utils._records(orm, query, params) { |row| 
        update = true
        row.status = status
        row.updated = Time.now
      } 
      
      unless update
        record = orm.create_object ::User::ORMT_Utils.orm_class self
        record.source = source
        record.target = target
        record.status = status
        record.updated = Time.now
      end
    end    
   
    def self.get_statuses
      query = ""
      result = []
      ::User::ORMT_Utils.on_orm self do |orm|
        ::User::ORMT_Utils._records(orm, query, {}) { |row| 
          result << [row.source, row.target, row.status, row.updated]
        } 
        return result
      end
    end    
  end
end

#first time setup constants 
::User::ORMT_M_ClusterStatus.initialize
# register ORM stuff
::User::ORMT_Utils.install :ORMT_M_ClusterStatus, [%w{SOURCE TARGET}]
::User::ORMT_M_ClusterStatus.register

