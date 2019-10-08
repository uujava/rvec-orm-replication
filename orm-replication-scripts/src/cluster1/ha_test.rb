module ::LoadTest
  MAX_THREADS = 50

  MAX_RECORDS = 100*1000
  @@CLEANUP_DELAY = 20

  PRIME_NUMBERS = [
    [7,13],
    [5,199],
    [13, 149],
    [15, 7],
    [10, 100],
    [20, 1300],
  ]  

  
  @@threads = []
  @@stopped = false
  
  def self.stopped
    @@stopped
  end
  
  def self.safe_run     
    yield
  rescue Exception => ex
    error "error detected #{ex}"
    @@stopped = true
  end
  
  def self.start_cleanup
    cleanup_thread = Thread.new do   
      thread_name "TestCleanup #{time_to_stop}"
      debug "started cleanup thread"
      while !stopped && (@@MAX_TIME - System.nanoTime) > 0    
        safe_run do
          sleep @@CLEANUP_DELAY
          debug "start clean #{ORMT_M_HaTest.check}"
          ORMT_M_HaTest.clean MAX_RECORDS
          debug "cleaned #{ORMT_M_HaTest.check}"
        end
      end
      debug "finished cleanup thread"          
    end
    debug "cleanup thread added #{cleanup_thread}"
    @@threads << cleanup_thread
  end

  def self.start_load time_to_run, sleep = 0.002
    @@TIME_TO_RUN = time_to_run
    @@CLEANUP_DELAY =  [5, @@TIME_TO_RUN/60].max
    wait_stop
    @@stopped = false
    next_runtime
    debug "Test time #{@@TIME_TO_RUN} sec"
    ORMT_M_HaTest.clean
    MAX_THREADS.times do |i|      
      load_thread = Thread.new(i) do |num|
        thread_name "OrmTestLoader #{num} #{time_to_stop}"
        nums = PRIME_NUMBERS[num%PRIME_NUMBERS.size]
        debug "started OrmTestLoader #{num} thread nums: #{nums}"
        while !stopped && @@MAX_TIME - System.nanoTime > 0
          safe_run do
            ORMT_M_HaTest.generate nums[0], nums[1]
            sleep sleep
          end
        end
        debug "finished #{num}"
      end
      debug "starting #{i} load thread #{load_thread} #{load_thread.name}"
      @@threads << load_thread
    end
  end

  def self.wait_stop
    debug "wait threads: #{@@threads.size}"
    @@threads.each do |t|
      debug "join #{t} ThreadName: #{t.name}"
      t.join
    end
    @@threads.clear
    @@stopped = true
    debug "all completed #{ORMT_M_HaTest.check}"
  end

  def self.log level, msg
    puts "[#{level}] [#{java.lang.Thread.currentThread.name}] [#{Time.now}] -- #{msg}"
  end
  
  def self.debug msg
    log "DEBUG", msg
  end

  def self.error msg
    log "ERROR", msg
  end
  
  def self.info msg
    log "INFO", msg
  end
  
  def self.thread_name name
    java.lang.Thread.currentThread.setName(name)
  end
  
  def self.next_runtime
    @@MAX_TIME = System.nanoTime + @@TIME_TO_RUN*1000*1000*1000
    @@STOP_TIME = Time.now + (@@MAX_TIME - System.nanoTime)/1e9
    debug "stop time: #{@@STOP_TIME}"
  end
  
  def self.time_to_stop
    @@STOP_TIME
  end
    
  def self.validate
    cluster = $control.this_node.cluster
    debug "cluster '#{cluster}'"
    debug  "load server #{current_server}"
    debug  "orm mode: #{ORM.is_queue_mode}"
    
    servers = ReserveCluster.get(cluster).nodes
    row_count = {}
    servers.each do |s|
      server = ApplicationServer.get(s)
      debug "server: '#{server.name}'=>#{server}"
      ds = Database.get server.data_source
      debug "datasource: '#{ds.name}'=>#{ds}"
      dblib = DbLib.new 
      dblib.dburl = "#{ds.protocol}#{Host.get(ds.host).ip}:#{ds.port}/#{ds.resource}"
      dblib.user = ds.user
      dblib.password= ds.password
      begin
        row_count[server.name] = {
          "parent" => dblib.select('SELECT count(1) FROM "ORMT_M_HATEST"'),
          "child" => dblib.select('SELECT count(1) FROM "ORMT_M_HATESTROW"'),
          "orm_queue" => dblib.select('SELECT count(1) FROM ORM_QUEUE')
        }
      ensure
        dblib.close
      end
    end
    debug "validate found records: #{row_count}"    
    invalid = []
    row_count.to_a.combination(2).each do |pair| 
      if pair[0][1] != pair[1][1]
        invalid << pair
      end
    end
    if !invalid.empty?
      error "Invalid state: #{invalid}"
    else
      info "State is OK"
    end
    return invalid
  end
  
  def self.queue_mode
    pair = ::LoadTest.pair_server
    @@threads << Thread.new do
      thread_name "SwitchToQueueMode #{pair}"
      sleep @@TIME_TO_RUN/2
      ::User::ORM.force_queue_mode
      debug "switched to queue mode"
      safe_run { kill_server pid(pair).first }
    end

    @@threads << Thread.new do
      thread_name "Start  #{pair}"
      sleep @@TIME_TO_RUN/2 + @@TIME_TO_RUN/5
      safe_run { start_server pair }
      while !stopped && pid(pair).empty?
        sleep 30
        debug "pair server: #{pair} not yet started"
      end
      debug "started pair: #{pair}"
    end

  end
  
  def self.pid name  
    `jps -mlVv`.each_line.select do |line|
      line.match /#{name}_cfg.rb/
    end.map { |line| line.gsub /(^\d+).*\n/, '\1'}
  end

  def self.pair_server name = current_server 
    cluster = $control.this_node.cluster
    servers = ReserveCluster.get(cluster).nodes
    (servers -[name]).first    
  end
  
  def self.current_server
    if $control.load_server 
      $control.load_server.this_node.name
    else 
      $control.this_node.name
    end
  end
  
  def self.kill_server pid
    debug  "kill pid #{pid}"
    debug `kill -f -9 #{pid}`
  end
  
  def self.start_server name
    names = {
      "master" => "m1",
      "slave" => "s1"     
    }
    base_dir = File.expand_path(RunArguments.instance[:work_dir]).gsub /cluster\d+\/.*?_cfg.rb$/, ''
    pid = ::Process.spawn "cmd /c \"#{base_dir}bin/start_rvec_node.bat #{names[name]}\""
    puts "node started #{pid}"
    puts  "detach #{::Process.detach pid}"    
  end
  
end

puts "current server #{::LoadTest.current_server}:#{::LoadTest.pid ::LoadTest.current_server}"
puts "pair server #{::LoadTest.pair_server}:#{::LoadTest.pid ::LoadTest.pair_server}" 

::LoadTest.thread_name "MainTest"
::LoadTest.validate
::LoadTest.start_load 450, 0.025
::LoadTest.start_cleanup

# tests should include:
# queue_mode
# wait
# restart slave
# wait
# restart load server

#::LoadTest.queue_mode

::LoadTest.wait_stop
::LoadTest.validate

