# 开题报告标准化流水线（proposal-auto-pipeline）

把“输入采集 → 证据底座 → 文献核验 → 分节撰写 → 统计方案 → 模板回填 → QA 验收 → 交付”固化为**课题无关**的标准化流程。任何学科、任何课题，提供题目、模板、要求与材料即产出成套开题报告。

## 触发

用户说以下任意意图即进入本流水线：
- “写开题报告 / 开题报告工作流 / 一键开题 / 按流水线来”
- 提供题目、学校 Word 模板、生成要求、文献材料中的任意组合

不需要用户描述步骤；按流水线自动推进，仅在与用户意图冲突或证据缺口不可自动弥补时提问。

## 阶段 0：输入收集（先完成《课题输入清单》）

按 `templates/课题输入清单.md` 逐项采集，落到项目 `config.json`：

| 输入 | 必需 | 说明 |
|---|---|---|
| 课题题目 | 是 | 锁定展示用标题，与用户确认后不再随意改动 |
| 学科/研究领域 | 是 | 决定文献范围、术语体系与统计习惯 |
| 学校 Word 模板 | 是（可用） | 保留封面/表格/成绩单；缺则用通用正式格式 |
| 生成要求 | 是 | 字数、文献数、章节、上交日期等硬约束 |
| 文献材料 | 是 | 原开题、文献列表、PDF、笔记均可 |
| 研究方法与数据特点 | 是 | 主要方法/仪器、数据层级（是否多层/重复测量） |
| custom_rules | 否 | 课题特有规则（术语偏好、实验顺序、引用规范等） |
| 研究背景素材 | 否 | 原始实验数据、照片、草稿、口头说明 |

输出：项目目录 + `00_scope.md` + `config.json`（全部约束落地，含 `custom_rules`）。

## 阶段 1：Foundation 五文件

按 `templates/00_scope.md` 初始化（证据先于文字）：

1. `01_research_canon.md` — 硬事实与禁忌（不自动升级事实、不虚构任何内容）
2. `02_evidence_table.md` — 声明→证据映射表（每条标注证据来源与置信级别）
3. `03_argument_map.md` — 核心张力、问题、论点、备选、零结果价值
4. `04_section_contracts.md` — 每节 purpose / allowed / forbidden / 验收标准
5. `05_style_guide.md` — 术语、引用、语言纪律（叠加 custom_rules）

里程碑：完成 5 文件并写 `state.json`（round=0）。

## 阶段 2：文献检索与核验（双分支）

**分支 A：用户提供了文献材料**
- 从用户材料 + 课题主题出发建候选库（数量 ≥ 学校底线，一般 ≥50—70 条）。
- 核心文献逐条核验作者、标题、年份、卷期页、DOI（Crossref/OpenAlex/出版社页面）。
- 分级：A=已核验、B=原稿支持待复核、C=新增待复核；未核验的预印本不入库。
- 输出 `literature/reference_library_NN.md` + `qa_logs/reference_verification_report.md`。

**分支 B：用户未提供文献（只有题目/思路）**
- Agent 依据课题主题**自行联网检索**核心文献：优先查 Crossref / OpenAlex / PubMed / PubMed Central / arXiv / 出版社页面（按课题学科选择数据库）。
- 检索策略：主题关键词组合 → 领域综述（review）优先 → 近 10 年高被引与最新文献 → 补充经典方法学/理论文献；每条先取元数据（作者、年份、标题、期刊/出处、卷期页、DOI）。
- 逐条核验（能取到全文或摘要则核对结论；取不到独立验证的把该条降级为 B/C 级）。
- 仍执行 A/B/C 分级；**未核验的预印本、无法确认出处的条目不入库**。
- 建库数量不足学校底线（如 <50）时：扩大关键词/同义词、增加邻近学科、补经典被引文献；仍不足则在 QA 报告如实说明缺口，不虚构文献凑数。
- 所有自检文献在 `reference_verification_report.md` 标注“Agent 检索来源（Crossref/OpenAlex/PubMed 等）与核验级别”。
- 输出同分支 A：`literature/reference_library_NN.md` + `qa_logs/reference_verification_report.md`。

> 说明：分支 B 要求 agent 具备联网检索能力（web/学术数据库工具）。若 agent 无联网能力，告知用户并提供“需要补充文献”的清单，等待用户提供后再继续。

## 阶段 3：分节正文

在 `drafts/sections/` 按章节合同逐节写（章节名可按学校模板调整，默认结构）：

- `01_立题依据_研究背景与意义.md`
- `02_立题依据_国内外研究现状.md`（纯综述，通用规范 §3）
- `03_立题依据_立题依据与存在问题.md`（若无对应模板段可并入 01）
- `04_研究内容和目标.md`
- `05_研究方案设计及可行性分析.md`（章节顺序 = 执行顺序，通用规范 §6）
- `06_研究基础与创新点及计划.md`

每节写入后立即 `writing_audit`；全文合并为 `drafts/proposal_vN.md` 后再审计一次。

## 阶段 4：统计方案

输出 `qa_logs/statistical_analysis_plan.md`，按课题数据特点定制，通用要素包括：
- 独立重复单元与技术重复的划分（防伪重复）；
- 随机化/区组/批次处理；
- 重复性与可靠性指标（ICC/CV 等）；
- 混合效应模型（若有层级/重复测量）；
- 递进模型比较（基础模型 → 增变量组）与 AIC/BIC/验证误差；
- 多变量降维与关联分析（PCA/RDA/PLSR 等，按需选用）；
- 路径模型/结构方程（样本不足只用简化或分段形式）；
- 分类/预测为次级分析，交叉验证按独立重复分层、预处理在训练折内完成；
- 缺失/无效数据处理与可复现性（随机种子与版本）。

**嵌套约束：** 阶段 4 的模型结构来自课题方案，不套用任何固定模板；模型在数据收集前冻结。

## 阶段 5：模板回填（一键构建）

调用技能脚本：

```powershell
& "$env:USERPROFILE\.dsh\skills\proposal-workflow\scripts\build_proposal_docx_template.ps1" `
  -TemplateDocx "<学校模板.docx>" `
  -OutputDocx   "<out/proposal_final.docx>" `
  -SectionsDir  "<drafts/sections>" `
  -RefsFile     "<literature/reference_library_NN.md>" `
  -NewTitle     "<锁定标题>" `
  -ConfigJson   "<out/config.json>"        # 章节锚点、旧标题、分节映射、custom_rules
```

配置骨架见 `templates/proposal_project_config.md`；不同学校只需改 `heading_anchor` 与 `section_files`。

构建后自动验收：
1. `[Content_Types].xml`、`word/document.xml`、`word/styles.xml` 存在且 XML 可解析；
2. `tar -xf` 验证包结构完整；
3. Microsoft Word COM 导出 PDF，逐页目检标题、章节、文献、固定表格。

## 阶段 6：QA 与验收

- `qa_logs/final_qa_report.md`：篇幅、模板保留、渲染检查、引用一致性、科学主张、统计方案、写作纪律、待作者填写项。
- 引用双向检查：正文角标集合 vs 文献表（引用 ⊆ 文献；未引用条目标注）。
- `writing_audit` 全程低风险（命中高风险即返工）。

### 阶段 6.5：文献真实性终验（交付前最后一道检查）

在关闭文档、交付给用户之前，对参考文献库做**逐条真实性复核**：

1. **DOI/来源复验**：对每条带 DOI 的文献，用 Crossref（`https://api.crossref.org/works/<DOI>`）等公共 API 复查——标题、作者、年份、期刊、卷期页逐字段比对；找不到或不一致的条目标记 `VERIFY-FAIL`。
2. **无 DOI 条目**：按其期刊/出版社/arXiv/PubMed 链接或搜索标题+作者在权威数据库（PubMed/PMC/OpenAlex/Europe PMC/出版社页面）复核；人工可核验（已有 PDF、图书馆目录）的标 `VERIFIED`，否则标 `UNVERIFIED`。
3. **分级更新**：复核后更新 A/B/C 分级——通过者升 A；复核失败的**从正文引用与文献表中移除**（或降为"参考待核"清单，不得作为正式引用）；B/C 级在交付说明中明确标注"建议提交前人工复核"。
4. **输出终验报告**：在 `qa_logs/reference_verification_report.md` 末尾追加"文献真实性终验"小节：总条数、VERIFIED / VERIFY-FAIL / UNVERIFIED 计数、逐条结果表（编号、条目、状态、依据来源）、待作者人工复核清单。
5. **通过标准**：正式引用条目 100% VERIFIED 或已核验通过；存在 UNVERIFIED 时必须作为"交付前需人工复核项"列出，不允许静默通过。终验报告随交付文件一起交给用户。

## 阶段 7：交付

桌面新建“`<课题>开题报告_最终交付`”文件夹，编号文件（文件名让用户一眼看懂）：

```
00_请先看_交付文件说明.txt
01_<课题>开题报告_正式版.docx
02_<课题>开题报告_预览版.pdf
03_<课题>开题报告_正文归档.md
04_<课题>开题报告_最终质量检查报告.md
05_<课题>开题报告_参考文献核验报告.md
06_<课题>开题报告_实验设计与统计分析方案.md
07_<课题>开题报告_声明证据追溯表.md
08_<课题>开题报告_参考文献库.md
```

项目目录保留在 `researchwrite/<slug>/` 供迭代。

## 复用与升级

- 新课题：复制 `templates/课题输入清单.md` → 填表 → 生成 `config.json` → 跑阶段 1—7。
- **通用规则**提升：被证明对多数课题成立的新规则，追加到 `开题报告格式铁律.md`（通用规范）。
- **课题特定规则**：写入该课题 `config.json` 的 `custom_rules`，不污染通用规范。
- 通用规范与 custom_rules 冲突时，以 custom_rules 为准。
