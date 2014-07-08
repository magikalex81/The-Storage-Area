
(function(){
	
	"use strict";



	function formatSize(size) {
	    if(size<1024) {
	    	return size + ' bytes';
	    } else if(size<1024*1024) {
	    	return (size/1024.0).toFixed(0) + ' KB';
	    } else if(size<1024*1024*1024) {
	    	return (size/1024.0/1024.0).toFixed(1) + ' MB';
	    } else {
	    	return (size/1024.0/1024.0/1024.0).toFixed(1) + ' GB';
	    }
	}
	
	function contains(array, value) {
		for (var i = 0; i < array.length; i++) {
	    	if (array[i] === value) {
	        	return true;
	        }
		}
		return false;
	}





  	var FileUploader = function(options) {
    	if ( !(this instanceof FileUploader) ) {
      		return new FileUploader(options);
    	}
    	
    	this.version = "0.1a";
    	
    	var uploader = this;
    	    	
    	this.defaultOpts = {
    		server : function() { return ['']; },
    		uploadUrl : function() { return '/upload.php'; },
    		maxFiles : undefined,
    		maxFilesErrorCallback : function (files, errorCount) {
        		var maxFiles = this.options('maxFiles');
        		alert('Please upload ' + maxFiles + ' file' + (maxFiles === 1 ? '' : 's') + ' at a time.');
      		},
      		
    		maxFileSize : undefined,
    		maxFileSizeErrorCallback : function(file, errorCount) {
        		alert(file.fileName || file.name + ' is too large, please upload files less than ' + formatSize(this.options('maxFileSize')) + '.');
      		},
      		
      		fileType: [],
      		fileTypeErrorCallback: function(file, errorCount) {
        		alert(file.fileName || file.name + ' has type not allowed, please upload files of type ' + this.options.fileType + '.');
      		},
      		
      		preprocessChunk : function(chunk) { },
      		verifyChunk : function(chunk) { return true; },
      		      		
      		allowChunk : true,
    		chunkSize : 4*1024*1024
      		
    	};
    	
    	this.options = options || {};
    	for (var opt in this.defaultOpts)
        	if (this.defaultOpts.hasOwnProperty(opt) && !this.options.hasOwnProperty(opt))
            	this.options[opt] = this.defaultOpts[opt];
        
        
//-------------------------------------------------------------------------------

    	var onDragOver = function(e) {
			e.preventDefault();
			e.target.className = 'dragover';
		};
		
		var onDrop = function(e){
			e.stopPropagation();
        	e.preventDefault();
			appendFiles(e.dataTransfer.files, e);
		};
		
		
		this.assignDrop = function(elem){
       		elem.addEventListener('dragover', onDragOver, false);
        	elem.addEventListener('drop', onDrop, false);
      	};
    
    	this.unAssignDrop = function(elem) {
	        elem.removeEventListener('dragover', onDragOver);
    	    elem.removeEventListener('drop', onDrop);
      	};
    
    	
    	this.assignBrowse = function(elem, isDirectory) {

	        var input;
	        if(elem.tagName === 'INPUT' && elem.type === 'file'){
	        	input = elem;
	        } else {
				input = document.createElement('input');
				input.setAttribute('type', 'file');
				input.style.display = 'none';
				elem.addEventListener('click', function() {
					input.style.opacity = 0;
					input.style.display='block';
					input.focus();
					input.click();
					input.style.display='none';
	          	}, false);
	        	elem.appendChild(input);
	        }
	        var maxFiles = uploader.options.maxFiles;
	        if (typeof(maxFiles) === 'undefined' || maxFiles !== 1) {
	        	input.setAttribute('multiple', 'multiple');
	        } else {
	        	input.removeAttribute('multiple');
	        }
	        if(isDirectory) {
	        	input.setAttribute('webkitdirectory', 'webkitdirectory');
	        	input.setAttribute('directory', 'directory');
	        } else {
	        	input.removeAttribute('webkitdirectory');
	        	input.removeAttribute('directory');
	        }
	        
	        // When new files are added, simply append them to the overall list
        	input.addEventListener('change', function(e){
          		appendFiles(e.target.files, e);
          		e.target.value = '';
        	}, false);
    	};   
    	
//-------------------------------------------------------------------------------    	
// EVENTS

		// catchAll(event, ...)
		// fileSuccess(file), fileProgress(file), fileAdded(file, event), fileRetry(file), fileError(file, message),
		// complete(), progress(), error(message, file), pause()
		this.events = [];
		this.on = function(event, callback) {
			uploader.events.push(event.toLowerCase(), callback);
		};
		
		this.fire = function() {
			// `arguments` is an object, not array, in FF, so:
			var args = [];
			for (var i=0; i<arguments.length; i++) args.push(arguments[i]);
		
			// Find event listeners
			var event = args[0].toLowerCase();
			for (i=0; i<=uploader.events.length; i+=2) {
				if(uploader.events[i] == event) uploader.events[i+1].apply(uploader, args.slice(1));
				
			}
			if(event=='fileerror') uploader.fire('error', args[2], args[1]);//??
			if(event=='fileprogress') uploader.fire('progress');//??
		};
    
//-------------------------------------------------------------------------------     
    
    	this.files = [];    	
    	
    	this.isUploading = function(){
      		var uploading = 0;
      		for (var i=0; i< uploader.files.length; i++) {
        		if (uploader.files[i].isUploading()) uploading++;
            }
      
      		return uploading;
    	};
    	
    	
		
		
		var appendFiles = function(fileList, event) {
			
			var errorCount = 0;
			
			var maxFiles = uploader.options.maxFiles;
			var maxFileSize = uploader.options.maxFileSize;
			var allowChunk = uploader.options.allowChunk;
			var fileType = uploader.options.fileType;
			
			if (typeof(maxFiles) !== 'undefined' && maxFiles < (fileList.length + uploader.files.length)) {
        	// if single-file upload, file is already added, and trying to add 1 new file, simply replace the already-added file 
        		if (maxFiles === 1 && uploaderuploader.files.length === 1 && fileList.length === 1) {
          			uploader.removeFile(uploader.files[0]);
        		} else {
          			uploader.options.maxFilesErrorCallback(fileList, errorCount++);
          			return false;
        		}
      		}
      		
      		for (var i=0; i<fileList.length; i++) {
				var file = fileList[i];
				var fileName = file.name.split('.');
				var fileExt = fileName[fileName.length-1].toLowerCase();
				
				if (fileType.length > 0 && !contains(uploader.options.fileType, fileExt)) {
					uploader.options.fileTypeErrorCallback(file, errorCount++);
					return false;
				}       

				if (typeof(maxFileSize)!=='undefined' && file.size > maxFileSize && !allowChunk) {
					uploader.options.maxFileSizeErrorCallback(file, errorCount++);
					return false;
				}
        
				
				var fileobj = new FileObject(file, uploader);
				
				window.setTimeout(function(fileobj) {
					uploader.files.push(fileobj);
					uploader.fire('fileAdded', fileobj, event);
				}, 0, fileobj);
			}
      		
			window.setTimeout(function(files){
				uploader.fire('filesAdded', files);
			},0, uploader.files);
      		      		
		};
		
		
		var mainLoop = function () {
		
			if (uploader.isUploading() < uploader.options.server().length) {
			
				for (var i=0; i<uploader.files.length; i++) {
					if (uploader.files[i].status() !== 'success')
						break;
				}
				
				if (i < uploader.files.length) {
					window.setTimeout(function(){
						uploader.files[i].uploadNextChunk();
					},0);
				}
			}
			
		};
		
		
		
		this.upload = function() {
			mainLoop();
		};

		
  	};	
	
	
	
	// Node.js-style export for Node and Component
	if (typeof module !== 'undefined') {
		module.exports = FileUploader;
	} else if (typeof define === "function" && define.amd) {
	
	// AMD/requirejs: Define the module
		define(function(){
			return FileUploader;
		});
	} else {
		
	// Browser: Expose to window
		window.FileUploader = FileUploader;
	}




	
//----------------------------------------------------------------------------	
// FileObject




	
	function FileObject(file, uploader) {
		
		this.uploader = uploader;
		var fileObject = this;
		
		this.file = file;
		this.fileName = file.fileName || file.name; // Some confusion in different versions of Firefox
		this.size = file.size;
		this.relativePath = file.webkitRelativePath || this.fileName;
		
		this.chunks = [];
	  	
	  	
	  	this.status = function() {
	  		
	  		var chunksStatus = 0;
	  		for (var i=0; i<fileObject.chunks.length; i++)
	  			chunksStatus += fileObject.chunks[i].status;
	  		chunksStatus = chunksStatus / fileObject.chunks.length;
	  		
	  		if (chunksStatus === 0) return 'pending';
	  		else if (chunksStatus < 2) return 'preprocessing';
			else if (chunksStatus === 2) return 'ready';
			else if (chunksStatus === 4) return 'verifying';
			else if (chunksStatus < 5) return 'uploading';
			else if (chunksStatus === 5) return 'success';
			else return 'error';				
	 	};
	
	
	
		this.isUploading = function() {
			var status = fileObject.status();
			return !(status === 'pending' || status === 'success' || status === 'error');
		};
		
		
		
		this.uploaded = function () {
			var result = 0;
			for (var i=0; i<fileObject.chunks.length; i++) {
				result += fileObject.chunks[i].uploaded;
			}
			return result;
		};
		
		
		
		this.uploadNextChunk = function() {
			
			var chunk;
			for (var i=0; i<fileObject.chunks.length; i++) {
				chunk = fileObject.chunks[i];
				if (chunk.status === 0 || chunk.status > 5) break;
			}
			if (i<fileObject.chunks.length) {
				chunk.preprocess();
				chunk.upload();
			}
						
		};
		
		
		
		// Callback when something happens within a chunk
		var chunkEvent = function(event, data){
		// event can be 'progress', 'success', 'error' or 'retry'
			switch(event){
				case 'statusChange':
					uploader.fire('chunkStatusChange', data);
					console.info('Status Change on [chunk id='+data.chunkIndex+', file='+data.fileObject.fileName+'] -> ' + data.getStatus());
					break;
				
				case 'progress':
					uploader.fire('fileProgress', fileObject);
					break;
				
				case 'uploadEnd':
					data.verify();
					break;
					
				case 'error':
					break;
					
				case 'success':
					if (fileObject.status() === 'success') { 
						uploader.fire('fileSuccess', fileObject);
					} 
					else
						fileObject.uploadNextChunk();
					break;
				case 'retry':
					break;
				}
		};
		
		
		
		var maxChunkIndex;
		
		if (file.size > this.uploader.options.maxFileSize)			
			maxChunkIndex = this.size / this.uploader.options.chunkSize;
		else
			maxChunkIndex = 1;
			
			
		for (var chunkIndex=0; chunkIndex < maxChunkIndex; chunkIndex++) {
			var chunk = new ChunkObject(this, this.uploader.options.chunkSize, chunkIndex);
			chunk.eventCallback = chunkEvent;
			this.chunks.push(chunk);
		} 
			
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
//----------------------------------------------------------------------------
// ChunkObject
	
	
	
	

	function ChunkObject(fileObject, chunkSize, chunkIndex) {
	
		this.uploader = fileObject.uploader;
		this.fileObject = fileObject;
		this.chunkIndex = chunkIndex;			
		this.chunkSize = chunkSize;
		this.chunkData = null;
		this.uploaded = 0;
	  	this.startByte = this.chunkIndex * chunkSize;
	  	this.endByte = Math.min(this.fileObject.size, (this.chunkIndex+1) * chunkSize);
	  	this.size = this.endByte - this.startByte;
	  	      		  		
	  	this.eventCallback = null;
	  	      		
	  	var that = this;
	  	
	  	//pending, preprocessing, ready, uploading, verifying, success, error
	  	this.status = 0;
	  	this.getStatus = function() {
	  		switch (that.status) {
	  			case 0: return 'Pending';
	  			case 1: return 'Preprocessing';
	  			case 2: return 'Ready to upload';
	  			case 3: return 'Uploading';
	  			case 4: return 'Verifying';
	  			case 5: return 'Success';
	  			default: return 'Error';
	  		}
	  	};
		
		    		
		this.preprocess = function() {
			that.status = 1;
			that.eventCallback('statusChange', that);
			that.chunkData = that.fileObject.file.slice(that.startByte, that.endByte);
			that.uploader.options.preprocessChunk(that);
			that.status = 2;
			that.eventCallback('statusChange', that);
		};
		
		
		this.xhr = null;
		
		this.upload = function() {
			if (that.status !== 2) {
				console.warn('Call to upload in wrong state('+that.status+') - [chunk id='+that.chunkIndex+', file='+that.fileObject.fileName+']');
				return;
			}
			
			
			var formData = new FormData();
	  		formData.append('fileName', that.fileObject.fileName);
	  		formData.append('relativePath', that.fileObject.relativePath);
	  		formData.append('totalChunks', that.fileObject.chunks.length);
	  		formData.append('chunkSize', that.chunkSize);
	  		formData.append('chunkId', that.chunkIndex);
	  		formData.append('currentChunkSize', that.size);
	  		formData.append('chunkData', that.chunkData);
	  		
	  		    			
	  		var url = that.uploader.options.server() + that.uploader.options.uploadUrl();
	  		
			that.xhr = (window.XMLHttpRequest) ? new XMLHttpRequest() : (window.ActiveXObject) ? new ActiveXObject("Microsoft.XMLHTTP") : null;
			that.xhr.open("POST", url, true);
			
			
			// When the request starts.
			that.xhr.upload.addEventListener('loadstart', function(e) {
				that.status = 3; //uploading
				that.eventCallback('statusChange', that);
			});
			
			// While sending and loading data.
			that.xhr.upload.addEventListener('progress', function(e) {
				if (e.lengthComputable) {
					that.uploaded = e.loaded;
			    	that.eventCallback('progress', that);
			    }
			});
			
			// When the request has *successfully* completed.
			// Even if the server hasn't responded that it finished.
			that.xhr.upload.addEventListener('load', function(e) {
				
			});
			
			// When the request has completed (either in success or failure).
			// Just like 'load', even if the server hasn't 
			// responded that it finished processing the request.
			that.xhr.upload.addEventListener('loadend', function(e) {
				
			});
			
			// When the request has failed.
			that.xhr.upload.addEventListener('error', function(e) {
				
			});
			
			// When the request has been aborted. 
			// For instance, by invoking the abort() method.
			that.xhr.upload.addEventListener('abort', function(e) {
				
			});
			
			// When the author specified timeout has passed 
			// before the request could complete.
			that.xhr.upload.addEventListener('timeout', function(e) {
				
			});
			
			// notice that the event handler is on xhr and not xhr.upload
			that.xhr.addEventListener('readystatechange', function(e) {
				if( this.readyState === 4 ) {
					// the transfer has completed and the server closed the connection.
					that.uploaded = that.size;
			    	that.eventCallback('progress', that);
					that.eventCallback('uploadEnd', that);
				}
			});
			
			that.xhr.send(formData);
			
		};
		
		
		this.verify = function() {
			
			that.status = 4;//verifying
			that.eventCallback('statusChange', that);
			
			if (that.uploader.options.verifyChunk(that)) {
				 that.status = 5;
				 that.eventCallback('statusChange', that);
				 that.eventCallback('success', that);
			}
			else {//verification failed
				that.status = Number.MAX_VALUE;
				that.eventCallback('statusChange', that);
				that.uploaded = 0;
				that.eventCallback('progress', that);
			}
		};
		
		
	}	

	
	
	
})();
	
	
	
	
	