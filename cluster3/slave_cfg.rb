{
	'server' => [
		{
			'port' => '2001',
			'ntf_port' => '20001',
			'ip' => '192.168.3.156',
			'role' => 'Slave',
			'cluster' => 'Cluster1'
		}
	],
	'database' => [
		{
			#'dburl' => 'jdbc:hsqldb:hsql://localhost/s1',
			'dburl' => 'jdbc:oracle:thin:@192.168.3.28:1521/rvec.programpark.ru',
			'user' => 'orm_s1',
			'password' => 'orm_s1'
		}
	],
	'load_source' => [
		{
			'type' => 'db',
			'source' => 'database',
			'repeat' => 10,
			'timeout' => 5
		}
	],
	'load_server' => [
		{
			'port' => '2000',
			'ntf_port' => '20000',
			'ip' => '192.168.3.163'
		}
	],
	'zookeeper' => [
		{
			'cluster' => 'ZooKeeper1',
			'user' => 'rvec',
			'password' => '123',
			'timeout' => '10000',
			'address' => '192.168.3.163:3001,192.168.3.163:3002,192.168.3.163:3003'
		}
	],
	'sequencer' => [
		{
			'server_num' => 2,
			'server_max' => 1000, 
			'range_num' => 2
		}
	]

}

