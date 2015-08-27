{
	'plugin' => [
		{
			'name' => 'Updater',
			'description' => 'Тест изменения атрибута объекта',
			'path' => '/test/updater_plugin.rb',
			'class' => 'UpdaterPlugin',
			'param' => '777'
		},
		{
			'name' => 'schedule_chart',
			'description' => 'График движения версия 2.0',
			'path' => 'schedule/chart/basic/schedule_chart_plugin.rb',
			'class' => 'ГД_Плагин',
		},
		{
			'name' => 'MAP Moscow Spb',
			'description' => 'Модуль мультиагентного планирования Москва - Санкт-Петербург',
			'path' => 'map_moscow_spb/map_moscow_spb_plugin.rb',
			'class' => 'MAPMoscowSpb::Plugin',
			'jar' => 'ext/com.kg/kg-rails-scheduler.jar',
		},
		{
			'name' => 'Poller',
			'description' => 'Poller plugin',
			'path' => 'poller/poller_plugin.rb',
			'class' => 'PollerPlugin',
		},
		{
			'name' => 'Quartz',
			'description' => 'Quartz wrapper plugin',
			'path' => 'quartz/quartz_plugin.rb',
			'class' => 'QuartzPlugin',
		},
		{
			'name' => 'OPCDriverPlugin',
			'description' => 'OPCDriver-covered by Plug-in',
			'path' => 'drivers/opc_driver_plugin.rb',
			'class' => 'OpcDriverPlugin',
		},
		{
			'name' => 'test_plugin',
			'description' => 'terstovy plugin',
			'path' => 'test/test_plugin.rb',
			'class' => 'TestPlugin',
			'param' => '777'
		},
		{
			'name' => 'VP2X2',
			'description' => 'Видео плейер 2х2',
			'path' => 'video/video_2x2_plugin.rb',
			'class' => 'VideoPlayer2x2Plugin',
		},
		{
			'name' => 'VPVLC',
			'description' => 'Видео плейер VLC',
			'path' => 'video/video_vlc_plugin.rb',
			'class' => 'VideoPlayerVlcPlugin',
		},
		{
			'name' => 'MAP Vostok',
			'description' => 'Модуль мультиагентного объемного планировщика Восточного полигона',
			'path' => '/map_vostok/map_vostok_plugin.rb',
			'class' => 'MAPVostok::Plugin',
			'jar' => 'ext/com.kg/kg-rails-east.jar',
		},
		{
			'name' => 'heartbeat',
			'description' => 'heartbeat plugin',
			'path' => 'sync/heartbeat.rb',
			'class' => 'HeartbeatPlugin'
		},
		{
			'name' => 'BookKeeper',
			'description' => 'Модуль распределенного логирования',
			'path' => 'bookkeeper/bk_plugin.rb',
			'class' => 'BookKeeper::Plugin',
		},
		{
			'name' => 'Jason',
			'description' => 'Jason plugin',
			'path' => 'jason/jason_plugin.rb',
			'class' => 'JasonPlugin'
			#"jar" => "train_planner.jar"
		},
		{
			'name' => 'ActivityMonitor',
			'description' => 'Плагин для мониторинга активности',
			'path' => 'activity/activity_plugin.rb',
			'class' => 'ActivityMonitor::Plugin'
		},
		{
			'name' => 'HttpServer',
			'description' => 'embedded http server',
			'path' => 'jetty/rvec_plugin.rb',
			'class' => '::JettyHttpServer::Plugin'
		},
		{
			'name' => 'DriverPlugin',
			'description' => 'Plugin for any Driver',
			'path' => 'drivers/driver_plugin.rb',
			'class' => 'DriverPlugin'
		},
		{
			'name' => 'ClusteredPlugin',
			'description' => 'Кластер из 2-х экземпляров плагина',
			'path' => 'test/clustered_plugin.rb',
			'class' => 'ClusteredPlugin'
		},
		#{
		#					'name' => 'WaitingReservePlugin',
		#	 'description' => 'Мониторинг узла планировщика',
		#					'path' => 'definitions/waiting_reserve_plugin.rb',
		#				 'class' => 'WaitingReservePlugin',
		#},
		{
			'name' => 'GPUControllerPlugin',
			'description' => 'Контроллер ГПУ',
			'path' => 'definitions/gpu_controller_plugin.rb',
			'class' => 'GPUControllerPlugin',
		},
		{
				'name' => 'ReplicationORMPlugin',
				'description' => 'Плагин ORM репликации',
				'path' => 'cayenne/replication/replication_plugin.rb',
				'class' => '::OrmReplication::Plugin',
		},
	]
}
