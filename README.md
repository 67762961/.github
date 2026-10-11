# .github

集中管理 [@67762961](https://github.com/67762961) 名下所有项目的**默认社区健康文件**，并提供统一的 **Label 同步** 机制。

## 📁 目录结构

\`\`\`
.github/
├── README.md
├── scripts/
│   └── sync-labels.ps1          # Label 同步脚本
└── .github/
    ├── PULL_REQUEST_TEMPLATE.md # PR 模板（所有仓库继承）
    └── ISSUE_TEMPLATE/
        ├── config.yml
        └── issue_form.yml       # Issue 表单（所有仓库继承）
\`\`\`

## 🔄 自动继承的文件

GitHub 会自动将以下内容作为**所有仓库的默认回退**（若项目自行定义了同名文件，则以项目自身为准）：

- `PULL_REQUEST_TEMPLATE.md` — PR 模板
- `ISSUE_TEMPLATE/` — Issue 模板与表单

## 🏷️ Label 同步

GitHub **不支持** Label 的个人级自动继承，因此通过脚本手动同步。

### 标准源

本仓库（`67762961/.github`）的 Labels 即**唯一标准**，所有项目以此为准。

### 同步目标

- `67762961/Csv_reader`
- `67762961/Paper_sweeper`
- `67762961/Mirror_export`
- `67762961/Driver_Tester`
- `67762961/Wave_controller`

### 使用流程

**1. 修改标准**

前往 https://github.com/67762961/.github/labels 增删改 label（颜色、描述、名称）。

**2. 运行同步脚本**

\`\`\`powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-labels.ps1
\`\`\`

脚本逻辑：
- 从本仓库实时拉取标准 Labels
- 对每个目标仓库：**先删除全部现有 Labels，再按标准重建**
- 结果：目标仓库的 Labels 与本仓库**完全一致**

**3. 验证**

\`\`\`powershell
gh label list --repo 67762961/Csv_reader
\`\`\`

### 修改目标仓库列表

编辑 `scripts/sync-labels.ps1` 顶部的 `$targets` 数组。

### 前置要求

- 安装 [GitHub CLI](https://cli.github.com/)（`gh`）
- 执行 `gh auth login` 完成登录，需要 `repo` 权限

## 📚 参考

- [GitHub Docs: 创建默认社区健康文件](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
- [GitHub Docs: 管理 Labels](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels)