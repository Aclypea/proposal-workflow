# 开题报告标准化工作流 · proposal-workflow

> **English:** [README.en.md](README.en.md) · **中文:** 本文件

> 以 **Agent Skill** 形式打包的**课题无关**开题报告自动化工作流：任何学科、任何课题，只要提供题目（文献可选——没有文献时 Agent 自行检索），即可获得成套开题报告。

适用：中国高校硕士（本科/博士亦可）**开题报告 / 立项报告**。无需会写代码，无需懂 AI 原理。

---

## ✨ 功能亮点

- **课题无关**：7 阶段流水线适用于任何学科；课题特有规则经 `custom_rules` 按课题生效，不污染通用规范。
- **只给题目也能开工**：文献材料可选；没有文献时 Agent 按"综述优先 → 近 10 年高被引 → 经典方法学"自行联网检索并 A/B/C 分级核验（Crossref/OpenAlex/PubMed 等），不虚构、不收未核验预印本。
- **文献真实性终验**：交付前逐条复核参考文献（DOI/Crossref 等），失败条移除、无法核验条明确列出，终验报告随交付发出。
- **保留学校模板**：一键回填进学校的 Word 模板（封面/审核表/成绩单原样保留），自动追加参考文献；仅依赖 Windows 内置命令，无需 Python。
- **成套交付**：Word + PDF + 正文归档 + 参考文献库 + 统计方案 + QA 报告 + 声明–证据表。
- **双平台即装即用**：兼容 Claude（Agent Skills）与 DSH；同一套模板/脚本任意 AI 可读。

## 📦 每个课题的输出（9 件套）

| 编号 | 文件 | 用途 |
|---|---|---|
| 00 | 交付文件说明 | 先看这个 |
| 01 | 正式版 Word（模板回填版） | 交导师/学院 |
| 02 | PDF 预览版 | 快速翻看、打印 |
| 03 | 正文归档（Markdown） | 修改、存档 |
| 04 | 最终质量检查报告 | 交付质量说明 |
| 05 | 参考文献核验报告 | A/B/C 分级与核验记录 |
| 06 | 实验设计与统计方案 | 数据收集前冻结的统计设计 |
| 07 | 声明—证据追溯表 | 论断 ↔ 文献映射 |
| 08 | 参考文献库 | 全部条目（≥学校底线） |

## 🚀 快速开始

### 给用 Claude 的同学
```bash
# 将整个 proposal-workflow/ 目录放入你的 skills 目录
mkdir -p ~/.claude/skills
cp -r proposal-workflow ~/.claude/skills/
```
然后对 Claude 说：**"写开题报告，先给我一份课题输入清单"**。

### 给用 DSH（DeepSeek Harness）的同学
```
将 proposal-workflow/ 目录复制到 ~/.dsh/skills/ 下
```
DSH 自动发现技能（触发词：开题报告 / 一键开题 / 科研写作）。

### 也可以完全手动
不依赖任何 AI：按 `00_README.md` 的三步走 + `scripts/build_proposal_docx_template.ps1` 手动执行。

## 📁 目录结构

```
proposal-workflow/
├── SKILL.md                     # Agent Skill 入口（标准格式，中文触发词）
├── manifest.yaml                # DSH 技能清单
├── references/                  # 通用格式铁律 + 7 阶段流水线（课题无关）
├── templates/                   # 课题输入清单 + 证据底座 + 配置模板（含 custom_rules）
├── scripts/                     # 学校模板一键回填脚本（.ps1，仅 Windows 内置命令）
└── examples/demo-runbook.md     # 虚构课题全流程演示（脱敏）
```

## 📖 文档

- `00_README.md` — 面向使用者的完整说明（准备什么/怎么开始/FAQ）
- `安装说明-Claude.md` / `安装说明-DSH.md` — 双平台安装
- `CHANGELOG.md` — 版本记录
- `release/` — 可下载的打包 zip（含全部文件）

## 🛠 技术栈与依赖

- 无需 Python、无需 Node、无需安装任何运行时（脚本仅用 Windows 内置的 `tar` 与 `Compress-Archive`；Mac/Linux 打包脚本规划中）。
- 文献核验依赖 Agent 的联网检索能力；无联网 Agent 会向用户开列待补文献清单。

## ⚖️ 授权

MIT License. 详见 [LICENSE](LICENSE)。

## 🙋 反馈与贡献

发现 bug、有新规则想沉淀进"通用规范"、想要其他 AI 版本的接入层（ChatGPT 主提示词、Mac 脚本），欢迎提交 Issue 或 PR。所有新规则按"通用 vs 课题特定"分流：通用进格式铁律，课题特定进 `custom_rules`。
