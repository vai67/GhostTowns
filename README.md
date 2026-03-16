# GhostTowns

**Apple Swift Student Challenge 2026 Submission**

GhostTowns uses your GPS coordinates to identify the Indigenous nation whose ancestral territory you're currently on. Open the app, allow location access, and the territory name, associated treaty, removal policy, and historical year appear automatically.

---

## Background

I study Geographic Information Science at UIUC. GIS encodes land as data: parcels, boundaries, ownership. After two years of coursework learning to map the US in detail, I noticed that standard datasets don't include the histories of the territories those boundaries replaced.

In GIS, "ghost features" are records that existed in a dataset but were later removed. This app tries to surface that missing layer.

---

## Features

- **Real-time territory identification** via a single GPS lookup through CoreLocation. Location services are released immediately after the coordinate is retrieved.
- **Historical context** for each territory: treaty name, removal policy, and year
- **Offline-first architecture** with all nation data, timelines, and citations bundled locally. Only the territory query needs a network connection.
- **Procedural Canvas rendering** for the map background, so it scales to any device without external image assets

**Accessibility**
- Reduce Motion support: the animated land-transition sequence converts to instant state changes when enabled
- WCAG AA contrast on all text and earth-tone palettes; Dynamic Type supported throughout
- The GPS lookup works independently of the visual scanner UI, so the core functionality is accessible regardless of how you interact with the app

---

## Tech Stack

| Technology | Role |
|---|---|
| Swift / SwiftUI | UI, NavigationStack, Canvas rendering |
| CoreLocation | Single-use GPS coordinate lookup |
| Native Land Digital API | Indigenous territory boundary data |
| Canvas (procedural) | Resolution-independent map rendering |

**Data sources:** [Native Land Digital](https://native-land.ca) (CC BY 4.0, Indigenous-led), Bureau of Indian Affairs, U.S. Census Bureau, National Archives, Smithsonian NMAI

---

## How to Run

1. Clone the repo
2. Open `GhostTowns.swiftpm` in **Xcode 15+** or the **Swift Playgrounds app** on iPad or Mac
3. Run on a physical device or simulator with location enabled
4. Allow location access when prompted

The territory lookup requires an internet connection. Everything else works offline.

---

## About

Vaibhavi Srivastava, CS + GIS @ UIUC  
[LinkedIn](https://linkedin.com/in/vaibhavi-srivastava) · [GitHub](https://github.com/vaibhavi-srivastava)

---

*Territory boundary data from [Native Land Digital](https://native-land.ca) under Creative Commons Attribution 4.0.*
