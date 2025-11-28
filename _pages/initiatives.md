---
title: "Initiatives"
description: Ongoing projects supported by RROx
permalink: /initiatives/
type: page
---

We support initiatives that bring together researchers, professional services, and community partners to build a sustainable culture of reproducibility at Oxford. Explore the highlights below.

{% assign initiatives = site.initiatives | where: "show_on_site", true %}
<div class="home-card-grid">
{% for initiative in initiatives %}
  <article class="home-card">
    <a href="{{ initiative.cta_url | relative_url }}">
      <div class="home-card__image" style="background-image: url('{{ initiative.image | relative_url }}');"></div>
      <div class="home-card__body">
        <h2>{{ initiative.title }}</h2>
        <p>{{ initiative.summary }}</p>
        {% if initiative.cta_text %}
        <span class="home-card__link">{{ initiative.cta_text }} →</span>
        {% endif %}
      </div>
    </a>
  </article>
{% endfor %}
</div>

Need to talk to us about a new activity? <a href="{{ '/get-involved/' | relative_url }}">Get in touch</a> so we can help you connect with the right people and resources.
