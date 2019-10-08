# To change this template, choose Tools | Templates
# and open the template in the editor.

#$orm ||=ORM.get("ORMT_K_HaTest")

$orm = nil

$counter ||= java::util::concurrent::atomic::AtomicLong.new

def do_insert(num = 1)
  orm = $orm || ORM.get("ORMT_K_HaTest")
  num.times do |i|
    obj = orm.create_object :ORMT_K_HaTest, $control.get_data_provider.get_next_uobj_id
    obj.node = "node#{i}"
    $counter.incrementAndGet
  end
  orm.commit_changes  
rescue Exception => ex
  puts "exception: #{ex}"  
  orm.rollback_changes
ensure
  orm.done unless $orm  
end

num_threads = 2000
num_inserts = 2

#::User::ORM.force_queue_mode
start_time = java.lang.System.nanoTime
1.times do
  threads = []

  num_threads.times do |i|
    threads << Thread.new do
      java.lang.Thread.currentThread.name = "th#{i}"
      do_insert num_inserts
    end
  end
  
  Thread.new do
    lastCounter = $counter.get
    puts "threads #{threads.size}"
    while threads.size > 0      
      if ($counter.get - lastCounter) > 0
        newCounter = $counter.get
        puts "counter: #{newCounter - lastCounter}"
        lastCounter= newCounter
      end  
      sleep 10
    end
  end
  
  _lastCounter = $counter.get
  threads.each do |t|
    t.join  
    _newCounter = $counter.get    
    puts "#{(java.lang.System.nanoTime - start_time)/1e6} done : #{t.name} counter: #{_newCounter - _lastCounter}"      
    _lastCounter= _newCounter
  end
  threads.clear
end

