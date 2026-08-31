# 安装说明 —— DSH（DeepSeek Harness）

> 目标：把 `proposal-workflow` 装成 DSH 本机技能，之后在 DSH 对话里说"写开题报告"即可自动启用（与原 researchwrite 用法一致）。

## 步骤

1. 找到 DSH 技能目录：
   - Windows：`C:\Users\你的用户名\.dsh\skills\`
   - macOS / Linux：`~/.dsh/skills/`

2. 把本包里的 **`proposal-workflow` 整个文件夹**（含 SKILL.md、manifest.yaml、references、templates、scripts、examples）复制进去，最终结构：
   ```
   ~/.dsh/skills/proposal-workflow/
   ├── SKILL.md
   ├── manifest.yaml
   ├── references/ ...
   ├── templates/ ...
   ├── scripts/ ...
   └── examples/ ...
   ```

3. 在 DSH 中确认：
   - 可用技能列表中出现 `proposal-workflow`（或 `researchwrite` 兼容名）；
   - 触发词"写开题报告 / 开题报告工作流 / 一键开题"命中。

4. 使用：
   > 写开题报告，先给我一份课题输入清单

## 依赖说明

- 技能由 DSH 自动发现，无需额外安装任何依赖。
- `scripts/build_proposal_docx_template.ps1` 仅用 Windows 内置命令（tar、Compress-Archive），**无需 Python**。
- 若要在 DSH 中把生成结果回填进学校模板，提供模板 .docx 路径即可，agent 会调用该脚本。

## 自检清单

- [ ] `proposal-workflow/` 目录位于 `~/.dsh/skills/` 下且命名正确
- [ ] `manifest.yaml` 存在且 `name: proposal-workflow`
- [ ] 说"写开题报告"后 agent 进入 7 阶段流程

## 常见问题

- **技能列表不刷新**：重启 DSH / 新建会话后重试。
- **脚本被沙箱拒绝写外部目录**：回填学校模板和导出 PDF 需要写入用户 Temp 与 Office 缓存目录；如遇权限提示，按 agent 引导授权一次即可。
- **构建脚本报"禁止运行脚本"**：`Set-ExecutionPolicy -Scope Process Bypass`，或 `powershell.exe -ExecutionPolicy Bypass -File <script>`。
