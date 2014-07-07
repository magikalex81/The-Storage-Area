<?php
	$result = array(
		0 => array("host" => "alex1.acticia.net", "uploadUrl" => "/php/upload.php"), //le port peut etre spécifié dans l'url ex: alex1.acticia.net:8080
		1 => array("host" => "alex2.acticia.net", "uploadUrl" => "/php/upload.php")
	);
		
	echo json_encode($result);
?>
