<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST'); 


if ($POST == 'PING')
	echo('PONG');

?>
