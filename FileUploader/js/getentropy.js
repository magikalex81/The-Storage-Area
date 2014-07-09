'use strict';

var entropy256=({
   'jsonrpc': '2.0',
   'method': 'generateBlobs',
   'params': {
      'apiKey': '52679680-6404-4c86-af59-08a5b3fa5ca5',
      'n': 1,
      'size': 256,
      'format': 'hex',
      },
   'id': 42
});

response{
   return $http({
      url: 'https://api.random.org/json-rpc/1/invoke',
      method: 'POST',
      headers:{'Content-Type':'application/json-rpc'},
      data: entropy256
      });
}
console.debug(response)
