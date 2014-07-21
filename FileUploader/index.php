<?php
function bytesToSize1024($bytes) { //RISKY ! in time, size may increase ! I'll take a look
    $unit = array('B','KiB','MiB','GiB');
    return @round($bytes / pow(1024, ($i = floor(log($bytes, 1024)))), 1).' '.$unit[$i];
}
$df = bytesToSize1024(disk_free_space("/")); // will be stuck into a block file.
$maxfiles = 500
?>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>(c) ACTICIA</title>
		<link href="css/main.css" rel="stylesheet" type="text/css" />
	</head>
	<body>
		<header>
			<h2>The Storage Area</h2>
		</header>
		<div class="container">
			<div class="contr">
				<h2>Upload your files (max <?=$maxfiles?> files at once)</h2> <!-- read $maxfiles --> 
			</div>
			<div class="upload_form_cont">
				<div class="info">
					<div id="dropArea">Click to choose or Drop your files here</div>
					<div>
						<span id="count"></span>
					</div>
					<div id="result" class="list-group"></div>
				</div>
			</div>
			<footer>
				By <a href="http://www.acticia.com">ACTICIA</a><br>
				This product does not comply with the right of Data Records Erasure provided by Member States in regard of the right to oblivion<br>
				ACTICIA does not know how to erase data in this system<br>
				Still <?=$df?> available on this node<br>
				ALPHA RESTRICTIONS APPLIED</footer>
		</div>
		<script type="text/javascript" src="js/file_uploader.js"></script>
		<script type="text/javascript" src="js/script.js"></script>
	        <script type="text/javascript" src="js/sha256mod.js"></script>
	        <script type="text/javascript" src="js/getentropy.js"></script>
	</body>
</html>
