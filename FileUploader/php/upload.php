<?php
//header('Access-Control-Allow-Origin: *');
//header('Access-Control-Allow-Methods: POST'); 

$GLOBALS['destFolder'] = '../files';

error_reporting(-1);
$file_log = './upload_log.txt';

/**
 *
 * Logging operation - to a file (upload_log.txt) and to the stdout
 * @param string $str - the logging string
 */
function _log($str) {

    // log to the output
    $log_str = date('Y.m.d').": {$str}\r\n"; //Y'a que les francais pour apprécier les dates au format FR-fr	
    echo $log_str;

    // log to file
    file_put_contents($file_log, $log_str, FILE_APPEND | LOCK_EX);
}



// loop through files and move the chunks to a temporarily created directory
if (empty($_FILES)) {
    _log('$_FILES is empty!')  
}
else foreach ($_FILES as $file) {

    // check the error status
    if ($file['error'] != 0) {
        _log('error '.$file['error'].' in file '.$_POST['fileName']);
        continue;
    }

    // init the destination file (format <filename.ext>.part<#chunk>
    // the file is stored in a temporary directory
    $temp_dir = $GLOBALS['destFolder'].'/'.$_POST['fileName'];
    $dest_file = $temp_dir.'/'.$_POST['fileName'].'.part'.$_POST['chunkId'];
	
    // create the temporary directory
    if (!is_dir($temp_dir)) {
        mkdir($temp_dir, 0777, true);
    }

    // move the temporary file
    if (!move_uploaded_file($file['tmp_name'], $dest_file)) {
        _log('Error saving (move_uploaded_file) chunk '.$_POST['chunkId'].' for file '.$_POST['fileName']);
    }
}


?>
