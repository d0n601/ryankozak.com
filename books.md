---
layout: page
title: Book List
permalink: /books/
sidebar_link: true
pagination: 
  enabled: true
  collection: books
  permalink: /page:num/
---

<p>
	{{ site.baseurl }}
    	This page is a simple archive of the books I’ve read, starting in 2013, excluding technical books. This list is an idea that I’ve seen done a few times before, and I’ve always enjoyed going through what other people have read. Obviously if their interests are similar, it encourages me towards certain things I may not have otherwise seen.
</p>

<p>
		I’m trying to include includes some basic notes I’ve jotted down while reading. A goal of this section is that I become a bit more diligent in taking notes and organizing my thoughts while I read.
</p>

<h2>Books I've Read</h2>
  {% if paginator.previous_page %}
    {% include pagination-newer.html %}
  {% endif %}

<div class="posts">
  
  {% assign books = site.books | sort: "date" | reverse %}

  {% for book in paginator.posts %}
  <div class="post-teaser book-teaser">
  	<div>
		  <a href="{{ book.url | prepend: site.baseurl }}">
  			    <img class="book-cover book-cover-teaser" src="/wp-content/covers/{{ book.cover }}">
                    </a>
  		</div>
		<div class="book_info">
		  	<div class="book_meta">
			  	<h3><em><a href="{{ book.url | prepend: site.baseurl }}">{{ book.title }}</a></em></h3>
			  	<p>Author: {{ book.author }}</p>
				<p>Read: {{ book.date | date_to_string }}</p> 
			  	<a class="button" href="{{ book.url | prepend: site.baseurl }}">Read full notes</a>
		  	</div>
	  	</div>

  	</div>
  {% endfor %}

  {% if paginator.next_page %}
    {% include pagination-older.html %}
  {% endif %}
 </div>