---
layout: default
title: Home
---

# Louis Nass

## About me:

My name is Louis Nass, I am a research assistant pursuing my doctorate in Applied Mathematics at Tulane University.

I am from Wisconsin and received my Bachelor's in Science at Marquette University (Ring out ahoya!)

My academic interests include a variety of topics such as:
* Ordinary/partial differential equations
* Bayesian estimation
* Linear models
* Data analysis
* Sports analytics
* Fluid dynamics

Other interests of mine:
* Sports (Packers, Marquette basketball, Brewers, Bucks)
* Food (all things New Orleans!)
* Travel (Argentina, UK, Iceland, Mexico and hopefully more stops!)

{% for post in site.posts %}
- [{{ post.title }}]({{ post.url }})
{% endfor %}
