# Proposal-Writing Workflow (proposal-workflow)

> A **subject-agnostic** proposal-writing automation workflow packaged as an **Agent Skill**. For any discipline and any topic: supply a title (literature optional — the agent searches references itself when none are given) and receive a complete proposal pack.

Target users: master's (also bachelor's / PhD) **opening reports / project proposals** at Chinese universities. No coding skills or AI expertise required.

---

## ✨ Highlights

- **Subject-agnostic**: a 7-phase pipeline that applies to any discipline; per-topic special rules live in `custom_rules` per project and never pollute the generic ruleset.
- **Works with just a topic**: literature is optional. When the user gives only a title or research idea, the agent searches and verifies references itself (reviews first → highly cited recent work → classic methods), graded A/B/C via Crossref / OpenAlex / PubMed etc.; no fabricated entries, no unverified preprints.
- **Keeps your school template**: one-click backfill into your school's Word template (cover / review forms / transcript preserved), references appended automatically; uses only built-in Windows tools — no Python required.
- **Complete deliverable set**: Word + PDF + Markdown archive + reference library + statistical plan + QA report + claim–evidence table.
- **Works on two platforms**: compatible with Claude (Agent Skills) and DSH; the same templates/scripts are readable by any AI.
- **Final reference integrity check**: before delivery, every cited reference is re-verified against DOI/source (Crossref API etc.); failures are removed or downgraded, and a verification report is included in the deliverables.

## 📦 Deliverables per topic (9 items)

| # | File | Purpose |
|---|---|---|
| 00 | Delivery notes | Read first |
| 01 | Final Word (template backfilled) | Hand to advisor / department |
| 02 | PDF preview | Quick review, printing |
| 03 | Markdown archive | Editing, archiving |
| 04 | Final QA report | Delivery quality summary |
| 05 | Reference verification report | A/B/C grades + verification record |
| 06 | Statistical design & plan | Frozen before data collection |
| 07 | Claim–evidence table | Claim ↔ reference mapping |
| 08 | Reference library | All entries (≥ school minimum) |

## 🚀 Quick Start

### For Claude users
```bash
mkdir -p ~/.claude/skills
cp -r proposal-workflow ~/.claude/skills/
```
Then tell Claude: **"Write an opening report — give me the topic-input checklist first."**

### For DSH (DeepSeek Harness) users
```
Copy the proposal-workflow/ folder into ~/.dsh/skills/
```
DSH auto-discovers the skill (triggers: 开题报告 / 一键开题 / 科研写作).

### Fully manual
No AI required: follow `00_README.md` and run `scripts/build_proposal_docx_template.ps1` yourself.

## 📁 Repository Layout

```
proposal-workflow/
├── SKILL.md                     # Agent Skill entry (standard format, Chinese triggers)
├── manifest.yaml                # DSH skill manifest
├── references/                  # Generic formatting rules + 7-phase pipeline (subject-agnostic)
├── templates/                   # Topic-input checklist + evidence-base + config templates (custom_rules)
├── scripts/                     # One-click school-template backfill (.ps1, Windows built-ins only)
└── examples/demo-runbook.md     # Full sanitized demo on a fictional topic
```

## 📖 Documentation

- `00_README.md` — full user guide (what to prepare / how to start / FAQ), Chinese
- `安装说明-Claude.md` / `安装说明-DSH.md` — platform install guides (Chinese)
- `CHANGELOG.md` — version history
- `release/` — downloadable zip with all files

## 🛠 Tech Stack & Dependencies

- No Python, no Node, no extra runtime (script uses only Windows built-in `tar` and `Compress-Archive`; Mac/Linux script planned).
- Reference verification relies on the agent's web/DB access; a non-networked agent will ask the user for a list of references to add.

## ⚖️ License

MIT License — see [LICENSE](LICENSE).

## 🙋 Feedback & Contributions

Found a bug? Want a rule promoted into the generic ruleset, or another agent adapter (e.g. ChatGPT master prompt, Mac script)? Open an Issue or PR. New rules are split: generic ones go into the formatting rules, topic-specific ones into `custom_rules`.
