<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST'); 


if (isset($POST) && $POST == 'PING')
	echo('PONG');

?>
