# Changelog

本项目遵循 [Semantic Versioning](https://semver.org/lang/zh-CN/)。

## [v1.2] - 2026-08-22

### 新增
- **文献真实性终验（阶段 6.5）**：交付前逐条复核参考文献——DOI/Crossref 复验、无 DOI 条目按来源检索核验，失败条移除、无法核验条明确列出并随终验报告交付；正式引用须 100% 通过，未核验条目必须显式列为"交付前人工复核项"。
- **中英双语 README**：新增 `README.en.md` 英文完整版，`README.md` 顶部提供语言切换。
- 严格隐私脱敏：移除引用示例中的常见示例姓名，统一替换为中性占位 `作者A`，并新增 `.gitignore` 规则防止扫描/验收残留目录入库。

### 变化
- 发布仓库文件：`README.en.md`、更新后的 `.gitignore`、`CHANGELOG`。

## [v1.1] - 2026-08-22

### 新增
- **无文献自检分支**：用户仅提供题目或研究思路、不提供文献材料时，Agent 会自行联网检索并核验（Crossref / OpenAlex / PubMed / PMC / arXiv / 出版社页面等），按 A/B/C 分级建库，不虚构、不收录未核验预印本。
- SKILL.md 触发方式支持"只有题目/思路也能开工"。
- README 与《课题输入清单》将文献材料标注为可选。

### 修复
- 构建脚本 `build_proposal_docx_template.ps1`：`-RefsFile` 改为可选参数，缺文献文件时跳过文献步骤、不再阻断整个构建。
- 构建脚本：修复"论文题目"后旧标题的回退替换逻辑（避免把标签当文本替换导致 XML 损坏）；修正 w:t 匹配正则，排除 `w:tcW` 等前缀标签的误匹配。
- 确保脚本文件为 UTF-8 with BOM，避免 Windows PowerShell 中文乱码导致语法错误。

## [v1.0] - 2026-08-22

### 新增
- 课题无关的 7 阶段开题报告标准化流水线：输入收集 → 证据底座 → 文献检索与核验 → 分节撰写 → 统计方案 → 学校模板回填 → QA 交付。
- 通用格式规范《开题报告格式铁律》（标题层级、引用角标、研究现状边界、专有名词、用词纪律、实验顺序、篇幅与交付、模板回填、统计实证边界、课题自定义规则 custom_rules）。
- 全套模板：课题输入清单、项目配置、证据底座五文件、QA 报告、修订简报。
- 学校 Word 模板一键回填脚本（保留封面/审核表/成绩单，自动追加参考文献；仅依赖 Windows 内置命令）。
- Agent Skill 分发形式：`SKILL.md` + `manifest.yaml`（兼容 Claude / DSH 等支持 Agent Skills 的工具）。
- 脱敏的虚构课题演示走查 `examples/demo-runbook.md`。
- 双平台安装说明（Claude / DSH）。

## [Unreleased]（规划）

- v1.2：ChatGPT / 在线 AI 可粘贴的主提示词（master prompt）。
- v1.2：Mac / Linux 版构建脚本（.sh）。
- v1.3：GitHub Actions 自动生成发布包。
