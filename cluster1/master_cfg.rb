﻿{
	'server' => [
		{
			'port' => '2000',
			'ntf_port' => '20000',
			'ip' => '127.0.0.1',
			'role' => 'Master',
			'cluster' => 'Cluster1'
		}
	],
	'database' => [
		{
			'dburl' => 'jdbc:hsqldb:hsql://localhost/m1',
			#'dburl' => 'jdbc:oracle:thin:@192.168.58.128:1521/ora11',
			'user' => 'M1',
			'password' => 'M1'
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
	],
	'sequencer' => [
		{
			'server_num' => 1,
			'server_max' => 100,
			'range_num' => 1
		}
	]
}

