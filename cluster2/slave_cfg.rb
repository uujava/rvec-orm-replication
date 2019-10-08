require NBStarter.config_dir+"/../cluster-common/dburls"
dbkey = ENV['DB_ALIAS'] || 'hsql'
dburl = DBURLS[:s2][dbkey.downcase.to_sym]
{
	'server' => [
		{
			'port' => '2011',
			'ntf_port' => '20011',
			'ip' => '127.0.0.1',
			'role' => 'Slave',
			'cluster' => 'Cluster2'
		}
	],
	'database' => [
		{
			'dburl' => dburl,
			'user' => 'S2',
			'password' => 'S2'
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
			'port' => '2010',
			'ntf_port' => '20010',
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
			'server_num' => 4, # Номер сервера
			'server_max' => 1000, # Максимальное количество серверов
			'range_num' => 1, # Номер начального диапазона
		}
	]

}

