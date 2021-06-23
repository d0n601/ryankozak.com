---
title: "Bad USB Botnet 2: A personal Project"
author: Ryan Kozak
layout: post
permalink: /bad-usb-botnet-2/
categories:
  - Security
tags:
  - BadUSB
  - Botnet
  - DigiSpark
  - Empire

---



This is an excellent feature. 

>Starting Empire back up should preserve existing communicating agents, and any existing listeners will be restarted (as their config is stored in the sqlite backend database).



### Empire Setup

1. Install the Empire.
  1. Clone the project `git clone https://github.com/BC-SECURITY/Empire.git`.
  2. `cd ./Empire && sudo ./setup/install.sh`
  3. Set up certificate for `https` listener `./setup/cert.sh`.
2. Create your first listener.
  1. `listeners` command.
  2. `uselistener http`

```
(Empire: listeners/http) > set Name https-test-listener
(Empire: listeners/http) > set Host https://127.0.0.1:443
(Empire: listeners/http) > set Port 443
(Empire: listeners/http) > set CertPath /home/x/Research/Empire/data
(Empire: listeners/http) > execute
[*] Starting listener 'https-test-listener'
 * Serving Flask app "http" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
[+] Listener successfully started!
(Empire: listeners/http) > listeners

[*] Active listeners:

  Name              Module          Host                                 Delay/Jitter   KillDate
  ----              ------          ----                                 ------------   --------
  https-test-listenerhttp            https://127.0.0.1:443                5/0.0                      

(Empire: listeners) > 

```


## References  

#### Empire (Command and Control)
1. [Empire Source Code](https://github.com/BC-SECURITY/Empire/).
2. [Empire Wiki](https://github.com/BC-SECURITY/Empire/wiki/Quickstart).
3. [Empire Tips and Tricks](https://enigma0x3.net/2015/08/26/empire-tips-and-tricks/).
4. [Empire Series Mady City Hacker](https://madcityhacker.com/2018/09/29/empire-part-1-setting-up-a-listener/)

#### DigiSpark (Bad USB)
1. [DigiSpark Payloads](https://github.com/kbeflo/digispark-payloads).

