// variables

var count = document.getElementById('count'); // text zone to display nb files done/remaining
var result = document.getElementById('result'); // text zone where informations about uploaded files are displayed


//https://github.com/23/resumable.js
// main initialization
(function(){
	"use strict";
	
	
	
	
	var getServer = function() {
		
		var request = new XMLHttpRequest();
		request.open('GET', '/php/getServer.php', false);  // `false` makes the request synchronous
		request.send(null);
		
		if (request.status === 200) {
			return JSON.parse(request.response);
		} else 
			return null;
	};
	
	
	
	
	var preprocessChunk = function(chunk) {
		//SHA + Encryption
	};
	
	
	var verifyChunk = function(chunk) {
		//Hash verification
	};
	
	
	
	
	var options = {
		//server : getServer(),
		uploadUrl : function() { return ['/php/upload.php']; },
		maxFiles : 500,				// Define the max files per drag-n-drop
		//maxFilesErrorCallback : function (files, errorCount) { };
		maxFileSize : 20*1024*1024, // PHP file size limit (TODO à faire générer par PHP)
		//maxFileSizeErrorCallback : function(file, errorCount) { };
		chunkSize : 4*1024*1024,	// If file size exceed maxFileSize, cut it in files of size chunkSize
		fileType : [],				// Restrict upload to some extensions
		//fileTypeErrorCallback: function(file, errorCount) { };
		preprocess : preprocessChunk,
		verify : verifyChunk
	};
	
	var uploader = new FileUploader(options);
	
	var dropArea = document.getElementById('dropArea'); // drop area zone JS object
	uploader.assignDrop(dropArea);
	uploader.assignBrowse(dropArea);
	
	
	
	uploader.on('fileAdded', function (file) {
		var fileDiv = document.createElement("div");
		fileDiv.id = file.fileName;
		fileDiv.appendChild(document.createTextNode(file.fileName));
		fileDiv.appendChild(document.createTextNode("Pending"));
		
		var progressBar = document.createElement("progress");
		progressBar.max = file.size;
		
		fileDiv.appendChild(progressBar);
		
		result.appendChild(fileDiv);
		
		file.uiElement = fileDiv;
		
		count.value = count.value +1;
		
	});
	
	
	uploader.on('filesAdded', function(files) {
		uploader.upload();
	});
	
	uploader.on('fileProgress', function(file) {
		var fileDiv = file.uiElement;
		var progress = fileDiv.children[0];
		progress.value = file.uploaded();
	});
	
	uploader.on('chunkStatusChange', function(chunk) {
		var file = chunk.fileObject;
		var fileDiv = file.uiElement;
		fileDiv.childNodes[1].data = chunk.fileObject.status();	
	});
	
	uploader.on('fileSuccess', function(file) {
		var fileDiv = file.uiElement;
		var progress = fileDiv.children[0];
		progress.value = progress.max;
		
		uploader.upload();
	});
	
	
	
	
})();
	
	
	
	
	
	
