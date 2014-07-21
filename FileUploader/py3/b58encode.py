## (c) 2014 by Matthieu VIGUIER. CC-BY-SA 4.0 INTERNATIONAL
## Based on http://pastebin.com/TghewQTM visited 2014-07-21 - copyleft

alphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
base_count = len(alphabet)
       
def b58encode(num):
    ## num is a integer
    encode = ''
   
    if (num < 0):
        return ''
   
    while (num >= base_count):    
        mod = num % base_count
        encode = alphabet[mod] + encode
        num = num // base_count
 
    if (num):
        encode = alphabet[num] + encode
 
    return encode

## TEST
assert b58encode(4000000000)  == '76U3eF', 'Issue found !'
