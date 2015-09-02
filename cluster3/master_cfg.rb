{
	'server' => [
		{
			'port' => '2020',
			'ntf_port' => '20020',
			'ip' => '127.0.0.1',
			'role' => 'Master',
			'cluster' => 'Cluster3'
		}
	],
	'database' => [
		{
			'dburl' => 'jdbc:hsqldb:hsql://localhost/m3',
			'user' => 'M3',
			'password' => 'M3'
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
			'port' => '2021',
			'ntf_port' => '20021',
			'ip' => '127.0.0.1'
		}
	],
	'zookeeper' => [
		{
			'cluster' => 'ZooKeeper1',
			'user' => 'rvec',
			'password' => '123',
			'timeout' => '10000',
			'address' => '127.0.0.1:3001'
		}
	],
	'sequencer' => [
		{
			'server_num' => 5, # Номер сервера
			'server_max' => 1000, # Максимальное количество серверов
			'range_num' => 1, # Номер начального диапазона
		}
	]
}

