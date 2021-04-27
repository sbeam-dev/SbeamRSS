# SbeamRSS - Simple, elegant RSS reader
[![CodeFactor](https://www.codefactor.io/repository/github/sbeam-dev/sbeamrss/badge)](https://www.codefactor.io/repository/github/sbeam-dev/sbeamrss)![releases](https://img.shields.io/github/v/release/sbeam-dev/SbeamRSS?include_prereleases)

An Android RSS reader based on flutter.

In early development state.

Notice: We develop the app in our free time. Updates can be slow, but as we daily drive the app, we will keep it alive.

[Documentation](https://github.com/sbeam-dev/SbeamRSS/wiki/)

[中文介绍](https://sbeam.dev/2020/09/06/sbeamrss/)

## We launched at Play Store!

<a href='https://play.google.com/store/apps/details?id=dev.sbeam.rss&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' height=80/></a>

Alpha testing versions will be released in the github release page.

## Features

The app works fully offline(uses local device to pull updates and store data). In the future, cloud integration and push notifications might be implemented(*low priority*).

### To-dos

  - [x] Subscription source management
  - [x] Feed pull and storage
  - [x] UI for reading feed articles
  - [x] Frontend refinement and theming
  - [x] Put on Beta testing
  - [ ] Feed filtering (categories)
  - [x] Search articles (need improvements)
  - [x] Favorite articles
  - [x] UI&Font optimizations
  - [x] OPML import&export
  - [ ] Backup and restore
  - [ ] Better CJK font
  - [ ] Optimization for tablets
  - [ ] Better reading page performance

## Known Defects

+ Text can't be selected in reading page. Waiting for the flutter_html package to implement this feature.
+ The Scrollbar in reading page can't be updated instantly. It's a workaround to avoid severe performance issue.
+ If you have other suggestions, feel free to open an issue!

## Building

We use the latest beta branch of flutter(2.2). The used pub packages can be found in `pubspecs.yaml`. Pull requests are welcomed.