+++
title = 'Hack the Box Swag Shop Writeup'
date = 2019-09-29T04:55:45-07:00
hideToc = true
+++
![Hack The Box SwagShop](/posts/images/hack-the-box-swag-shop-writeup/badge.png)

# Introduction
SwagShop was an easy but fun box for me. When this box was active it was also the only way you could buy t-shirts and stickers (now HTB's shop is publicly available). So, without further blabering, you can read the writeup below.


# Information Gathering

## Nmap
We begin our reconnaissance by running an Nmap scan checking default scripts and testing for vulnerabilities.

```console
root@kali:~# nmap -sVC -o nmap_SwagShop.txt 10.10.10.140
Starting Nmap 7.70 ( https://nmap.org ) at 2019-06-11 16:30 EDT
Nmap scan report for 10.10.10.140
Host is up (0.41s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 b6:55:2b:d2:4e:8f:a3:81:72:61:37:9a:12:f6:24:ec (RSA)
|   256 2e:30:00:7a:92:f0:89:30:59:c1:77:56:ad:51:c0:ba (ECDSA)
|_  256 4c:50:d5:f2:70:c5:fd:c4:b2:f0:bc:42:20:32:64:34 (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Home page
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 34.88 seconds
```

From the above output we can see that ports, **22**, and **80**, are open. So lets checkout what's going on with port **80**.


## Port 80: Apache & Magneto
When we browse to SwagShop's main web port, we see a Magneto shop is running. Let's see if we can find any interesting files using some http enumeration.

![Magneto running on SwagShop](/posts/images/hack-the-box-swag-shop-writeup/1.png)



### HTTP Enumeration: dirbuster

```console
root@kali:~/Tools/dirsearch# python3 dirsearch.py -u http://10.10.10.140 -e ,php,txt
 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: , php, txt | HTTP method: get | Threads: 10 | Wordlist size: 6777

Error Log: /root/Tools/dirsearch/logs/errors-19-07-03_17-23-54.log

Target: http://10.10.10.140

[17:23:56] Starting:
[17:24:00] 200 -   16KB - /
[17:25:42] 301 -  310B  - /app  ->  http://10.10.10.140/app/
[17:25:43] 200 -    5KB - /app/etc/config.xml
[17:25:43] 200 -    2KB - /app/etc/local.xml
[17:25:43] 200 -    9KB - /app/etc/local.xml.additional
[17:25:43] 200 -    2KB - /app/etc/local.xml.template
[17:26:24] 200 -    0B  - /cron.php
[17:26:25] 200 -  717B  - /cron.sh
[17:26:35] 301 -  317B  - /downloader  ->  http://10.10.10.140/downloader/
[17:26:36] 200 -  464B  - /downloader/connect.cfg
[17:26:40] 200 -  343KB - /downloader/cache.cfg
[17:26:42] 301 -  313B  - /errors  ->  http://10.10.10.140/errors/
[17:26:42] 200 -    2KB - /errors/
[17:26:45] 200 -    1KB - /favicon.ico
[17:27:05] 301 -  315B  - /includes  ->  http://10.10.10.140/includes/
[17:27:05] 200 -  946B  - /includes/
[17:27:07] 200 -   16KB - /index.php
[17:27:11] 200 -   44B  - /install.php
[17:27:15] 301 -  309B  - /js  ->  http://10.10.10.140/js/
[17:27:16] 301 -  318B  - /js/tiny_mce  ->  http://10.10.10.140/js/tiny_mce/
[17:27:16] 200 -    4KB - /js/tiny_mce/
[17:27:19] 301 -  310B  - /lib  ->  http://10.10.10.140/lib/
[17:27:20] 200 -   10KB - /LICENSE.txt
[17:27:35] 301 -  312B  - /media  ->  http://10.10.10.140/media/
[17:28:04] 200 -  886B  - /php.ini.sample
[17:28:16] 301 -  314B  - /pkginfo  ->  http://10.10.10.140/pkginfo/
[17:28:35] 403 -  301B  - /server-status/
[17:28:35] 403 -  300B  - /server-status
[17:28:39] 301 -  312B  - /shell  ->  http://10.10.10.140/shell/
[17:28:40] 200 -    2KB - /shell/
[17:28:43] 200 -  571KB - /RELEASE_NOTES.txt
[17:28:47] 301 -  311B  - /skin  ->  http://10.10.10.140/skin/
[17:29:19] 301 -  310B  - /var  ->  http://10.10.10.140/var/
[17:29:19] 200 -    4KB - /var/cache/
[17:29:19] 200 -  755B  - /var/backups/

Task Completed
```

A number of things catch the eye here. We can see that the `session` directory is exposed, and that Magneto is configured to use the file system for sessions rather than the database. Attempting to hijack the admin sessions did not work in this case though. Perhaps someone may have had success with this method, but I did not. Another interesting note is that we're able to see the MySQL root password by browsing to `/app/etc/local.xml`.

![SwagShop MySQL root credentials](/posts/images/hack-the-box-swag-shop-writeup/mysql_root.png)


Store these away in the event that it will help with privilege escalation later on.

We find the file `http://10.10.10.140/RELEASE_NOTES.txt` which allows us to determine the Magneto version being run. That should help us determine if there's a public exploit available that we can leverage.


```text
==== 1.7.0.2 ====

=== Fixes ===
Fixed: Security vulnerability in Zend_XmlRpc - http://framework.zend.com/security/advisory/ZF2012-01
Fixed: PayPal Standard does not display on frontend during checkout with some merchant countries
```

That's a pretty old version of Magneto. When we search for public exploits we find an unauthenticated exploit known as **[shoplift](https://github.com/incredibleindishell/Magento-shoplift-python-exploit)**.

# Exploitation

This exploit worked perfectly, with one slight modification. Since the site doesn't appear to be using `modrewrite` we must include `index.php` line 7 of the exploit, which sets the target.
`

```console
root@kali:~/Desktop# python shoplift.py
WORKED
Check http://10.10.10.140/index.php/admin with creds forme:forme
```

We've now created an admin user `forme`, with password `forme`.

![Magneto Admin Dashboard.](/posts/images/hack-the-box-swag-shop-writeup/admin_panel.png)



## User Flag

In order to move towards the user flag from the admin panel of Magneto, we need a method for uploading files. Out of the box Magneto doesn't provide a file manager, so we need to upload a package of our own through the "Magneto Connect Manager" at the url `http://10.10.10.140/downloader/`, which we now have access to.

![Magneto Connect Manager.](/posts/images/hack-the-box-swag-shop-writeup/downloader.png)


Because creating a package from scratch proved to be a little finicky for me, I chose to upload my php shell code into an existing package called **[sendwithus](https://github.com/sendwithus/extension-magento/blob/master/dist/Sendwithus_Mail-1.0.2.tgz)**. To do this we simply extract the package and add our shell code.

![Shell code in modified Magneto package.](/posts/images/hack-the-box-swag-shop-writeup/shells.png)


Generate our checksum for the shells.

```console
x@wartop:~/Desktop/HTB_Swagshop$ md5sum shell.php && md5sum rshell.php
f2013115840359271c1f3e4661091efa  shell.php
55c320877fe1ecda130c33ecdf3e95a1  rshell.php
```

Then we modify the `package.xml` to also include our shells.

```xml
<file name="Mail.php" hash="999a50a911486c5c48a5c43d5a072220"/>
<file name="shell.php" hash="f2013115840359271c1f3e4661091efa"/>
<file name="rshell.php" hash="5f8af08f753e5d318d307e75ad91c039"/>
```

![Uploading Magneto package with our shell code.](/posts/images/hack-the-box-swag-shop-writeup/package.png)


Once we've uploaded the package, we can access `shell.php`, which is the [p0wny](https://github.com/flozz/p0wny-shell) web shell. All we need to do in order to gain the user flag is navigate to the `/home/harris` directory and print it to the screen.

![user.txt flag.](/posts/images/hack-the-box-swag-shop-writeup/user.png)



## Root Flag

We can see by browsing around a bit, or by running [Linux Smart Enumeration](https://github.com/diego-treitos/linux-smart-enumeration) that we're able to read the contents of the `sudoers` file. I was so eager to read the contents of the file that I copied it to the web directory before even launching my reverse shell.

![copy sudoers.](/posts/images/hack-the-box-swag-shop-writeup/copy_sudoers.png)


![view sudoers.](/posts/images/hack-the-box-swag-shop-writeup/view_sudoers.png)




One line sticks out in the sudoers file as an easy route to privilege escalation `www-data ALL=NOPASSWD:/usr/bin/bi /var/www/html/*`. Basically, without a password the user `www-data` is able to run `vi` in the web server directory.

In order to exploit this we're going to need a shell that allows us to use `vi`. So, it's time to get a reverse shell fired up. Since we've got a php reverse shell in our modified Magneto package already, we can launch it with our current web shell.

![Lauch Revers.](/posts/images/hack-the-box-swag-shop-writeup/launch_reverse.png)


Issuing the command `python3 -c 'import pty;pty.spawn("/bin/bash")'` makes it fully interactive and able to run `vi`.

![NetCat rshell.](/posts/images/hack-the-box-swag-shop-writeup/netcat_rshell.png)


In order to launch a root shell, issue the command `sudo /usr/bin/vi /var/www/html/whatever.sh`. This will run `vi` as root, which we can do without a password if we're working on a file in the web directory. Since [*`vi` is able to issue shell commands*](http://web.physics.ucsb.edu/~pcs/apps/editors/vi/vi_unix.html) via the `:!`, we can use this to launch bash as root.

![rooted.](/posts/images/hack-the-box-swag-shop-writeup/rooted.png)



# Conclusion
I really enjoyed working on SwagShop. Some have complained that the public exploit used to gain the initial foothold was a few years too old, which I think is valid. The box did seem realistic to me though because I'm aware of plenty of small businesses who have no one maintaining their applications once they're built. Unless/until there's an issue they just leave their sites up and running unpatched. The fact that there could be an outdated version of Magneto from years ago isn't that far out there. Privilege escalation on this box was really simple if you're aware the `vi` can execute commands. Personally I'd never done that before, but a quick Google search made me aware and root was gained. There were a few rabbit holes such as the `sessions` tempting us to try and use hijacking, and the MySQL credentials never turned out to be very necessary.
