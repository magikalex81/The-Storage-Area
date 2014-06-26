// variables
var dropArea = document.getElementById('dropArea'); // drop area zone JS object
var count = document.getElementById('count'); // text zone to display nb files done/remaining
var result = document.getElementById('result'); // text zone where informations about uploaded files are displayed
var list = []; // file list
var nbDone = 0; // initialisation of nb files already uploaded during the process.


// main initialization
(function(){

	// init handlers
	function initHandlers() {
		dropArea.addEventListener('drop', handleDrop, false);
		dropArea.addEventListener('dragover', handleDragOver, false);
	}

	// drag over
	function handleDragOver(event) {
		event.stopPropagation();
		event.preventDefault();

		dropArea.className = 'hover';
	}

	// drag drop
	function handleDrop(event) {
		event.stopPropagation();
		event.preventDefault();

		processFiles(event.dataTransfer.files);
	}

	// process bunch of files
	function processFiles(filelist) {
		if (!filelist || !filelist.length || list.length) return;

		result.textContent = '';

		for (var i = 0; i < filelist.length && i < 500; i++) { // limit is 500 files (only for not having an infinite loop)
			list.push(filelist[i]);
		}
		uploadNext();
	}

	// upload file
	function uploadFile(file, status) {

		// prepare XMLHttpRequest
		var xhr = new XMLHttpRequest();
		xhr.open('POST', './php/upload.php');
		xhr.onload = function() {
			result.innerHTML += this.responseText;
			uploadNext();
		};
		xhr.onerror = function() {
			result.textContent = this.responseText;
			uploadNext();
		};

		// prepare and send FormData
		var formData = new FormData();  
		formData.append('myfile', file); 
		xhr.send(formData);
	}

	// upload next file
	function uploadNext() {
		if (list.length) {
			var nb = list.length - 1;
			//nbDone +=1;
			count.textContent = 'Files done: '+nbDone+' ; '+'Files left: '+nb;
			var nextFile = list.shift();
			if (nextFile.size >= 20000000) { // 20Mb = generally the max file size on PHP hosts
				result.innerHTML += '<div class="failure">File too big</div>';
				nbDone+=1;
				uploadNext();
				
			} else {
			uploadFile(nextFile, status);
			}
		}
	nbDone+=1
	}

	initHandlers();
})();
