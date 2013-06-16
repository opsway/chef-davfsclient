Description
===========

Installs davfs2 and configure mounts.
Adds /etc/init.d/davfsclient to mount on startup.

Requirements
============

## Platform:

Tested on:

* Ubuntu 12.04

Attributes
==========

* `node[:davfsclient][:ignore_home]` - allow mount points in users homes

* `node[:davfsclient][:mounts]` - hash with mount points definitions

Example: 

default[:davfsclient][:mounts]={
               :share1=>{
                       "remote"=>"https://foo.bar/blablabla/resours_to_mount_1",
                       "local"=>"/mnt/dav/1",
                       "user"=>"user1",
                       "password"=>"password1"  
               },
               :share2=>{
                       "remote"=>"https://foo.bar/blablabla/resours_to_mount_2",
                       "local"=>"/mnt/dav/2",
                       "user"=>"user2",
                       "password"=>"password2"  
               }
}

