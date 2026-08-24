# Map Maintenance — Do-It-Yourself Guide

Everything you need for routine updates to the Rogue River business map.
No coding background required. Read the section you need; ignore the rest.

---

## 0. The one rule

**Work in this folder:**

    /Users/Pan/Downloads/Rogue River Interactive Map /RR Map files

There is a look-alike folder called `rogue-river-interactive-map-main`. It is a
stale copy from an old zip download. It is not connected to GitHub. Edits made
there go nowhere. Ignore it.

The file you edit is **`rogue_river_map_v3_4.html`**. Never rename it — the
Chamber's Wix site embeds it by that exact name.

---

## 1. How publishing works

    edit the HTML  →  commit  →  push  →  GitHub Pages rebuilds  →  Wix shows it

Changes go live a minute or two after you push. Nothing else to click.

---

## 2. Editing a business (the 90% case)

All businesses live in a list starting at **line 519**, marked `const BUSINESSES = [`.
They're grouped by comment headers: `// FOOD & DRINK`, `// SHOPPING`, and so on.

Each business is one line that looks like this:

    { name:"Mrs. Claus Printing & Graphics", address:"112 E Main St", city:"Rogue River, OR 97537", phone:"541-951-4646", email:"mrs.kittyclaus@gmail.com", contact:"Kitty Barron", cat:"shopping", membership:"Basic", lat:42.4336, lng:-123.1693, pinEmoji:"🖨️" },

To change a phone number, an email, a contact name, or an address: find the
business, change the text between the quotes, save. Done.

### The fields

| Field | Required | Notes |
|---|---|---|
| `name` | yes | Shown on the pin popup and in the list |
| `address` | yes | Street address only |
| `city` | yes | Include state + ZIP, e.g. `"Rogue River, OR 97537"` |
| `cat` | yes | Category key — see table below |
| `lat` / `lng` | yes | Map coordinates — see section 4 |
| `phone` | no | |
| `email` | no | |
| `contact` | no | Person's name |
| `membership` | no | `"Basic"`, `"President's Circle"`, or `"New"` |
| `url` | no | Full address including `https://` |
| `pinEmoji` | no | The little icon on the map pin |
| `img` | no | Modal photo — see section 5 |

### Category keys

Use the left column exactly as written (lowercase, no spaces):

| Key | Shows up as |
|---|---|
| `food` | Restaurants |
| `shopping` | Shopping |
| `health` | Health |
| `services` | Services |
| `finance` | Finance |
| `attractions` | Attractions |
| `community` | Community |
| `govt` | Gov't |
| `homebiz` | Home-Based |

---

## 3. Adding a new business

1. Find the section for its category (e.g. `// SHOPPING`).
2. Click at the end of the last business in that group.
3. Press Return, then paste a copy of a neighboring line.
4. Change every value to the new business.

**Punctuation matters.** The line must start with `{` and end with `},`.
Every value needs its quotes. `lat` and `lng` are numbers — no quotes.

If the map comes up blank after an edit, it's almost always a missing quote,
comma, or brace on the line you just touched. Undo and retry.

### Apostrophes are safe
Fields use double quotes, so `"Uncle B's Sweets"` works fine as-is.

---

## 4. Getting lat / lng coordinates

1. Open Google Maps, find the business.
2. Right-click directly on its location.
3. The top item of the menu is the coordinates — click it to copy.
4. You get something like `42.4336, -123.1693`.
   First number is `lat`, second is `lng`. The minus sign on `lng` is required.

Four decimal places is plenty.

---

## 5. Photos (the only fiddly part)

Photos are embedded directly into the HTML as text, so the map stays a single
self-contained file. You can't type that by hand — but one command does it.

Put the photo in this folder, then run (replacing the filename):

    ./embed-photo.sh "Some-Business-RR.jpg"

It prints an `img:"data:image/..."` chunk. Copy the whole thing and paste it
into the business's line, just before the closing `}`, after a comma.

Shrink large photos first (Preview → Tools → Adjust Size → ~800px wide).
Every photo permanently increases the file size for every visitor.

**Simpler alternative:** if the business has a photo already on their own
website, just point at it — no embedding needed:

    img:"https://theirsite.com/photo.jpg"

The tradeoff: if they ever remove that photo, it disappears from your map too.

---

## 6. Publishing your changes

Open Terminal and run these three, one at a time:

    cd "/Users/Pan/Downloads/Rogue River Interactive Map /RR Map files"

    git add rogue_river_map_v3_4.html

    git commit -m "Add Smith Hardware to Shopping"

Then push:

    export PATH="/opt/homebrew/bin:$PATH" && git push

Write the commit message so it means something to you six months from now.
"Update file" tells you nothing; "Fix Tailholt phone number" does.

---

## 7. Safety net

Every push is a permanent restore point. You cannot lose the map.

**Undo edits you haven't committed yet** (throws away unsaved work — that's the point):

    git checkout rogue_river_map_v3_4.html

**See your recent history:**

    git log --oneline | head -10

**Before you start any edit,** it's worth confirming you're in a clean state:

    git status

If it lists `rogue_river_map_v3_4.html` as modified and you don't know why,
stop and ask Claude before pushing.

---

## 8. When to just ask Claude

Worth doing yourself:
- phone / email / address / contact corrections
- adding a business without a photo
- membership level changes
- moving a business between categories

Worth handing off:
- anything involving colors, layout, fonts, or the filter bar
- adding a brand-new category
- the map breaks and the cause isn't obvious
- batch work — a dozen businesses at once
