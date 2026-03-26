# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A single-file interactive business directory map for Rogue River, Oregon. Built for the Rogue River Chamber of Commerce. No build system, no dependencies to install — the file opens directly in any browser.

**Active file:** `rogue_river_map_v3_4.html`
**Archived versions:** `OLD/` folder (do not edit these)

## Running the Map

Open `rogue_river_map_v3_4.html` directly in a browser. No server required. For local development, a simple server avoids any CORS quirks:

```bash
python3 -m http.server 8000
# then open http://localhost:8000/rogue_river_map_v3_4.html
```

The logo is base64-embedded in a second `<script>` tag at the bottom of the file — it does not load from `RR-logo.png` at runtime.

## Architecture

Everything lives in one HTML file structured as: CSS → HTML → Leaflet JS (CDN) → app JS → base64 logo script.

**Data layer** — `BUSINESSES` array (line ~345): each entry is a plain JS object with `name`, `address`, `city`, `phone`, `email`, `contact`, `cat`, `membership`, `lat`, `lng`, `pinEmoji`, and optionally `url` and `img`. This is the source of truth; `rogue_river_businesses.csv` is a looser reference copy and may not be fully in sync.

**Category system** — `CATEGORIES` object maps category keys (`food`, `shopping`, `health`, `services`, `finance`, `attractions`, `auto`, `community`, `govt`) to `{ label, color, emoji }`. `CAT_IMAGES` maps the same keys to Unsplash fallback hero images shown in the modal.

**Rendering pipeline:**
1. `renderMarkers()` — clears all map markers, re-filters `BUSINESSES` against `activeFilters` (Set) and `searchQuery`, creates a Leaflet marker per visible business using `createPin()`, pushes to `markers[]`
2. `buildFilters()` — rebuilds the filter pill bar from `CATEGORIES`; toggling a pill updates `activeFilters`/`allActive` then calls `renderMarkers()`
3. `openModal(biz)` — populates and shows the modal overlay for a clicked business; sets `currentBiz` used by `getDirections()` and `openWebsite()`

**Key state variables:** `markers[]`, `activeFilters` (Set), `allActive` (bool), `searchQuery` (string), `currentBiz` (object|null).

**Map config:** CARTO Voyager tiles, center `[42.4332, -123.1690]`, default zoom 16, min 13 / max 19. Custom SVG pins are generated inline by `createPin()` — pin size is 34px normal, 42px highlighted.

## Adding or Editing a Business

Add an object to the `BUSINESSES` array. Required fields: `name`, `address`, `city`, `cat`, `lat`, `lng`. Optional but common: `phone`, `email`, `contact`, `membership` (`"Basic"` | `"President's Circle"` | `"New"`), `url`, `pinEmoji`, `img`.

To add a new category, add entries to both `CATEGORIES` and `CAT_IMAGES`.

## Versioning Convention

Save new versions by copying the file with an incremented suffix (e.g., `v3_5`). Move the old version to `OLD/`. Never edit files in `OLD/`.
