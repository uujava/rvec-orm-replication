{
	'server' => [
		{
			'port' => '4000',
			'ntf_port' => '40000',
			'ip' => '127.0.0.1',
			'role' => 'Client',
			'cluster' => 'Cluster1'
		}
	],	
	'load_source' => [
		{
			'type' => 'server',
			'source' => 'load_server',
			'repeat' => 10,
			'timeout' => 5
		}
	],
	'load_server' => [
		{
			'port' => '2000',
			'ntf_port' => '20000',
			'ip' => '127.0.0.1'
		},
		{
			'port' => '2001',
			'ntf_port' => '20001',
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
	]
}

