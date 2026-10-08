---
description: Critical workflow rules for RunReady development regarding CurseForge deployments and Wowhead data.
---
# RunReady Project Rules

## 1. STRICT CURSEFORGE DEPLOYMENT RULE
**NEVER push a git tag starting with  (e.g., 1.0.19) without EXPLICIT, DIRECT approval from the user.**
The GitHub Actions workflow automatically packages and deploys * tags to CurseForge. You must ONLY commit to the main branch during iterative development. Wait for the user to explicitly say "ship it", "push the update", or "deploy to CurseForge" before creating a tag.

## 2. STRICT DATA SOURCING RULE (WoW Forever)
**NEVER use placeholder item IDs or quest IDs (e.g., 999999) for WoW Forever content.**
If you need an item ID or quest ID, you MUST query the Wowhead Forever database explicitly (e.g., appending "site:wowhead.com/forever" to your web search). If the data is missing, ask the user to provide the exact ID or Wowhead link. Do not guess.