# 安装说明 —— Claude（Claude Code / Claude Desktop）

> 目标：把 `proposal-workflow` 装成 Claude 的 Agent Skill，之后在对话里说"写开题报告"即可自动启用。

## 方法 A：Claude Code（命令行）

1. 找到你的 skills 目录：
   - Windows：`C:\Users\你的用户名\.claude\skills\`
   - macOS / Linux：`~/.claude/skills/`
   *（若目录不存在，先 `mkdir -p ~/.claude/skills` 或手动新建）*

2. 把本包里的 **`proposal-workflow` 整个文件夹**（含 SKILL.md、manifest.yaml、references、templates、scripts、examples）复制进去，最终结构：
   ```
   ~/.claude/skills/proposal-workflow/
   ├── SKILL.md
   ├── manifest.yaml
   ├── references/ ...
   ├── templates/ ...
   ├── scripts/ ...
   └── examples/ ...
   ```

3. 在 Claude Code 里确认加载：
   ```
   /skills
   ```
   列表中出现 `proposal-workflow` 即成功。

4. 使用：
   > 写开题报告，先给我一份课题输入清单

## 方法 B：Claude Desktop / 其他支持 Agent Skills 的 Claude 工具

- 支持 skills 目录的应用：同上，把 `proposal-workflow/` 目录放入其 skills 路径即可（多数实现读取与 `.claude/skills` 同构的目录）。
- 若不支持 skills 目录：把 `proposal-workflow/` 里的 **SKILL.md + references + templates + examples** 作为"项目附件/知识"加入对话，并把 SKILL.md 内容粘贴为项目说明，即可走同一流程（缺少一键脚本时，模板回填可用通用正式格式替代）。

## 自检清单

- [ ] `proposal-workflow/` 目录名正确、放在 skills 根下（不是嵌套多层）
- [ ] SKILL.md 在前面（一眼能看到 name: proposal-workflow）
- [ ] 说"写开题报告"后 agent 进入 7 阶段流程（而不是空泛回答）

## 常见问题

- **不显示技能**：确认目录结构与 skills 根路径一致，重启会话再 `/skills`。
- **构建脚本报"禁止运行脚本"**：Windows PowerShell 首次运行需
  `Set-ExecutionPolicy -Scope Process Bypass` 或管理员执行
  `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`。
- **你用 Mac/Linux**：本包构建脚本是 .ps1；可先用"无模板通用正式格式"出内容，或等后续版本的 .sh 版。
