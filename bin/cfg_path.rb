require "#{File.dirname(__FILE__)}/shortcuts"
cfg = ARGV[0]
server = cfg[0]
cluster_num = cfg[1]
puts "set VAR_DIR=%CLUSTER#{cluster_num}_HOME%\\.netbeans-#{Shortcuts::MAPPING[server]}_cfg\\var\\log"
puts "set CFG_PATH=%CLUSTER#{cluster_num}_HOME%\\#{Shortcuts::MAPPING[server]}_cfg.rb"
puts "set DEBUG_PORT=50#{cluster_num}#{Shortcuts.client_number(server)}"
puts "set RVEC_HOME=%RVEC_HOME#{cluster_num}%"
