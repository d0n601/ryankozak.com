+++
title = 'Plenty of Phish Trust and Gtlds'
date = 2020-01-28T18:50:47-07:00
hideToc = true
+++
# Introduction  
For some time now, I've expected the introduction of new top level domains to confuse the general public. When users are confused, they're more easily manipulated, making them more likely to fall for age old tricks like phishing attacks. 


## New gTLDs
It's been almost 9 years since the announcement below from ICANN came out regarding new top level domains, meaning there would be many more options than the traditional `.com`, `.org`, `.net`, `.biz`, `.gov`, `.edu`, etc.

>ICANN will soon begin a global campaign to tell the world about this dramatic change in Internet names and to raise awareness of the opportunities afforded by new gTLDs. Applications for new gTLDs will be accepted from 12 January 2012 to 12 April 2012 [source](https://www.icann.org/news/announcement-2011-06-20-en).


Now we're in the year 2020, and I'd say that the nontechnical community still does not understand how domain names work, or what new gTLDs even are. Many new domain extensions have been released, but how businesses and individuals are choosing to use them is still not very clear. Are businesses supposed to use `.support` for their help desk, and `.careers` or `.jobs` for their hiring pages? Or are they just supposed to use `.com` still?


To get an idea of what extensions are available, take a look at [Wikipedia's List of Internet Top Level Domains](https://en.wikipedia.org/wiki/List_of_Internet_top-level_domains), primarily the ICANN-era generic top-level domains. There you'll find the English language domains listed alphabetically in tables indicating their target market, restrictions, registry, etc.  

![Domain Table](/posts/images/plenty-of-phish-trust-and-gtlds/domain_table.png)  
**Figure 1**: Partial table of English language generic top-level domains beginning with 'C'.




# Traditional Phishing  
When educating users about what to look for in order to identify a phishing attack, things like SSL certificates and valid domain names have been at the top of the list. In the past it wasn't typical for phishing sites to pay to obtain an SSL certificate, so we told users to check for the lock in the url bar. It was also common for phishing sites to use misspellings, or modified versions (url padding) of company domain names with the `.com` extension in order to gain a user's trust. This means things like changing `wellsfargo` to `wells-fargo`, or `wells-fargo-bank`. In certain instances the url bar on mobile sites is too short to even display an entire domain name, which creates additional problems.


## TLDs  
According to [Phish Labs](https://phishlabs.com) the majority of phishing sites are compromised hosts, and thus use valid domains. This accounts for the majority of phishing domains still being `.com` extensions. Of course, if a domain is compromised then there isn't much to do from a user's perspective, as the site will likely appear valid in every way. 

>Historically, most phishing sites have been hosted on legitimate domains that are compromised, rather than domains specifically registered by phishers. As a result, the breakdown of TLDs used for phishing sites has closely mirrored that of the general website population [source](https://info.phishlabs.com/hubfs/2019%20PTI%20Report/2019%20Phishing%20Trends%20and%20Intelligence%20Report.pdf).



## SSL Certificates
With the introduction of free certificate authorities such as [LetsEncrypt](https://letsencrypt.org/), the lock in a user's browser now only instills in them a false confidence. Phishing sites no longer need to pay for this certificate, and there is no protection. Users need to be aware that the lock means an encrypted connection to a site, not that the site itself is valid or secure in any way. The majority of users do not know how to check the certificate authority, and don't know the difference between [LetsEncrypt](https://letsencrypt.org/) and [DigiCert](https://www.digicert.com/). 

>In 2018 threat actors continued to abuse SSL certificates to bypass browser filtering and add credibility to phishing sites [source](https://info.phishlabs.com/hubfs/2019%20PTI%20Report/2019%20Phishing%20Trends%20and%20Intelligence%20Report.pdf).

![DigiCert Price](/posts/images/plenty-of-phish-trust-and-gtlds/digicert_price.png)  
**Figure 2**: DigiCert's cheapest certificate is $207, a big investment for a throwaway phishing site.  

![LetsEncrypt Price](/posts/images/plenty-of-phish-trust-and-gtlds/letsencrypt_price.png)  
**Figure 3**: LetsEncrypt is free, which is great for privacy overall, but SSL certs do not validate a site's identity. 



# Modern Phishing  
New forms of phishing attacks have emerged as a result of all these new gTLD's. These extensions can be used to gather specific information from victims. A few hypothetical examples can be found below.

## gTLD Phishing  

>The number of phishing sites observed on gTLDs more than doubled last year, and their share of total phishing volume rose from 5% to 8% [source](https://info.phishlabs.com/hubfs/2019%20PTI%20Report/2019%20Phishing%20Trends%20and%20Intelligence%20Report.pdf).


## Plausible Attack Scenarios  
The numerous amount of new domain extensions allow for a lot of creativity now when creating a phishing campaign. There are many industry specific domains that can be purchased to manipulate users in a particular industry (see World Cup example below). I can also imagine certain extensions being used across various industries to steal sensitive information. 


### Identity Theft
I see the extensions `.careers`, and `.jobs` as being particularly vulnerable to collect information by creating phishing sites targeting job applicants for a particular business. 

### Credential Harvesting
It seems also that `.security`, `.shipping`, `.support`, `.review`, `.vote` and `.legal` could all be used to manipulate users into providing their account credentials. For instance, a spear phishing campaign using the `.legal` extension notifying users that they must login to their account and accept a new terms of service agreement in order to continue using a particular site. The `.shipping` extension could be used to trick users into providing their account credentials thinking that they're logging into a site to track an order. The number of scams that can be run is limited only by one's imagination.

### Anonymous Domain Registration and Hosting  
For the purposes of this article I think it's important to point out that domains can be registered, and hosting can be purchased, completely anonymously by using services such as [Njalla](https://njal.la). [Njalla](https://njal.la) is accessible anonymously via the [Tor Network](https://www.torproject.org/) at [njalladnspotetti.onion](njalladnspotetti.onion), and individuals can pay for these services anonymously using crypto currencies. This means the owner of a site is difficult or even impossible to determine, which is ideal for any criminal.  

![Njalla](/posts/images/plenty-of-phish-trust-and-gtlds/njalla.png)  
**Figure 4:** Njalla offers anonymous domain registration and hosting plans.  



## World Cup Example  
There have been instances of gTLD's being used for industry specific phishing attacks already. One example can be found during the 2018 World Cup. Domains specific to the soccer industry, and the World Cup itself, were being registered and used to phish for sensitive information.

>Well-designed website interfaces featuring stolen logos are created to dupe users into sharing personal and financial information. To seem more credible, cybercriminals are registering domain names with keywords like `world`, `worldcup`, `Russia`, and `FIFA` [source](https://www.eurodns.com/blog/top-level-domains-cybercriminals).



# Remediation

## For Users  
There are a couple things that the technically literate crowd can use to help easily help identify a phishing site from a legitimate one. Educating the masses on these techniques may be imperative as new domain extensions become more common in the future.

### Whois
If users are educated enough to utilize [whois](https://www.whois.com/whois) info in order to determine who registered a particular domain, they may find that the entity who registered the `.careers` extension is not the same entity that registered the `.com` extension, and this is a major red flag.

### Certificate Authority 
As I previously mentioned, if users are educated enough to determine who issued the site's SSL certificate, they may find that the `.careers` extension is LetsEncrypt, while the `.com` is [DigiCert](https://www.digicert.com/). Any major entity using LetsEncrypt would be a major red flag in my eyes.

## For Businesses   
You may be wondering, how a company can register all extensions related to their brand to protect themselves from such an attack?  Register your trademark with the [Trademark Clearing House](http://trademark-clearinghouse.com/). For $150 per trademark a business is given some significant protections.

* Registration and verification of the trademark record
* Sunrise services for all new gTLD Sunrise periods, not just one
* Trademark claims services for all new gTLDs, not just one
* Linking up to 10 domain name labels to the registration
* Ongoing Notifications 
* [source](http://trademark-clearinghouse.com/content/trademark-clearinghouse-fees) 


# Conclusion  
The implementation of so many new domain name extensions opens up the potential for a lot of creative phishing campaigns. The world is still getting used to all these new domain names, and the way that they're being put into practice is still not clearly defined. For instance, [nike.shoes](https://nike.shoes) simply redirects to [nike.com](https://nike.com), and [peets.coffee](https://peets.coffee) redirects to [peets.com](https://peets.com). However, I believe the intent of these new domain extensions is not to have them all redirect to `.com`. The intent is that industry specific domains will be used within particular industries, and extensions like `.careers` and `.support` will be used by different departments of larger companies for specific use cases. None the less, even though it's been 9 years now this is all still very new. Things are still rather confusing for businesses and users alike. When there is confusion, there is room for exploitation. I've been anticipating an exploitation of this confusion for a long time years now, we've seen it happen already, and I expect it to happen a whole lot more before things get figured out.

