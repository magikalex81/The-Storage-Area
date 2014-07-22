**[Versioning][1] of The Storage Area.**

X.Y.Z.-dev :    This version is still in active development<br>
X.Y.Z.-alpha :  This version is in a closed testing phase<br>
X.Y.Z.-beta :   This version is in a opened testing phase<br>
X.Y.Z.-rc :     This version is in a public testing phase<br>
X.Y.Z :         This version is released<br>
date :          The date the version has been finalized


**V 0.1.1-dev**, date :

* Brand new *FLAT DESIGN* *en/fr* website
* EBIOS (c) based analysis
* Capable of retrying on error
* Support Cross-Origin protected POST
* User credentials are binded to a PKDF whith sha256-mod
* PHP is replaced by python3
* Servers are 0.1.1+server.0.1.0-dev
 * based on two virtualized amd64 debian 7 with a single VDisk at 8 GB for each
 * automaticaly updated per 2H
 * OS is constantly checked for virus and root-kits
 * sending-mail to sysadmin capable
* Client will automaticaly choose the faster free server to upload the next chunk 
* Files are located in a easy-reconstruction way, hash based


**V 0.1.0-dev** , date :

* Selecting files per drag&drop or click&choose
* Cut files in many chunks
* Chunks are sent to (at least) two servers

  [1]: https://github.com/mojombo/semver/blob/master/semver.md
