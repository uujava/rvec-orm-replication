set bin_dir=%CD%
cd H:\code\rvec-production\nb-server\src\main\ruby && h:\tools\7z\7z.exe u h:\data\rvec-release\server\rvec_server\modules\ru-programpark-rvec-nb-server.jar .
cd H:\code\rvec-production\orm\src\main\ruby && h:\tools\7z\7z.exe u h:\data\rvec-release\server\rvec_server\modules\ru-programpark-rvec-orm.jar .
cd %bin_dir%