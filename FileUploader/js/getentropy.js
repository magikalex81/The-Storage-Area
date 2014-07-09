var url='https://api.random.org/json-rpc/1/invoke'

var entropy256=({
    "jsonrpc": "2.0",
    "method": "generateBlobs",
    "params": {
        "apiKey": "52679680-6404-4c86-af59-08a5b3fa5ca5",
        "n": 1,
        "size": 256,
        "format": "hex"
    },
    "id": 27269
});






var getEntropy = function(callback) {
   
   var xhr = new XMLHttpRequest();
   xhr.open("POST", url, true);
   
   xhr.setRequestHeader("Content-type", "application/json-rpc");

   xhr.onreadystatechange = function() {
      if (xhr.readyState == 4) {
         callback(xhr.responseText);
      } 
   }
   xhr.send(JSON.stringify(entropy256));
}


/// Exemple d'utilisation

var onGetEntropy = function(response) {
   console.debug(response);
   conole.debug(data.response)
}

getEntropy(onGetEntropy);
