# 邮件运维工程师 Skill / Mail Ops Skill

> An HTML-first email operations skill for [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [OpenAI Codex](https://github.com/openai/codex), and any agent that can run a Python CLI.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.10%2B-blue.svg)](https://www.python.org/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey.svg)]()
[![Skill Type](https://img.shields.io/badge/Skill-Agent%20Ops-purple.svg)]()

*This project is not affiliated with Anthropic or OpenAI.*

---

## 这是什么 / What is this?

**邮件运维工程师 Skill (Mail Ops Skill)** 把 "运维一个邮箱" 这件事打包成一个可以被 AI 代理直接调用的工具集：登录检测、收件箱阅读、搜索、附件下载、HTML 正文起草、发送（含附件 / 内联图片 / 日程 ICS）、定时发送。所有外发邮件统一走 HTML，以保证在 QQ 邮箱、Gmail、Outlook 等客户端的渲染一致。

> **Who is this for?** 需要让 Claude Code / Codex / 自己写的 Agent 真正"去收发邮件"的开发者；尤其是希望在中国区（QQ 邮箱）获得高保真富文本效果的人。

## 功能特性

- **HTML 编辑器效果**：字体、字号、加粗、颜色、背景、列表、表格、引用、分隔线 —— 照搬 QQ 邮箱编辑器所有排版。
- **附件 MIME 自动识别**：docx/xlsx/pptx/pdf 按扩展名自动识别，不再显示为 `.bin`。
- **内联图片 / 自定义表情**：`<img src="cid:xxx">` 引用，HTML 里随处放。
- **日程邀请 (ICS)**：一个参数就能挂上 `text/calendar` 附件，QQ 邮箱会识别为会议。
- **定时邮件发送**：通过 Resend API 创建定时任务，不依赖操作系统 cron / 任务计划程序，跨平台通用。
- **安全删除机制**：软删默认、回收站兜底、硬删仅限回收站内、`confirmed=true` 硬约束 + 审计日志 —— 专门为"AI 代理操邮件"设计的防误删闸门。
- **凭据本地化，开源友好**：凭据文件永远在用户主目录，**绝不进仓库**；`.gitignore` 已排除；可选用系统 keyring。
- **跨平台 & 跨 Agent**：Linux / macOS / Windows 路径自动处理，Claude Code 与 Codex 共读一份配置。
- **无第三方依赖**：仅 Python 标准库，开箱即跑。

## 快速开始

### 1. 安装

```bash
# Linux / macOS
git clone https://github.com/Reznovs/EMail-Ops-skill.git ~/mail-ops-skill
cd ~/mail-ops-skill
```

```powershell
# Windows (PowerShell)
git clone https://github.com/Reznovs/EMail-Ops-skill.git $HOME\mail-ops-skill
cd $HOME\mail-ops-skill
```

> 需要 Python >= 3.10。不需要 `pip install` 任何东西。

### 2. 配置账号（QQ 邮箱示例）

```bash
PYTHONPATH=scripts python3 scripts/mail_client.py setup_account \
  --account default-send --provider qq \
  --email you@qq.com --login-user you@qq.com \
  --auth-mode auth_code --auth-secret <QQ授权码>

PYTHONPATH=scripts python3 scripts/mail_client.py test_login --account default-send
```

QQ 授权码获取：QQ 邮箱「设置 -> 账户 -> POP3/IMAP/SMTP -> 生成授权码」。

### 3. 发一封富文本邮件

```bash
PYTHONPATH=scripts python3 scripts/mail_client.py send_email \
  --account default-send \
  --to someone@example.com \
  --subject "项目周报 2026-W16" \
  --html '<div style="font-family:Microsoft YaHei;font-size:14px;color:#222;line-height:1.7;">
            <p>你好 <strong style="color:#c0392b;">张三</strong>，</p>
            <p>本周进展见附件，下周一 14:00 评审。</p>
          </div>' \
  --attach ./report.docx \
  --inline avatar=./avatar.png \
  --ics-json '{"summary":"评审会","start":"2026-04-20 14:00","end":"2026-04-20 15:00","location":"腾讯会议"}'
```

### 4. 定时发送邮件（Resend API）

定时发送不依赖本机 AI 或操作系统调度，纯 HTTP API 调用，Windows / macOS / Linux 通用。

```bash
# 1) 在 https://resend.com 注册并获取 API Key
export RESEND_API_KEY=re_xxxxxxxx

# 2) 发送一封 5 分钟后到达的邮件
PYTHONPATH=scripts python3 scripts/mail_client.py send_scheduled_email \
  --to someone@example.com \
  --subject "定时提醒" \
  --html '<p>这是一封定时发送的邮件</p>' \
  --delay-minutes 5
```

> 未验证域名时，Resend 测试账户只能使用 `onboarding@resend.dev` 作为发件人，且收件人仅限注册邮箱。要发给任意邮箱，请在 Resend 后台验证自己的域名。

## 凭据存放（开源友好）

**凭据文件永远保存在用户主目录下的系统配置区，不在仓库内。** 仓库只提供 `references/accounts.example.json` 模板。

| 平台 | 默认路径 |
|------|---------|
| Linux / macOS | `${XDG_CONFIG_HOME:-$HOME/.config}/mail-ops/accounts.json` |
| Windows | `%APPDATA%\mail-ops\accounts.json` |
| 自定义 | 环境变量 `MAIL_OPS_ACCOUNTS=/绝对/路径/accounts.json` 优先级最高 |

- 权限自动设为 `0600`，父目录 `0700`（POSIX）。
- 推荐生产使用 `auth.storage="keyring"`（`pip install keyring`），授权码进系统钥匙串，JSON 里只留 `keyring_key` 引用。
- **Claude Code 与 Codex 共享同一路径** —— 默认不设任何变量即可共用；若要自定义，在 `~/.bashrc` / `~/.zshrc` / PowerShell `$PROFILE` 中 `export MAIL_OPS_ACCOUNTS=...`。

## 命令列表

| Command | 用途 |
|---------|------|
| `doctor_account` | 检查配置健康度 |
| `test_login` | 验证 IMAP / SMTP 登录 |
| `setup_account` | 新建 / 更新账号 |
| `migrate_config` | v1 -> v2 配置迁移 |
| `list_folders` | 列出文件夹，自动识别回收站 |
| `list_messages` | 列出最近邮件 |
| `search_messages` | 按关键词搜索 |
| `get_message` | 读取单封邮件详情 |
| `download_attachments` | 下载附件（temp / archive） |
| `draft_email` | 生成 HTML 草稿 |
| `send_email` | 发送 HTML 邮件（支持附件 / 内联图 / ICS） |
| `send_scheduled_email` | 通过 Resend API 定时发送邮件 |
| `trash_messages` | 软删：移到回收站（默认预览模式，`--confirm` 才执行） |
| `restore_messages` | 从回收站恢复 |
| `purge_messages` | 硬删：**仅作用于回收站内邮件**，不可恢复 |

两套入口：

- **机器接口**（JSON in / JSON out）：`python3 scripts/mail_tools.py <name> --input-json '{...}'`
- **人工 CLI**（便于手动调试）：`python3 scripts/mail_client.py <name> [flags...]`

## 删除安全模型（重点）

设计原则：**所有删除至少有一次"回收站兜底"，没有"INBOX -> 永久消失"的直达路径。**

```
INBOX 里的邮件                      回收站内的邮件
      |                                 |
      | trash_messages  (软删)          | restore_messages  (恢复)
      | --confirm                       | --confirm
      v                                 v
  回收站 (Trash)                    任意文件夹 (默认 INBOX)
                                        |
                                        | purge_messages  (硬删)
                                        | --confirm
                                        v
                                  永久删除，不可恢复
```

**防 AI 误删的多重闸门**：

1. **`confirmed=true` 硬约束**：默认 `confirmed=false`，此时工具只返回待删清单（`status:"preview"`），**完全不动邮箱**。
2. **回收站唯一硬删入口**：`purge_messages` 会先在回收站 fetch UID 的 header；任何一个 UID 在回收站里找不到，整次调用直接拒绝。
3. **来源 != 回收站**：`trash_messages` 拒绝把"已经在回收站"的邮件再软删一次（防循环）。
4. **批量上限 50**：单次调用最多处理 50 个 UID。
5. **审计日志**：每次 `trash` / `restore` / `purge` 自动追加到 `~/.config/mail-ops/audit.log`（JSONL，UTC 时间、UID、主题、发件人、操作类型齐全）。日志不进仓库。
6. **SKILL.md 行为契约**：Agent 必须先 `list` + `get` 展示邮件 -> 等用户本回合内 yes/no -> 才能带 `confirmed=true` 调工具；旧回合的 yes 不继承。
7. **硬删需明示**：Agent 只能在用户说"硬删 / 彻底删除 / 不可恢复 / purge / 永久删除"时才允许走 `purge_messages`。

典型用法（软删 + 恢复）：

```bash
# 1) 先预览（不执行，不留副作用）
mail_client.py trash_messages --account default-send --uid 123

# 2) 用户确认后执行
mail_client.py trash_messages --account default-send --uid 123 --confirm

# 3) 后悔了恢复
mail_client.py restore_messages --account default-send --uid 123 --confirm
```

彻底清除（二次确认）：

```bash
# 先软删到回收站
mail_client.py trash_messages --account default-send --uid 123 --confirm
# 然后从回收站永久清除
mail_client.py purge_messages --account default-send --uid 123 --confirm
```

## AI 平台适配

已在 `agents/` 目录提供 Claude Code 和 OpenAI Codex 的适配文件，安装后代理可自动发现并调用本 Skill。

## 目录结构

```
mail-ops-skill/
├── SKILL.md              # Agent 读取的主文件（带 YAML frontmatter）
├── README.md             # 本文件
├── .gitignore            # 已排除 accounts.json / audit.log 等本地产物
├── agents/               # Claude Code / Codex 适配
├── references/
│   ├── accounts.example.json  # 凭据模板（脱敏）
│   ├── providers.md           # IMAP/SMTP 预设
│   ├── storage.md             # 附件存储说明
│   ├── writing-style.md       # HTML 写作规范
│   ├── safety.md              # 删除安全规则
│   └── tool-calls.md          # 机器接口契约
├── scripts/
│   ├── mail_core.py       # 核心逻辑
│   ├── mail_tools.py      # 机器接口（JSON）
│   └── mail_client.py     # 人工 CLI
└── tests/                # 单元测试（Python unittest，15 条）
```

## 测试

```bash
PYTHONPATH=scripts python3 -m unittest discover -s tests -v
```

## 路线图

- [ ] 抄送 / 密送 (Cc / Bcc)
- [ ] 回复 / 转发保留线程 (In-Reply-To / References)
- [ ] Markdown -> HTML 自动转换入口（可选）
- [ ] 更多预设服务商：Outlook 365 / 163 / Yahoo
- [ ] 标记已读 / 未读 / 星标
- [ ] 跨文件夹移动（非回收站目的地）

## 参与贡献

欢迎 PR。提交前请确保：

1. 单元测试通过：`python3 -m unittest discover -s tests`
2. 不要在提交中引入任何 `accounts.json`、授权码或其他真实凭据。
3. 新功能请同步更新 `SKILL.md` 与 `references/` 下相应文档。

## 许可证

[MIT](LICENSE) (c) Reznovs

## 致谢

- Anthropic [Agent Skills](https://github.com/anthropics/skills) 规范与示例
