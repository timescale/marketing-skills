# How to Fetch Reference Docs from Google Drive

Skills in this plugin declare which reference docs they need in their frontmatter. The docs themselves live in a shared Google Drive folder — not bundled in the plugin. This file explains how to fetch them.

## Reference path format

Reference names in skill frontmatter can be:

- **Simple names** — e.g. `brand-voice-guide` — a doc at the root of the shared references folder
- **Paths with subfolders** — e.g. `matty/topic-buckets` — a doc inside a subfolder

When a reference has a `/`, treat each segment before the last as a subfolder to traverse.
The last segment is the document name.

## Step 1: Get the folder ID

Read `config.json` from the plugin root. It contains the shared Drive folder ID under the `references_folder_id` key. Use that value wherever `<folder_id>` appears below.

## Step 2: Detect your runtime and fetch

### Cowork (Google Drive connector)

If the `google_drive_search` tool is available, you're in Cowork. To fetch a reference doc:

**Simple reference** (no `/` in the name):

1. Search for the doc by name within the shared folder:
   ```
   google_drive_search(api_query: "name = '<doc-name>' and '<folder_id>' in parents")
   ```
2. Fetch the full content:
   ```
   google_drive_fetch(document_ids: ["<uri-from-search>"])
   ```

**Path reference** (contains `/`, e.g. `matty/topic-buckets`):

1. Split the path on `/`. The segments before the last are folders; the last is the doc name.
2. Starting from the root references folder, resolve each folder segment:
   ```
   google_drive_search(api_query: "name = 'matty' and '<root_folder_id>' in parents and mimeType = 'application/vnd.google-apps.folder'")
   ```
3. Use the returned folder ID to search for the next segment, repeating until you reach the
   final segment (the doc name):
   ```
   google_drive_search(api_query: "name = 'topic-buckets' and '<matty_folder_id>' in parents")
   ```
4. Fetch the doc content:
   ```
   google_drive_fetch(document_ids: ["<uri-from-search>"])
   ```

**Performance note:** Each folder level costs one extra Drive API call. In practice this is one or two extra calls at most and is negligible. If a skill needs multiple docs from the same subfolder, resolve the subfolder once and reuse the folder ID for all doc lookups.

You can batch multiple fetches into a single `google_drive_fetch` call by passing multiple document IDs at once. When a skill needs several reference docs, search for all of them first, collect the URIs, then fetch them in one call.

**If the Google Drive connector isn't available:** Tell the user to enable the Google Drive connector in Cowork settings (Settings → Connectors → Google Drive). It's installed by default for all Tiger Data teammates.

### Claude Code (gdrive CLI)

If the `google_drive_search` tool is NOT available, you're in Claude Code. Use the `gdrive` CLI:

**Simple reference:**

1. List files in the shared folder:
   ```bash
   gdrive files list --parent <folder_id>
   ```
2. Find the file ID for the doc you need from the output, then download it:
   ```bash
   gdrive files download --id <file-id> --stdout
   ```

**Path reference:**

1. List files in the root folder and find the subfolder:
   ```bash
   gdrive files list --parent <root_folder_id>
   ```
2. Find the subfolder ID from the output, then list its contents:
   ```bash
   gdrive files list --parent <subfolder_id>
   ```
3. Find the doc ID and download:
   ```bash
   gdrive files download --id <file-id> --stdout
   ```

**If `gdrive` is not installed:** Tell the user to install it (`brew install gdrive`) and authenticate (`gdrive auth`) using their Google Workspace account. This is a one-time setup.

## Error handling

If a Drive fetch fails (doc not found, permissions error, network issue), do NOT proceed silently. Tell the user which reference doc couldn't be loaded and why. The content quality depends on having the right context — better to surface the problem than write without it.

If a subfolder can't be resolved (no folder with that name in the parent), report the full path that failed, e.g.: "Could not find subfolder 'matty' in the references folder. Check that the subfolder exists in Google Drive."
