---
type: page
permalink: /
layout: single
classes: landing
title: ""
---

<section class="home-hero">
  <p class="eyebrow">Reproducible Research Oxford (RROx)</p>
  <h1>Advancing open research across the University of Oxford</h1>
  <p>Welcome to RROx — pronounced “rocks”! We are a University-wide initiative focused on spreading a culture of reproducibility across Oxford. RROx engages and supports the community by developing and encouraging the growth of reproducible research and enabling researchers and students to conduct work that is rigorous, open, and shareable.</p>
  <p>We coordinate events and initiatives throughout the year, provide training opportunities, highlight resources, and collaborate with Local Network Leads embedded across departments. If you are based in Oxford and interested in open research and research reproducibility, do <a href="{{ '/get-involved/' | relative_url }}">get in touch</a>!</p>
</section>

<div class="home-card-grid">
  {% for card in site.data.home_cards %}
  <article class="home-card">
    <a href="{{ card.url | relative_url }}">
      <div class="home-card__image" style="background-image: url('{{ card.image | relative_url }}');"></div>
      <div class="home-card__body">
        <h2>{{ card.title }}</h2>
        <p>{{ card.description }}</p>
        <span class="home-card__link">Explore {{ card.title | downcase }} →</span>
      </div>
    </a>
  </article>
  {% endfor %}
</div>
