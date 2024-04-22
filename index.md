---
layout: default
title: Home
---

# Louis Nass

## About me:

My name is Louis Nass, I am a Research Assistant pursuing my Doctorate in Applied Mathematics at Tulane University (Roll wave!).

I am from Wisconsin and received my Bachelor's of Science in Mathematics at Marquette University (Ring out ahoya!).

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

Find me on:
* [GitHub](https://github.com/louisnass/louisnass.github.io/)
* [LinkedIn](https://www.linkedin.com/in/louis-nass-5362482b5/)

![MeAndAnna](https://raw.githubusercontent.com/louisnass/louisnass.github.io/master/MeAndAnna.png)

{% for post in site.posts %}
- [{{ post.title }}]({{ post.url }})
{% endfor %}
