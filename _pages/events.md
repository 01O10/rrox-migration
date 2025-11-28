---
title: "Events"
description: Reproducibility events in Oxford and beyond
type: page
permalink: /events/
---

RROx hosts and supports events throughout the year that champion open, transparent, and reproducible research. For each activity, please follow our [Code of Conduct]({{ '/misc/RROxCoC.pdf' | relative_url }}) which builds on the [UKRN Code of Conduct](https://www.ukrn.org/code-of-conduct/).

## Upcoming events

{% assign upcoming = site.events | where: "show_on_site", true | where: "status", "upcoming" | sort: "start" %}
{% if upcoming.size > 0 %}
<div class="event-summary-list">
  {% for event in upcoming %}
    {% include event_summary.html event=event %}
  {% endfor %}
</div>
{% else %}
<p>We will publish our next set of dates soon — follow us on social media or join the mailing list to hear first.</p>
{% endif %}

## Past events

{% assign past = site.events | where: "show_on_site", true | where: "status", "past" | sort: "start" | reverse %}
{% if past.size > 0 %}
  {% assign years = past | group_by_exp: "event", "event.start | date: '%Y'" %}
  {% for year in years %}
  <h3>{{ year.name }}</h3>
  <div class="event-summary-list">
    {% for event in year.items %}
      {% include event_summary.html event=event %}
    {% endfor %}
  </div>
  {% endfor %}
{% endif %}

You can also browse our historic archive of activities at [rroxford.github.io/events](https://rroxford.github.io/events/).
