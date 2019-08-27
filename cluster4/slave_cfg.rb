{
	'server' => [
		{
			'port' => '2031',
			'ntf_port' => '20031',
			'ip' => '127.0.0.1',
			'role' => 'Slave',
			'cluster' => 'Cluster4'
		}
	],
	'database' => [
		{
			'dburl' => 'jdbc:postgresql://192.168.3.232:5432/rvec_database',
			'user' => 'orm_prod',
			'password' => 'orm_prod'
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
			'port' => '2030',
			'ntf_port' => '20030',
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
			'server_num' => 8, # Номер сервера
			'server_max' => 1000, # Максимальное количество серверов
			'range_num' => 1, # Номер начального диапазона
		}
	]

}

