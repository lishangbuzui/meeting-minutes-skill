# 会议纪要整理 Skill GitHub 发布设计

## 目标

将已验证的 `meeting-minutes` Skill 发布到用户自己的公开 GitHub 仓库，既提供可审查、可维护的源码，也提供适合通过浏览器下载和在 Windows 10/11 上安装的版本化 ZIP。

## 已确认决策

- GitHub 仓库名称：`meeting-minutes-skill`
- 可见性：公开
- 默认分支：`main`
- 首个版本：`v1.0.0`
- 许可证：MIT License
- 版权人：创建仓库时读取当前登录的 GitHub 用户名
- 发布方式：源码仓库与 GitHub Release 并行

## 发布范围

仓库只包含通用 Skill 文件：

- `meeting-minutes/`：Skill 主体、界面元数据、格式参考和辅助脚本
- `install-or-update.ps1`：Windows 安装与更新逻辑
- `安装或更新纪要Skill.cmd`：双击安装入口
- `README.md`：公开仓库说明、安装、使用、隐私和更新方法
- `LICENSE`：MIT License
- `版本.txt`：版本及触发语信息
- `使用说明.txt`：离线中文使用说明
- `.gitignore`：排除压缩包、临时文件和本地测试产物
- `docs/superpowers/specs/2026-07-28-meeting-minutes-github-publishing-design.md`：本发布设计

以下内容不进入仓库或 Git 历史：

- 会议录音转写稿和任何测试纪要
- 客户、项目、合同、金额等业务信息
- 当前出差项目中的 Word、TXT 和其他文件
- GitHub 登录信息、访问令牌、Cookie、本机绝对路径和临时文件

## 仓库页面设计

README 使用简体中文，包含：

1. Skill 的用途和主要触发语“整理纪要”
2. 支持的领导汇报、客户确认、团队执行、个人复盘和自定义版本
3. Windows 10/11 与 Codex 桌面版前提
4. GitHub Release 下载、解压和双击安装步骤
5. 当前目录自动发现 TXT、多文件独立处理和 `_v2` 递增规则
6. 默认保留原文信息、按需脱敏和禁止编造规则
7. 源码安装、更新、故障排查和许可证说明

仓库描述使用：`将会议录音转写 TXT 整理为领导汇报、客户确认、团队执行和个人复盘纪要的 Codex Skill。`

## 版本与 Release

1. 将规范化仓库内容提交到 `main`。
2. 创建带说明的 `v1.0.0` 标签。
3. 创建标题为“会议纪要整理 Skill v1.0.0”的 GitHub Release。
4. 上传 `会议纪要Skill-v1.0.0.zip` 作为 Release 附件。
5. Release 说明包含功能摘要、安装步骤、运行环境和 ZIP 的 SHA-256。

## GitHub 操作与授权

通过用户指定且已登录的 Google Chrome 会话操作 GitHub。创建仓库、提交上传、创建标签和发布 Release 都属于明确授权范围。若 Chrome 会话不可控制、登录失效、遇到二次验证或 GitHub 要求额外确认，则停止并请用户在该浏览器中完成认证；不读取 Cookie、密码或令牌，也不切换到其他账号。

## 验证与错误处理

发布前验证：

- Skill 目录结构和 YAML 元数据有效
- PowerShell 脚本无语法错误
- 安装器首次安装和更新备份均成功
- ZIP 条目与源文件一致
- 凭据、客户名称、业务信息和绝对路径扫描无命中

发布后验证：

- 仓库为公开状态，默认分支为 `main`
- 仓库文件和目录完整，无项目私密文件
- `v1.0.0` 标签指向发布提交
- Release 可见，ZIP 附件名称、大小和 SHA-256 正确
- README 中的下载与安装步骤可从仓库首页直接理解

如果任一验证失败，停止后续发布步骤，修复本地公开副本并重新验证；不删除或覆盖已有的远程内容，除非用户明确批准。
