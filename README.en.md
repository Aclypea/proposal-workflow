# Proposal-Writing Workflow (proposal-workflow)

English: this file ｜ 中文: [README.md](README.md)

A proposal-writing workflow packaged as an Agent Skill. It is not tied to any subject or topic: give it a title and it gets to work — if you have no reference files, the agent searches the literature online by itself. When it finishes, you get a complete set of proposal files (Word, PDF, reference library, statistical plan, and so on).

Intended users: master's students at Chinese universities (undergraduates also fine) writing an opening report / research proposal.

---

## What it does

- Works for any discipline. The seven-phase pipeline is not tied to a topic; rules specific to one project (banned terms, instrument order, etc.) are kept in that project's config and never mixed into the shared rules.
- Works with just a title or a rough idea. With no literature provided, the agent searches online (Crossref / OpenAlex / PubMed etc.) and checks every entry's authors, year, volume and pages; entries it cannot verify never make it into the report.
- References are re-checked before delivery. Problem entries are removed or listed for manual confirmation instead of slipping through silently.
- Fills your school's Word template. The cover, review forms and transcript stay untouched; the script only uses Windows built-in tools, no Python needed.
- Complete deliverables: Word, PDF, Markdown archive, reference library, statistical plan, QA report, and a claim–evidence table.

## Deliverables per topic (9 items)

| # | File | Purpose |
|---|---|---|
| 00 | Delivery notes | Read first |
| 01 | Final Word (template backfilled) | Hand to advisor / department |
| 02 | PDF preview | Quick review, printing |
| 03 | Markdown archive | Editing, archiving |
| 04 | Final QA report | Delivery quality summary |
| 05 | Reference verification report | A/B/C grades + verification record |
| 06 | Statistical design & plan | Finalized before data collection |
| 07 | Claim–evidence table | Which reference supports which claim |
| 08 | Reference library | All entries (no fewer than the school requires) |

## Getting started

### Claude users

```bash
# Put the whole proposal-workflow/ folder into Claude's skills directory
mkdir -p ~/.claude/skills
cp -r proposal-workflow ~/.claude/skills/
```

Then tell Claude: "Write an opening report — give me the topic-input checklist first."

### DSH (DeepSeek Harness) users

```
Copy the proposal-workflow/ folder into ~/.dsh/skills/
```

DSH picks the skill up automatically; saying "写开题报告" or "一键开题" triggers it.

### Without any AI

Follow `00_README.md` and run `scripts/build_proposal_docx_template.ps1` by hand.

## Repository layout

```
proposal-workflow/
├── SKILL.md                     # Agent Skill entry
├── manifest.yaml                # DSH skill manifest
├── references/                  # Formatting rules + the seven-phase pipeline
├── templates/                   # Input checklist, config templates, etc.
├── scripts/                     # School-template backfill script (Windows built-ins only)
└── examples/demo-runbook.md     # A full walkthrough on a fictional topic
```

## Docs

- `00_README.md` — user guide (what to prepare, how to start, FAQ), in Chinese
- `安装说明-Claude.md` / `安装说明-DSH.md` — install guides, in Chinese
- `CHANGELOG.md` — version history
- `release/` — packaged zip

## Requirements

- Windows 10/11. No Python, Node or other runtimes needed (the script only uses the built-in tar and Compress-Archive; a Mac/Linux version is planned).
- Literature search needs an AI with web access; an offline agent will give you a list of references to add yourself.

## License

MIT License — see [LICENSE](LICENSE).
