# How to Fetch Reference Docs

Skills in this plugin declare which reference docs they need in their frontmatter. The docs themselves live outside the plugin. This file explains how to fetch them.

## Fetching strategy

Try sources in this order. Stop as soon as you successfully load the docs:

1. **Tiger Den MCP** (works in Cowork and Claude Code)
2. **Google Drive** (Cowork only — transitional fallback for skills not yet updated to use Tiger Den)

## Source 1: Tiger Den MCP (preferred)

If the `get_marketing_context` tool is available, use it. This is the fastest path — one tool call, all docs returned together.

**Fetch all declared references in one call:**

```
get_marketing_context(slugs: ["product-marketing-context", "brand-voice-guide"])
```

The slugs match the reference names in the skill's frontmatter. Pass all of them as an array and you get everything in a single round-trip.

**If you only need one doc**, use `get_marketing_reference` instead:

```
get_marketing_reference(slug: "brand-voice-guide")
```

**If you're not sure what's available**, use `list_marketing_references` to see all available reference docs and their slugs.

**If Tiger Den fails** (tool not available or connection error): fall through to Source 2 if you're in Cowork. In Claude Code, Tiger Den is the only source — see the error handling section below.

## Source 2: Google Drive (transitional fallback — Cowork only)

Some skills haven't been updated to use Tiger Den yet and still reference Google Drive directly. This section supports those skills during the transition. Once all skills are migrated, this section will be removed.

This path only works in Cowork where the Google Drive connector is available.

### Setup

Read `config.json` from the plugin root. It contains the shared Drive folder ID under the `references_folder_id` key. Use that value wherever `<folder_id>` appears below.

### Reference path format

Reference names in skill frontmatter can be:

- **Simple names** — e.g. `brand-voice-guide` — a doc at the root of the shared references folder
- **Paths with subfolders** — e.g. `matty/topic-buckets` — a doc inside a subfolder

When a reference has a `/`, treat each segment before the last as a subfolder to traverse.
The last segment is the document name.

### Fetching with the Google Drive connector

If the `google_drive_search` tool is available:

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

**Performance note:** You can batch multiple fetches into a single `google_drive_fetch` call by passing multiple document IDs at once. When a skill needs several reference docs, search for all of them first, collect the URIs, then fetch them in one call.

## Error handling

If reference docs can't be loaded, do NOT proceed silently. Tell the user which docs couldn't be loaded and provide actionable guidance:

- **Tiger Den not available:** "The Tiger Den MCP server isn't connected. You can add it in your MCP settings." In Cowork, fall through to Google Drive. In Claude Code, this is the only source — the user needs to connect Tiger Den to proceed.
- **Tiger Den connection error:** "Tiger Den returned an error. Check that the MCP server is running." In Cowork, fall through to Google Drive.
- **Google Drive connector not available (Cowork):** "The Google Drive connector isn't enabled. You can enable it in Cowork settings (Settings → Connectors → Google Drive), or connect the Tiger Den MCP server instead."
- **Doc not found in Google Drive:** "Could not find '[doc-name]' in the shared references folder. Check that it exists in Google Drive."
- **Subfolder not found:** "Could not find subfolder '[name]' in the references folder. Check that the subfolder exists in Google Drive."
- **All sources failed:** "Reference docs couldn't be loaded from Tiger Den or Google Drive. Content quality depends on having the right context — I'd rather surface this than write without it. Check your MCP and connector settings."
