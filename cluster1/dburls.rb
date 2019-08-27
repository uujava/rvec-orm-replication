DBURLS = {
 :m1 => {
    :vm => 'jdbc:oracle:thin:@192.168.17.128:1521/ora11',
    :hsql  => 'jdbc:hsqldb:hsql://localhost:9001/m1',
    :oraclee => 'jdbc:oracle:thin:@192.168.3.24:1521/orclee.programpark.ru',
    :pgsql => 'jdbc:postgresql://192.168.3.231:5432/repl_database',
	:db01 => 'jdbc:oracle:thin:@192.168.3.4:1521:db01',
	:orcl => 'jdbc:oracle:thin:@127.0.0.1:1521/orcl',	
  },
  :s1 => {
    :vm => 'jdbc:oracle:thin:@192.168.17.128:1521/ora11',
    :hsql => 'jdbc:hsqldb:hsql://localhost:9001/s1',
    :oraclee => 'jdbc:oracle:thin:@192.168.3.24:1521/orclee.programpark.ru',
    :pgsql => 'jdbc:postgresql://192.168.3.232:5432/repl_database',
	:db01 => 'jdbc:oracle:thin:@192.168.3.4:1521:db01',
	:orcl => 'jdbc:oracle:thin:@127.0.0.1:1521/orcl',	
  }
}
def parse_url dburl
  (protocol, host) =  dburl.split "//"
  if(host.nil?)
    (protocol, host) =  dburl.split "@"
    protocol +=  "@"
  else
    protocol += "//"  
  end
  
  (ip, port, resource) = host.split ":"
  
  rise "wrong url $dburl" if port.nil? 

  puts "parsed protocol: #{protocol}"  
  puts "parsed ip: #{ip}"
  puts "parsed at port stage: #{resource}"
  
  unless resource
	(port, resource) = port.split "/"  
	rise "wrong url $dburl" if resource.nil? 
	separator = '/'
  else 
	separator = ':'
  end
  
  puts "parsed port: #{port}"
  puts "parsed resource: #{resource}"
  
  [protocol, ip, port, resource, separator]
end