
<?php
$GLOBALS['destFolder'] = 'files';

error_reporting(-1); 

if (isset($_FILES['myfile'])) {
        $sFileName = $_FILES['myfile']['name'];
        $sFileType = $_FILES['myfile']['type'];
        $sFileSize = bytesToSize1024($_FILES['myfile']['size']);
        move_uploaded_file($_FILES['myfile']['tmp_name'], $GLOBALS['destFolder'].'/'.$sFileName);
} else {
        echo 'An error occurred';
}
?>
