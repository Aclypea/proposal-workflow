# 开题报告标准化工作流 · proposal-workflow

English: [README.en.md](README.en.md) ｜ 中文：本文件

这是一套打包成 Agent Skill 的开题报告自动写作流程，不挑学科、不挑课题：给出题目就能开工，没有文献材料时 AI 会自己上网检索。跑完之后得到一整套开题报告文件（Word、PDF、参考文献库、统计方案等）。

适用：中国高校硕士（本科也可以）的开题报告 / 立项报告。

---

## 它能做什么

- 任何学科通用。七个阶段的流程不绑定课题；某个课题特有的规则（比如某个词不能用、某台仪器要先测）单独记在该课题的配置里，不会混进通用规范。
- 只给题目或研究思路也能开工。没有文献材料时，AI 自己联网检索文献（Crossref / OpenAlex / PubMed 等），逐条核对作者、年份、卷期页，查不到出处的不会进报告。
- 交付前把参考文献再核验一遍。有问题的条目删掉或单独列出来提醒你人工确认，不会悄悄混过去。
- 能把正文一键填进学校的 Word 模板。封面、审核表、成绩单这些固定表格原样保留，只用 Windows 自带功能，不用装 Python。
- 交付物齐全：Word、PDF、正文存档、参考文献库、统计方案、质量检查报告、声明—证据对照表。

## 每个课题的输出（9 件套）

| 编号 | 文件 | 用途 |
|---|---|---|
| 00 | 交付文件说明 | 先看这个 |
| 01 | 正式版 Word（模板回填版） | 交导师/学院 |
| 02 | PDF 预览版 | 快速翻看、打印 |
| 03 | 正文归档（Markdown） | 修改、存档 |
| 04 | 最终质量检查报告 | 交付质量说明 |
| 05 | 参考文献核验报告 | A/B/C 分级与核验记录 |
| 06 | 实验设计与统计方案 | 数据收集前定稿 |
| 07 | 声明—证据追溯表 | 每条论断对应哪篇文献 |
| 08 | 参考文献库 | 全部条目（不少于学校要求） |

## 怎么开始

### 用 Claude

```bash
# 把整个 proposal-workflow/ 目录放进 Claude 的 skills 目录
mkdir -p ~/.claude/skills
cp -r proposal-workflow ~/.claude/skills/
```

然后对 Claude 说："写开题报告，先给我一份课题输入清单"。

### 用 DSH（DeepSeek Harness）

```
把 proposal-workflow/ 目录复制到 ~/.dsh/skills/ 下
```

DSH 会自动识别这个技能，说"写开题报告"或"一键开题"就能触发。

### 不用 AI，手动做

按 `00_README.md` 的步骤，配合 `scripts/build_proposal_docx_template.ps1` 手动执行。

## 目录结构

```
proposal-workflow/
├── SKILL.md                     # Agent Skill 入口
├── manifest.yaml                # DSH 技能清单
├── references/                  # 格式规范 + 七阶段流程说明
├── templates/                   # 输入清单、配置模板等
├── scripts/                     # 学校模板回填脚本（Windows 自带命令即可运行）
└── examples/demo-runbook.md     # 一个虚构课题的完整演示
```

## 相关文档

- `00_README.md` — 使用说明（准备什么、怎么开始、常见问题）
- `安装说明-Claude.md` / `安装说明-DSH.md` — 两个平台的安装方法
- `CHANGELOG.md` — 版本记录
- `release/` — 打包好的 zip

## 环境要求

- Windows 10/11 即可，不用装 Python、Node 或其他任何运行环境（脚本只用系统自带的 tar 和 Compress-Archive；Mac/Linux 版脚本在计划中）。
- 文献检索需要 AI 能联网；AI 不能联网时会列一份文献清单让你自己补。

## 授权

MIT License，详见 [LICENSE](LICENSE)。
