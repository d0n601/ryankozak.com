+++
title = 'How I Do My Ctf Writeups'
date = 2019-08-11T04:38:37-07:00
hideToc = true
description = "Workflow for creating CTF writeups using Markdown, Pandoc, and LaTeX to generate both PDF and blog post formats efficiently."
+++
I've been playing a lot of CTFs this summer. My goal was obviously to brush up on my offensive security skills, but also to practice doing security writeups. I wanted to post the writeups on my blog and publish them as PDFs. Writing the whole thing in a document editor is miserable, I hate using document editors. Then doing the whole thing again as a blog post just means even more work. So, here's the workflow I developed this summer to do my writeups once using markdown, and easily publish in both formats.

Here is the github repo for the my [HTB Writeup Template](https://github.com/d0n601/HTB_Writeup-Template).

## Installation on Ubuntu
*Note: If you use Debian or Mint it may work but your mileage here might vary.*

1. Install [Latex](https://www.latex-project.org/) via `sudo apt-get install texlive`.
2. Install [Pandoc](https://pandoc.org/) via `sudo apt-get install pandoc`.
3. Install the [Pandoc Latex Template](https://github.com/Wandmalfarbe/pandoc-latex-template)
   * Download the latest version of the Eisvogel template from the [release page](https://github.com/Wandmalfarbe/pandoc-latex-template/releases/latest).
   * Extract the `tar.gz` archive and open the folder.
   * Create a pandoc templates folder if it doesn't exist at `~/.pandoc/templates/`.
   * Move the template `eisvogel.tex` to your pandoc templates folder and rename the file to `eisvogel.latex`.
4. Make sure you have [PDFtk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) installed via `sudo apt-get install pdftk`.


## Usage
Initially I publish my writeups as a password protected pdf, the password set to the root flag for the box. After the box is retired, I post the writeup on my Jekyll site.

Here's the directory structure for my writeup [template](https://github.com/d0n601/HTB_Writeup-Template).

```
HTB_Writeup-TEMPLATE
│   HTB_Writeup-TEMPLATE-d0n601.md   
│
└───pdf
│   │   HTB_Writeup-TEMPLATE-d0n601.pdf
│   │
│   └───protected
│       │   HTB_Writeup-TEMPLATE-d0n601.pdf
│   
└───images
│       │   badge.png
│       │   someotherimage.png
│       │   ...
```

### Markdown for pdf
In order to generate a pdf from markdown using pandoc we must format the header correctly. The header for my template is as follows.

```
---
title: "Hack The Box - BOX NAME HERE"
author: Ryan Kozak
date: "2019-08-11"
subject: "CTF Writeup Template"
keywords: [HTB, CTF, Hack The Box, Security]
lang: "en"
titlepage: true
titlepage-text-color: "FFFFFF"
titlepage-color: "0c0d0e"
titlepage-rule-color: "8ac53e"
logo: "./images/badge.png"
logo-width: 350
...
```

See my example markdown [here](https://raw.githubusercontent.com/d0n601/HTB_Writeup-Template/master/HTB_Writeup-TEMPLATE-d0n601.md?token=ACEL5KMOWDBZXMQ7QT2OK725LGTY4).

Once the writeup is complete, or you're just looking to build it to see how it's looking as a pdf, issue the following command from your writeup directory.

`pandoc --latex-engine=xelatex ./HTB_Writeup-TEMPLATE-d0n601.md -o ./pdf/HTB_Writeup-TEMPLATE-d0n601.pdf --from markdown --template eisvogel --listings`

See the full pdf example [here](https://github.com/d0n601/HTB_Writeup-Template/blob/master/pdf/HTB_Writeup-TEMPLATE-d0n601.pdf).


### Password Protect pdf
Once the writeup is complete and ready to publish, it should be protected with the root flag so it doesn't violate [Hack The Box](https://hackthebox.eu) rules, allow people to cheat, and generally spoil the fun.

To password protect the pdf I use `pdftk`. From the root folder of the writup directory issue the following command.

`pdftk ./pdf/HTB_Writeup-TEMPLATE-d0n601.pdf output ./pdf/protected/HTB_Writeup-TEMPLATE-d0n601.pdf user_pw v5gw5zkh8rr3vmye7p4ka`

Now a password protected pdf will appear in the `/pdf/protected` directory.

See the password protected pdf example [here](https://github.com/d0n601/HTB_Writeup-Template/blob/master/pdf/protected/HTB_Writeup-TEMPLATE-d0n601.pdf).

### Jekyll Blog
When the writeup is ready to be made public there are a few adjustments to be made to the markdown in order to make it a Jekyll post. The first thing that must change is the header. Remove the older header used by pandoc and replace it with something like the following.

```
---
title: "Hack The Box - Example Writeup"
author: Ryan Kozak
layout: post
description: Here is an example post of a Hack The Box writeup.
permalink: /hack-the-box-example-writeup/
categories:
  - Random
tags:
  - pandoc
  - markdown
  - latex
  - ctf
---
```


The next change after that is placing the images into the blog's image directory redoing the links to reference wherever they're at on your Jekyll site. Lastly you need to modify the captions, because they're specific to pandoc and don't look pretty in markdown.

So this which was an image and caption on the pdf,

```
![My Website](./images/ryankozak.com.png)
\ **Figure 1:** My Website
```

Becomes this on the Jekyll post.

```
![My Website](/wp-content/uploads/2019/08/template/images/ryankozak.com.png)
**Figure 1:** My Website
```

Now we're done. Here is the example writeup from the pdf you've seen converted to a blog post [https://ryankozak.com/hack-the-box-example-writeup/](https://ryankozak.com/hack-the-box-example-writeup/)


For more information on modifying the template, please see the [Pandoc Latex Template's Repo](https://github.com/Wandmalfarbe/pandoc-latex-template). Its usage section will tell you all about the custom template variables, as well as provide you with some examples.

# Conclusion
The easier you can make doing a writeup, generally the more prone you'll be to actually do them. I've found this workflow to be very efficient and enjoyable.
