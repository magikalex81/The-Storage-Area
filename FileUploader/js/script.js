// variables

var count = document.getElementById('count'); // text zone to display nb files done/remaining
var result = document.getElementById('result'); // text zone where informations about uploaded files are displayed



(function(){
	"use strict";
	
	
	
	
	var getServerOptions = function() {
		
		var request = new XMLHttpRequest();
		request.open('GET', '/php/getserver.php', false);  // `false` makes the request synchronous
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
		server : getServerOptions,
		maxFiles : 500,				// Define the max files per drag-n-drop
		//maxFilesErrorCallback : function (files, errorCount) { };
		//maxFileSizeErrorCallback : function(file, errorCount) { };
		chunkSize : 1*1024*1024,	// If file size exceed maxFileSize, cut it in files of size chunkSize
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
		var fileItem = document.createElement("div");
		fileItem.id = file.fileName;
		fileItem.className = "list-group-item";
		fileItem.appendChild(document.createTextNode(file.fileName));
		
		var statusSpan = document.createElement("span");
		statusSpan.className = "pull-right";
		statusSpan.appendChild(document.createTextNode("Pending"));
		fileItem.appendChild(statusSpan);
		
		var progressBar = document.createElement("progress");
		progressBar.max = file.size;
		fileItem.appendChild(progressBar);
		
		
		
		result.appendChild(fileItem);
		
		file.uiElement = fileItem;
		
		count.value = count.value +1;
		
	});
	
	
	uploader.on('filesAdded', function(files) {
		uploader.upload();
	});
	
	uploader.on('fileProgress', function(file) {
		var fileItem = file.uiElement;
		var progress = fileItem.children[1];
		progress.value = file.uploaded();
	});
	
	uploader.on('chunkStatusChange', function(chunk) {
		var file = chunk.fileObject;
		var fileItem = file.uiElement;
		fileItem.childNodes[1].innerText = chunk.fileObject.status();	
	});
	
	uploader.on('fileSuccess', function(file) {
		var fileItem = file.uiElement;
		var progress = fileItem.children[1];
		progress.value = progress.max;
		fileItem.classList.add("success");
		progress.parentElement.removeChild(progress);
		uploader.upload();
	});
	
	uploader.on('fileError', function(file) {
		var fileItem = file.uiElement;
		var progress = fileItem.children[1];
		progress.value = 0;
		fileItem.classList.add("failure");
		uploader.upload();
	});
	
	
})();
	
	
	
	
	
	
