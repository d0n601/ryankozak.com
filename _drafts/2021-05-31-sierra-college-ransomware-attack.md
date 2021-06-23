---
title: "Sierra College Ransomware Attack"
author: Ryan Kozak
layout: post
permalink: /sierra-college-ransomware-attack/
categories:
  - Security
tags:
  - Ransomware
  - Sierra College
  - Malware
---

![Temporary Website for Sierra College](/wp-content/uploads/2021/05/ransomware/tempsite.png)

This post is mostly just me musing on a situation that hits close to home. My partner Brianna is transferring from Sierra this semester, and has worked her ass off to be accepted to U.C. Berkely, U.C. Davis, and U.C.S.B, the latter two on full rides. After losing her father earlier on in the semester, this is what she has to deal with during finals week and beyond. I don't mean to shame Sierra by posting this, but the stress that this situation puts on students is immense. The stress is increased significantly more for those transferring out, as universities are expecting grade reports and transcripts. As a security professional I cannot help but wonder what has been and what is currently going on behind the scenes over there.


## Background  
On the evening of May 19th 2021 Sierra College notified students and faculty of some technical difficulties taking place. By the next day, Sierra College had posted an announcement on a temporary site hosted at `academics.sierracollege.edu` stating that they'd been attacked by ransomware.  

> We are currently experiencing technical difficulties on the Sierra College website and some other online systems.  This is the result of an external ransomware attack on our systems.  We are working with law enforcement and third-party cybersecurity and forensic experts to investigate this incident, assess the potential impact, and bring our systems back online [3](https://academics.sierracollege.edu/sierra-college).  

While it remains unclear as to when the systems were compromised, the payloads were detonated during finals week. It's my assumption that the timing of this attack was meant to maximize the potential of Sierra College paying the ransom.


## More Unknowns Than Knowns  
At the moment Sierra College has released very little information about the attack or their investigation into it. Most importantly, they've not released the type of ransomware infecting their systems. Do they know what they were hit with? Do they know if data has been exfiltrated? Is not paying the ransom going to result in Brianna and other students' personal information being leaked?


Did Sierra have any incident response plan in place? Did they ever consider things like "mean time to recover", "mean time to restore"?  
![IR Plan Steps](/wp-content/uploads/2021/05/ransomware/IR-plan-steps.png)
*Where are we again???*


Certain types of ransomware and the groups that operate them are known to leak stolen data if they're not paid their ransom, and students' personal information would presumably be at risk if this were the case.

> Ransomware groups continue to exfiltrate data during intrusions, mimicking the Maze ransomware group’s tactic of publishing stolen victim data, which made headlines in late 2019. [2](https://www.cisecurity.org/blog/ransomware-the-data-exfiltration-and-double-extortion-trends/)


It's been almost three weeks since the attack has taken place and the majority of systems are still unavailable. This means transcripts, registration, grading, even things like downloading a pdf of the campus map, are all impossible.

![Registration Page](/wp-content/uploads/2021/05/ransomware/registrationfail.png)
*Temporary Summer and Fall Class Schedule Prints a Stack Trace*


## Ransomware in Education  
Ransomware targeting educational institutions isn't an uncommon occurrence [4](https://www.wbtv.com/2021/02/12/central-piedmont-community-college-experiences-ransomware-attack/), [5](https://www.deseret.com/utah/2020/8/21/21396174/cyber-swindlers-take-university-of-utah-for-nearly-500k-in-ransomware-attack), [6]((https://www.sfchronicle.com/crime/article/FBI-investigating-cyberattack-that-led-UCSF-to-15377822.php)). Community colleges and K-12 institutions simply cannot afford to employ security professionals. This is even true of a large portion of universities in existence. The lack of ability to fund proper security practices does not mean these schools don't heavily rely on technology to function (even pre-COVID), which makes them easy targets. Unfortunately I don't know a good solution to this conundrum. Expecting school districts to employ even a small staff of security professionals would cost them roughly half a million dollars a year, which is unreasonable given their budgets.

## References
1. [Sierra College Experiencing External Ransomware Attack During Finals Week](https://sacramento.cbslocal.com/2021/05/20/sierra-college-ransomware-attack-finals-week/)
2. [Ransomware: The Data Exfiltration and Double Extortion Trends](https://www.cisecurity.org/blog/ransomware-the-data-exfiltration-and-double-extortion-trends/)
3. [Sierra College Temporary Information Site](https://academics.sierracollege.edu/sierra-college)
4. [Central Piedmont Community College experiences ransomware attack](https://www.wbtv.com/2021/02/12/central-piedmont-community-college-experiences-ransomware-attack/)
5. [Cyber swindlers take University of Utah for nearly $500K in ransomware attack](https://www.deseret.com/utah/2020/8/21/21396174/cyber-swindlers-take-university-of-utah-for-nearly-500k-in-ransomware-attack)
6. [FBI investigating cyberattack that led UCSF to pay $1.14 million in ransom](https://www.sfchronicle.com/crime/article/FBI-investigating-cyberattack-that-led-UCSF-to-15377822.php)
