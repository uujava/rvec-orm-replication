# add reference from channel to some data object
Module.recreate :ORMT_M_Channel do
  attribute :data_object do
    type :Reference
  end
end

UserClass.modify ::OrmReplication::CHANNEL_CLASS do
  add_modules :ORMT_M_Channel
end rescue nil
