<?php
function bytesToSize1024($bytes) { //RISKY ! in time, size may increase ! I'll take a look
    $unit = array('B','KiB','MiB','GiB');
    return @round($bytes / pow(1024, ($i = floor(log($bytes, 1024)))), 1).' '.$unit[$i];
}
$df = bytesToSize1024(disk_free_space("/"));
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
				<h2>Upload your files (max 500 files at once)</h2>
			</div>
			<div class="upload_form_cont">
				<div class="info">
					<div id="dropArea">Click or Drop your files here</div>
					<div>
						<span id="count"></span>
					</div>
					<h3>Result:</h3>
					<div id="result"></div>
				</div>
			</div>
			<footer>
				By <a href="http://www.acticia.com">ACTICIA</a><br>
				This product does not comply with the right of Data Records Erasure provided by Member States in regard of the right to oblivion<br>
				ACTICIA does not know how to erase data in this system<br>
				Still <?=$df?> available on this node<br>
				ALPHA RESTRICTIONS APPLIED</footer>
		</div>
		<script src="js/file_uploader.js"></script>
		<script src="js/script.js"></script>
	</body>
</html>
