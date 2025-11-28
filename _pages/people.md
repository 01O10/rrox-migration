---
title: "People"
description: Meet the RROx team
permalink: /people/
type: page
---

In line with its cross-disciplinary remit, RROx is represented by members from all four academic divisions of the University of Oxford. Our Local Network Leads (LNLs) champion open and reproducible research within their departments and connect the wider community to training, events, and initiatives. We also collaborate with liaison points across professional services and colleges, and continue to celebrate past team members who helped establish RROx.

## Local Network Leads

{% assign leads = site.team | where: "current", true | sort_natural: "lastname" %}
<div class="home-card-grid">
{% for person in leads %}
  {% assign photo = person.image_path %}
  {% if photo == nil and person.image_src %}
    {% assign photo = '/assets/images/team/' | append: person.image_src %}
  {% endif %}
  <article class="home-card">
    <div class="home-card__image" style="background-image: url('{{ photo | relative_url }}');"></div>
    <div class="home-card__body">
      <h2>{{ person.firstname }} {{ person.lastname }}</h2>
      <p class="event-summary__meta">{{ person.position }}{% if person.affiliations %} · {{ person.affiliations | join: ", " }}{% endif %}</p>
      <p>{{ person.description }}</p>
    </div>
  </article>
{% endfor %}
</div>

## Past members

We are grateful to everyone who has helped build the RROx community. A selection of past team members is listed below.

<div class="event-summary-list">
{% assign past_people = site.past_team | sort_natural: "lastname" %}
{% for person in past_people %}
  <article class="event-summary">
    <h3>{{ person.firstname }} {{ person.lastname }}</h3>
    {% if person.position %}
      <p class="event-summary__meta">{{ person.position }}</p>
    {% endif %}
    <p>{{ person.content | strip_html | truncate: 200 }}</p>
  </article>
{% endfor %}
</div>
