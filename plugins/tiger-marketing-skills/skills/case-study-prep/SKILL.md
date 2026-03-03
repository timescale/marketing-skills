---
name: case-study-prep
platforms: [cowork, claude-code]
description: >
  Create Tiger Data case study interview prep documents. Gathers customer information
  from Slack (#ask-eon channel via @eon bot) and user-provided Google Docs, then aligns
  all known information against the 8 standard Tiger Data Case Study Questions, producing
  a .docx with status ratings (Complete/Partial/Missing), draft answers, gap analysis,
  a 30-minute interview guide, and draft pull quotes.

  MANDATORY TRIGGERS: case study, interview prep, case study prep, customer story,
  customer interview, case study questions, ClickHouse takeout, competitive win story.

  Use when the user asks to prepare for a customer case study interview, create a case
  study prep doc, or align existing customer notes against the Tiger Data case study
  questions template.
references:
  - case-study/case-study-questions
  - case-study/output-format
---

# Case Study Interview Prep

Produce a .docx case study prep document for a given customer by gathering all available
information and aligning it to the 8 Tiger Data Case Study Questions.

## Workflow

### Step 1: Identify inputs

Determine from the user:
- **Customer name** (required)
- **Context documents** (optional): Google Doc URLs, uploaded files, or other sources containing existing customer notes
- If no context docs are provided, ask the user

### Step 2: Gather information from Slack

Search the **#ask-eon** channel (ID: C098FT3R3RP) for the @eon bot (ID: U095RJGF6TC):

1. Send a message to #ask-eon: `<@U095RJGF6TC> Summarize current use case and metrics for customer {Company Name}`
2. Wait ~30 seconds, then read the thread to capture eon's response
3. If eon's response is incomplete or the thread hasn't been answered yet, wait and retry

### Step 3: Fetch context documents

Fetch all user-provided Google Docs using `google_drive_fetch`. Also read any uploaded files.

### Step 4: Fetch reference docs from Google Drive

Before generating the document, fetch the two reference docs from the shared Drive folder.
Read `REFERENCES.md` from the plugin root to learn how to fetch docs based on your runtime
(Cowork vs Claude Code).

Fetch both docs before proceeding:
- **`case-study/case-study-questions`** — the 8 standard Tiger Data Case Study Questions
- **`case-study/output-format`** — document structure and styling for the prep doc

Also read the **docx skill** for .docx generation best practices (critical for correct docx-js usage).

### Step 5: Compile and assess

For each of the 8 case study questions:
1. Synthesize all available information (eon response + context docs + any other sources)
2. Draft an answer using all known facts
3. Assign a status:
   - **Complete**: Enough detail to write a full answer with no major gaps
   - **Partial**: Directional answer exists but specific details, metrics, or quotes are missing
   - **Missing**: No meaningful information available
4. Identify specific gaps to close during the interview

### Step 6: Generate the .docx

Create a Word document using `docx-js` following the structure in `case-study-output-format`:
- Title + subtitle
- Status legend table
- 8 question sections with status/details tables
- 30-minute interview guide (questions target ONLY the identified gaps)
- Draft pull quotes
- Sources list

Save to the outputs folder as `{Company}_Case_Study_Prep.docx`.

Validate with the docx skill's validate.py script.

### Step 7: Present results

Share the document link and a quick summary showing each question's status at a glance.
