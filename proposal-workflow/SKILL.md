---
name: proposal-workflow
description: |
  开题报告 / 学位论文开题 / 课题开题 / 研究方案 / 立项报告 / 科研写作 标准化工
  作流。任何学科、任何课题：只要提供题目、学校 Word 模板、写作要求与文献材料，
  即可按证据先行的 7 阶段流水线产出成套开题报告（Word 模板回填版、PDF 预览、
  正文归档、参考文献库、统计方案、QA 报告与声明—证据表）。proposal writing
  pipeline for Chinese university opening reports; subject-agnostic; evidence
  before prose, template-preserving DOCX export.
license: MIT
metadata:
  hermes:
    tags: [proposal, writing, research, kangti, kaoti, docx, qa]
    related_skills: [docx, literature-review, scientific-writing]
---

# 开题报告标准化工作流（proposal-workflow）

课题无关的标准化科研写作流水线：以"证据先行 → 分节撰写 → 统计方案冻结 → 学校模板回填
→ QA 验收 → 成套交付"为核心，适用于中国高校任何学科的硕士学位（及本科/博士）开题或
立项报告。

## 触发方式

用户表达以下任一意图即启用本工作流（无需解释全流程）：
- "写开题报告 / 开题报告工作流 / 一键开题 / 帮我写开题"
- "按标准工作流写 XX 课题的开题报告"
- 提供 题目 + 学校 Word 模板 + 生成要求（字数/文献数等）+ 文献材料 的任意组合
- **只有题目或研究思路、没有文献材料**：也可以开工——Agent 会自行联网检索并核验文献
  （详见"7 阶段流水线"第 3 步的"分支 B：无文献自检"）。

## 资源文件（随包提供）

- `references/开题报告格式铁律.md` — 通用格式规范（课题无关的强制规则）
- `references/proposal-auto-pipeline.md` — 7 阶段流水线执行细则（首选按此推进）
- `templates/课题输入清单.md` — 每个新课题开工前必填的输入采集表
- `templates/proposal_project_config.md` — config.json 模板（锚点/分节映射/custom_rules）
- `templates/00_scope.md` … `templates/05_style_guide.md` — 证据底座五文件模板
- `templates/qa_report.md`、`templates/revision_brief.md` — QA 与修订模板
- `scripts/build_proposal_docx_template.ps1` — 学校模板一键回填脚本（仅 Windows 内置命令）
- `examples/demo-runbook.md` — 虚构课题全流程演示（脱敏示例）

## 7 阶段流水线（概述，细则见 proposal-auto-pipeline.md）

1. **输入收集**：按《课题输入清单》逐项确认；产出 `00_scope.md` + `config.json`（含
   `heading_anchor`、`section_title_regex`、`section_files`、`custom_rules`）。
2. **证据底座**：写 `01_research_canon.md`、`02_evidence_table.md`、`03_argument_map.md`、
   `04_section_contracts.md`、`05_style_guide.md`（证据先于文字）。
3. **文献检索与核验**（双分支）：
   - 分支 A（用户提供文献）：候选库（≥学校底线，常见 ≥50—70 条）→ A/B/C 分级核验
     （A=已核验、B=原稿支持待复核、C=新增待复核）→ `reference_verification_report.md`；
     未核验的预印本不入库。
   - 分支 B（用户未提供文献，只有题目/思路）：Agent **自行联网检索**（Crossref / OpenAlex /
     PubMed / PMC / arXiv / 出版社页面等，按学科选择）→ 综述优先 → 近 10 年高被引与最新 →
     补经典方法学 → 同样 A/B/C 分级核验并标注检索来源；未核验、出处不明条目不入库；
     数量不足时扩词扩域补检索，仍不足则在 QA 报告如实说明缺口，不虚构凑数。
     若 Agent 无联网能力，改为向用户索要文献清单后继续。
4. **分节正文**：在 `drafts/sections/` 按章节合同逐节写（习惯结构 6 个文件，章节名按
   学校模板可调）；每节写后 `writing_audit`，合并后全文再审计。
5. **统计方案**：`statistical_analysis_plan.md`，按课题数据特点定制；必须明确独立重复
   单元与技术重复、随机化/批次、ICC/CV、混合效应模型、递进模型比较、多变量降维、
   路径模型（样本不足用简化/分段）、分类为次级分析（交叉验证按独立重复分层且预处理在
   训练折内完成）；统计方案在数据收集前冻结。
6. **模板回填**：调用 `scripts/build_proposal_docx_template.ps1`（参数：
   `-TemplateDocx -OutputDocx -SectionsDir -RefsFile -NewTitle -ConfigJson`）；
   保留封面/审核表/成绩单等固定表格，自动追加参考文献；构建后用 XML 校验 + Word 导出
   PDF 逐页目检。
7. **QA 与交付**：`final_qa_report.md`（篇幅/模板保留/渲染/引用一致性/科学主张/统计/
   写作纪律/待作者填写项）；引用双向检查（正文引用 ⊆ 文献表）；桌面新建
   `〈课题〉开题报告_最终交付` 文件夹，按编号命名全套交付物。

## 必须遵守的通用铁律（摘要，详见 开题报告格式铁律.md）

- 标题层级完整、编号连续，不跳级不丢失；正文不得从次级标题直接开始。
- 引用角标统一"（作者，年份）"：中文作者（作者A等，2020）、外文（Smith 等，2015）、
  双作者用"和"、多文献用分号；禁用英文逗号式角标；文献表全部被正文引用。
- 研究现状只写已有研究综述，不穿插"本研究拟……"等课题自我论证。
- 专有名词首次出现用"中文全称（英文全称，缩写）"；学名斜体。
- 禁用绝对化（首次/填补空白/证明因果）与任何虚构（设备/经费/DOI/数据/人名/日期）；
  无法确认的信息如实留待作者填写；不自动升级事实。
- 章节顺序 = 研究执行顺序，先无损伤后破坏性制样。
- 独立重复单元 ≠ 技术重复；统计方案在收集数据前冻结；随机种子与版本全程记录。
- 课题特有规则（术语偏好、实验顺序、引用规范等）写入该课题 `config.json` 的
  `custom_rules`，只对该课题生效，不写入通用规范。

## 交付物（每个课题固定成套）

正式 Word（模板回填版）＋ PDF（渲染验收）＋ Markdown 正文归档 ＋ 参考文献库 ＋
统计方案 ＋ QA 报告 ＋ 声明—证据表。文件名编 00–08 前缀，让用户一眼看懂。

## 边界与诚实原则

- 学校模板只读，回填时复制副本；固定表格原样保留。
- 样本量、合作平台、经费、设备型号等如无确据，一律写"待确认"。
- 本工作流只做研究和写作支持，不虚构实验结果，不代写学术不端内容。

