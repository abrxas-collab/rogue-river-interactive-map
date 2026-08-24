# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A single-file interactive business directory map for Rogue River, Oregon. Built for the Rogue River Chamber of Commerce. No build system, no dependencies to install — the file opens directly in any browser.

**Repo location:** `/Users/Pan/Downloads/Rogue River Interactive Map /RR Map files`
This is the only working copy. Do not create or work from unzipped copies of the
GitHub download elsewhere in Downloads — one such stale folder caused edits to be
made against a non-repo and was removed on 2026-08-23.

**Active file:** `rogue_river_map_v3_4.html` (never rename — Wix embeds it by name)
**Archived versions:** `OLD/` folder (do not edit these)

**Jeff maintains this himself month to month.** See `MAINTENANCE.md` for the
plain-language version of the routine workflow. Keep it accurate when the data
shape or publishing steps change — it is written for a non-programmer.

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

**Category system** — `CATEGORIES` object maps category keys (`food`, `shopping`, `health`, `services`, `finance`, `attractions`, `community`, `govt`, `homebiz`) to `{ label, color, icon }` where `icon` is an inline SVG path string. `CAT_IMAGES` maps the same keys to Unsplash fallback hero images shown in the modal. `homebiz` holds 15 entries. `attractions` has no primary-category entries; it is reached only via `cat2` (see below).

**Rendering pipeline:**
1. `renderMarkers()` — clears all map markers, re-filters `BUSINESSES` against `activeFilters` (Set) and `searchQuery`, creates a Leaflet marker per visible business using `createPin()`, pushes to `markers[]`
2. `buildFilters()` — rebuilds the filter pill bar from `CATEGORIES`; toggling a pill updates `activeFilters`/`allActive` then calls `renderMarkers()`
3. `openModal(biz)` — populates and shows the modal overlay for a clicked business; sets `currentBiz` used by `getDirections()` and `openWebsite()`

**Key state variables:** `markers[]`, `activeFilters` (Set), `allActive` (bool), `searchQuery` (string), `currentBiz` (object|null).

**Map config:** CARTO Voyager tiles, center `[42.4332, -123.1690]`, default zoom 16, min 13 / max 19. Custom SVG pins are generated inline by `createPin()` — pin size is 34px normal, 42px highlighted.

## Adding or Editing a Business

Add an object to the `BUSINESSES` array. Required fields: `name`, `address`, `city`, `cat`, `lat`, `lng`. Optional but common: `phone`, `email`, `contact`, `membership` (`"Basic"` | `"President's Circle"` | `"New"`), `url`, `pinEmoji`, `img`.

A business may also carry `cat2` for a secondary category — it then appears under both filters and shows dual badges in the list and modal. Currently only Taproots Boutique uses this (`shopping` + `attractions`).

To add a new category, add entries to both `CATEGORIES` and `CAT_IMAGES`.

## Git Workflow

**Commit and push after every logical unit of work.** This is the primary way versions are preserved — do not rely on file copies.

- Commit after each distinct change (adding businesses, adjusting categories, UI updates, etc.)
- Always push to `origin main` immediately after committing
- Write clear, descriptive commit messages: what changed and why, not just "update file"
- The remote is `https://github.com/abrxas-collab/rogue-river-interactive-map`

```bash
git add rogue_river_map_v3_4.html
git commit -m "Short description of what changed"
export PATH="/opt/homebrew/bin:$PATH" && git push
```

The `OLD/` folder is gitignored — git history replaces it. Never copy files into `OLD/` as a substitute for committing.
