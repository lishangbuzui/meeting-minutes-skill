# 会议纪要整理 Skill GitHub 发布实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将已验证的 `meeting-minutes` Skill 发布到 `lishangbuzui/meeting-minutes-skill` 公开仓库，并创建可直接下载安装的 `v1.0.0` Release。

**Architecture:** 在独立本地 Git 仓库中组装公开副本，保留 Skill 源码、Windows 安装器和公开文档；通过哈希、语法、隐私和隔离安装测试后提交并打标签。使用临时便携版 GitHub CLI 发起网页设备授权，推送本地 Git 历史并创建 Release，最后通过 GitHub API 和仓库页面复核。

**Tech Stack:** Git、PowerShell 5.1、Codex Skill Markdown/YAML、GitHub CLI、GitHub Release、Windows 10/11

## Global Constraints

- 远程仓库固定为公开仓库 `lishangbuzui/meeting-minutes-skill`，默认分支为 `main`。
- 首个版本、Git 标签和 Release 固定为 `v1.0.0`。
- 使用 MIT License，版权人为 `lishangbuzui`，年份为 `2026`。
- 只发布通用 Skill、安装器和公开说明；会议原稿、测试纪要、客户及项目业务信息不得进入 Git 历史。
- 不读取或保存浏览器 Cookie、Google 密码、GitHub 密码、访问令牌或验证码。
- GitHub CLI 仅使用临时便携副本；授权完成后删除临时程序，认证由 GitHub 官方设备流程管理。
- 所有现有 Skill 和安装脚本保持行为不变；发布整理只增加仓库级文档和复制已验证文件。

---

## File Map

- Create: `README.md` - 公开项目说明、功能、安装、使用、隐私和更新方法。
- Create: `LICENSE` - MIT License 全文。
- Create: `.gitignore` - 排除 ZIP、临时验证和安装测试目录。
- Copy: `meeting-minutes/` - 从 `../meeting-minutes-v1.0.0/meeting-minutes/` 复制已验证 Skill。
- Copy: `install-or-update.ps1` - 从 `../meeting-minutes-v1.0.0/install-or-update.ps1` 复制。
- Copy: `安装或更新纪要Skill.cmd` - 从 `../meeting-minutes-v1.0.0/安装或更新纪要Skill.cmd` 复制。
- Copy: `版本.txt` - 从 `../meeting-minutes-v1.0.0/版本.txt` 复制。
- Copy: `使用说明.txt` - 从 `../meeting-minutes-v1.0.0/使用说明.txt` 复制。
- Existing: `docs/superpowers/specs/2026-07-28-meeting-minutes-github-publishing-design.md` - 已批准设计。
- Create: `docs/superpowers/plans/2026-07-28-meeting-minutes-github-publishing.md` - 本实施计划。
- Release only: `../会议纪要Skill-v1.0.0.zip` - 上传为 Release 附件，不提交到 Git。

### Task 1: 组装公开仓库

**Files:**
- Create: `README.md`
- Create: `LICENSE`
- Create: `.gitignore`
- Copy: `meeting-minutes/`
- Copy: `install-or-update.ps1`
- Copy: `安装或更新纪要Skill.cmd`
- Copy: `版本.txt`
- Copy: `使用说明.txt`

**Interfaces:**
- Consumes: 已验证安装包 `../meeting-minutes-v1.0.0/`。
- Produces: 可独立审查、安装和发布的公开仓库工作树。

- [ ] **Step 1: 记录组装前基线**

Run:

```powershell
git status --short --branch
git ls-files
```

Expected: 分支为 `main`，只跟踪已提交的设计文档和本实施计划。

- [ ] **Step 2: 复制已验证发布文件**

Run from repository root:

```powershell
Copy-Item -LiteralPath '..\meeting-minutes-v1.0.0\meeting-minutes' -Destination '.\meeting-minutes' -Recurse
Copy-Item -LiteralPath '..\meeting-minutes-v1.0.0\install-or-update.ps1' -Destination '.\install-or-update.ps1'
Copy-Item -LiteralPath '..\meeting-minutes-v1.0.0\安装或更新纪要Skill.cmd' -Destination '.\安装或更新纪要Skill.cmd'
Copy-Item -LiteralPath '..\meeting-minutes-v1.0.0\版本.txt' -Destination '.\版本.txt'
Copy-Item -LiteralPath '..\meeting-minutes-v1.0.0\使用说明.txt' -Destination '.\使用说明.txt'
```

Expected: 复制 5 个 Skill 文件和 4 个根目录发布文件，不复制 ZIP、测试纪要或当前项目其他文件。

- [ ] **Step 3: 创建公开 README**

Create `README.md` with exactly these sections and content:

```markdown
# 会议纪要整理 Skill

将格式不固定、通常没有说话人和时间戳的会议录音转写 TXT，整理为适合不同用途的简体中文会议纪要。

## 支持的纪要类型

- 领导汇报版
- 客户确认版
- 团队执行版
- 个人复盘版
- 自定义用途

可一次选择多个 TXT 和多个纪要类型。每个原稿独立处理，每种版本保存为独立文件。

## 运行环境

- Windows 10 或 Windows 11
- Codex 桌面版

## 安装

1. 从 [Releases](https://github.com/lishangbuzui/meeting-minutes-skill/releases) 下载 `会议纪要Skill-v1.0.0.zip`。
2. 完整解压 ZIP，不要直接在压缩包内运行。
3. 双击 `安装或更新纪要Skill.cmd`。
4. 安装成功后重启 Codex 桌面版，或新建一个任务。

安装器会将 Skill 安装到当前用户的 Codex 全局 Skills 目录。更新已有版本时，会先在 `.codex/skill-backups` 中保留旧版备份。

## 使用

1. 把一个或多个会议转写 `.txt` 放到当前项目文件夹。
2. 在 Codex 中说：`整理纪要`。
3. 当前文件夹有多个 TXT 时，选择一个或多个原稿。
4. 选择一个或多个纪要类型。

输出文件与原稿保存在同一目录。同名文件已存在时自动生成 `_v2`、`_v3`，不会覆盖旧文件。

## 内容规则

- 根据上下文修正明显的转写错误和不通顺语句。
- 无法可靠判断的内容保留最接近原文的表达，并标注“待确认”。
- 缺少会议名称、日期、地点或参会人员时写“未提供”。
- 负责人或截止时间不明确时写“待明确”。
- 不添加原稿没有的事实、人员、金额、日期或决定。
- 默认保留原文信息；只有明确要求时才脱敏。

## 源码安装

将仓库中的 `meeting-minutes` 文件夹复制到：

```text
%USERPROFILE%\.codex\skills\meeting-minutes
```

随后重启 Codex 桌面版或新建任务。

## 更新

下载新版 Release，解压后再次运行 `安装或更新纪要Skill.cmd`。安装器会自动备份现有版本。

## 隐私

Skill 在当前工作区读取用户选择的 TXT，并把纪要写回原稿目录。仓库和安装包不包含任何会议原稿、测试纪要、客户资料或访问凭据。

## License

[MIT License](LICENSE)
```

- [ ] **Step 4: 创建 MIT License 和忽略规则**

Create `LICENSE`:

```text
MIT License

Copyright (c) 2026 lishangbuzui

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

Create `.gitignore`:

```gitignore
*.zip
.skill-validator-deps/
_installer-test/
*.tmp
*.bak
Thumbs.db
Desktop.ini
```

- [ ] **Step 5: 运行公开内容扫描**

Run:

```powershell
rg -n -i "github_pat_|ghp_|api[_-]?key|access[_-]?token|client[_-]?secret|password|passwd|authorization:|bearer[ ]" . -g '!.git/**' -g '!docs/superpowers/**'
rg -n -i "[A-Z]:\\|C:/Users/|D:/" . -g '!.git/**' -g '!docs/superpowers/**'
rg -n "李志强|珠海云洲|核心网|北斗三号|常州|绍兴|雷海" . -g '!.git/**' -g '!docs/superpowers/**'
```

Expected: 三条命令均无输出；`rg` 退出码 1 表示没有匹配，是通过状态。

- [ ] **Step 6: 提交公开仓库内容**

Run:

```powershell
git add README.md LICENSE .gitignore meeting-minutes install-or-update.ps1 安装或更新纪要Skill.cmd 版本.txt 使用说明.txt docs/superpowers/plans/2026-07-28-meeting-minutes-github-publishing.md
git commit -m "feat: publish meeting minutes skill v1.0.0"
```

Expected: 创建一个包含公开发布内容的提交，`git status --short` 无输出。

### Task 2: 验证源码、安装器和 Release 附件

**Files:**
- Verify: `meeting-minutes/`
- Verify: `install-or-update.ps1`
- Verify: `安装或更新纪要Skill.cmd`
- Verify: `../会议纪要Skill-v1.0.0.zip`

**Interfaces:**
- Consumes: Task 1 生成的公开工作树。
- Produces: 可发布的提交和指向该提交的 `v1.0.0` 标签。

- [ ] **Step 1: 比较 Skill 与已验证安装副本**

Run a recursive SHA-256 comparison between `meeting-minutes/` and `%USERPROFILE%/.codex/skills/meeting-minutes/`.

Expected: 两侧均为 5 个文件，差异数为 0。

- [ ] **Step 2: 检查 PowerShell 语法**

Run `System.Management.Automation.Language.Parser.ParseFile` against every `.ps1` under the repository.

Expected: `install-or-update.ps1`、`list-transcripts.ps1` 和 `resolve-output-path.ps1` 均为 0 个解析错误。

- [ ] **Step 3: 隔离测试首次安装和更新备份**

Set `CODEX_HOME` to a new `_installer-test` directory under the repository, run `install-or-update.ps1` twice with `ExecutionPolicy Bypass`, then compare installed Skill hashes with `meeting-minutes/`.

Expected: 两次安装均退出码 0；第二次输出旧版备份路径；已安装文件数为 5、哈希差异为 0、备份目录数为 1。

- [ ] **Step 4: 清理隔离测试目录**

Resolve `_installer-test` to an absolute path, assert it starts with the repository root plus a path separator, then remove only that directory recursively.

Expected: `_installer-test` 不存在，Skill 源码和仓库文件保持不变。

- [ ] **Step 5: 验证 Release ZIP**

Open `../会议纪要Skill-v1.0.0.zip` with `System.IO.Compression.ZipFile` and enumerate entries.

Expected: 9 个条目；大小为 8118 字节；SHA-256 为 `07908A1DD79AD47ED18C69C301331A2A02B313E9C19F63E0C7DADE8988E6E8D8`。

- [ ] **Step 6: 创建本地版本标签**

Run:

```powershell
git tag -a v1.0.0 -m "会议纪要整理 Skill v1.0.0"
git show --no-patch --decorate v1.0.0
```

Expected: `v1.0.0` 指向 Task 1 的发布提交。

### Task 3: 认证并发布到 GitHub

**Files:**
- Temporary: `%TEMP%/meeting-minutes-gh-cli/`
- Remote: `https://github.com/lishangbuzui/meeting-minutes-skill`

**Interfaces:**
- Consumes: Task 2 的已验证本地仓库、标签和 Release ZIP。
- Produces: 公开 GitHub 仓库、远程标签和 `v1.0.0` Release。

- [ ] **Step 1: 获取 GitHub CLI 临时便携版**

Query `https://api.github.com/repos/cli/cli/releases/latest`, select the single asset matching `gh_*_windows_amd64.zip`, download it to a new `%TEMP%/meeting-minutes-gh-cli/` directory, verify the asset came from `github.com/cli/cli`, and expand it there.

Expected: 临时目录中出现可运行的 `gh.exe`；不执行 MSI，不修改系统 PATH。

- [ ] **Step 2: 通过网页设备流程认证**

Run from the temporary executable:

```powershell
gh auth login --hostname github.com --git-protocol https --web
```

Expected: GitHub 官方设备授权页面在默认浏览器打开；用户确认账号 `lishangbuzui` 后，`gh auth status` 显示已登录。若需要密码、Cookie 或手工访问令牌，立即停止。

- [ ] **Step 3: 创建并推送公开仓库**

Run:

```powershell
gh repo create lishangbuzui/meeting-minutes-skill --public --source . --remote origin --push --description "将会议录音转写 TXT 整理为领导汇报、客户确认、团队执行和个人复盘纪要的 Codex Skill。"
git push origin v1.0.0
```

Expected: 创建公开仓库，`main` 与 `v1.0.0` 推送成功。若仓库已存在，停止并检查其内容，不覆盖。

- [ ] **Step 4: 创建 GitHub Release**

Run:

```powershell
gh release create v1.0.0 "../会议纪要Skill-v1.0.0.zip" --repo lishangbuzui/meeting-minutes-skill --title "会议纪要整理 Skill v1.0.0" --notes "首个公开版本。支持领导汇报、客户确认、团队执行、个人复盘和自定义纪要；适用于 Windows 10/11 与 Codex 桌面版。下载 ZIP 后完整解压并双击安装脚本。SHA-256：07908A1DD79AD47ED18C69C301331A2A02B313E9C19F63E0C7DADE8988E6E8D8"
```

Expected: Release 发布成功，附件名称为 `会议纪要Skill-v1.0.0.zip`。

- [ ] **Step 5: 注销本次授权并清理临时 GitHub CLI**

Run `gh auth logout --hostname github.com --user lishangbuzui` to remove the OAuth credential created in Step 2. Then resolve `%TEMP%/meeting-minutes-gh-cli/` to an absolute path, assert it is a child of the system temporary directory, and remove only that temporary directory. Do not remove any broader GitHub configuration directory.

Expected: `gh auth status` no longer reports an authenticated `lishangbuzui` session; the temporary program directory is deleted; the repository and remote Release remain available.

### Task 4: 发布后验证

**Files:**
- Verify remote: `https://github.com/lishangbuzui/meeting-minutes-skill`
- Verify Release: `https://github.com/lishangbuzui/meeting-minutes-skill/releases/tag/v1.0.0`

**Interfaces:**
- Consumes: Task 3 的远程仓库与 Release。
- Produces: 可交付的发布验证记录。

- [ ] **Step 1: 使用 GitHub API 验证仓库元数据**

Run `gh repo view lishangbuzui/meeting-minutes-skill --json nameWithOwner,visibility,defaultBranchRef,url,description`.

Expected: `nameWithOwner` 为 `lishangbuzui/meeting-minutes-skill`，`visibility` 为 `PUBLIC`，默认分支为 `main`，描述与计划一致。

- [ ] **Step 2: 验证远程文件清单和标签**

Run `gh api repos/lishangbuzui/meeting-minutes-skill/git/trees/main?recursive=1` and `git ls-remote --tags origin v1.0.0`.

Expected: 远程文件只来自 File Map；无会议原稿、测试纪要或业务文件；远程存在 `v1.0.0` 标签。

- [ ] **Step 3: 验证 Release 和附件**

Run `gh release view v1.0.0 --repo lishangbuzui/meeting-minutes-skill --json name,isDraft,isPrerelease,url,assets`.

Expected: 标题正确，`isDraft=false`，`isPrerelease=false`，附件名称为 `会议纪要Skill-v1.0.0.zip`，附件大小为 8118 字节。

- [ ] **Step 4: 浏览器最终检查**

Open the repository and Release URLs in the user-authorized browser. Verify README renders, MIT License is detected, repository shows Public, and Release download is visible. Do not inspect cookies, account settings, passwords, tokens, or unrelated repositories.

- [ ] **Step 5: 报告发布结果**

Report the public repository URL, Release URL, tag, ZIP name, byte size, SHA-256, verification results, and any authentication or browser limitation encountered.
