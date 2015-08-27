{
	'server' => [
		{
			'port' => '2001',
			'ntf_port' => '20001',
			'ip' => '127.0.0.1',
			'role' => 'Slave',
			'cluster' => 'Cluster1'
		}
	],
	'database' => [
		{
			'dburl' => 'jdbc:hsqldb:hsql://localhost/s1',
			#'dburl' => 'jdbc:oracle:thin:@192.168.58.128:1521/ora11',
			'user' => 'S1',
			'password' => 'S1'
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
			'ip' => '127.0.0.1'
		}
	],
	'zookeeper' => [
		{
			'cluster' => 'ZooKeeper1',
			'user' => 'rvec',
			'password' => '123',
			'timeout' => '10000',
			#'address' => '127.0.0.1:3001,127.0.0.1:3002,127.0.0.1:3003'
			'address' => '127.0.0.1:3001'
		}
	],
	'sequencer' => [
		{
			'server_num' => 2,
			'server_max' => 100,
			'range_num' => 1
		}
	]

}

