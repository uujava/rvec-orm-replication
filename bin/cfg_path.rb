cfg = ARGV[0]
MAPPING = {'m' => 'master', 's' => 'slave'}
server = cfg[0]
cluster_num = cfg[1]
puts "set VAR_DIR=%CLUSTER#{cluster_num}_HOME%\\.netbeans-#{MAPPING[server]}_cfg\\var\\log"
puts "set CFG_PATH=%CLUSTER#{cluster_num}_HOME%\\#{MAPPING[server]}_cfg.rb"