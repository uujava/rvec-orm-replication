require "#{File.dirname(__FILE__)}/sortcuts.rb"
cfg = ARGV[0]
server = cfg[0]
cluster_num = cfg[1]
puts "set VAR_DIR=%CLUSTER#{cluster_num}_HOME%\\.netbeans-#{Shortcuts::MAPPING[server]}_cfg\\var\\log"
puts "set CFG_PATH=%CLUSTER#{cluster_num}_HOME%\\#{Shortcuts::MAPPING[server]}_cfg.rb"