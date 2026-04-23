# Mail Ops Skill / 邮件运维工程师

> 让 AI Agent 真正收发邮件。HTML 富文本、附件、日程邀请、定时发送、安全删除，开箱即用。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.10%2B-blue.svg)](https://www.python.org/)

**解决什么问题？** 现有 AI 工具大多只能"写"邮件，不能"发"邮件。Mail Ops Skill 把完整的邮箱操作（读、搜、发、删、定时）打包成 Agent 可直接调用的 CLI 工具集，零第三方依赖，跨平台通用。

## 核心能力

| 能力 | 说明 |
|------|------|
| 📧 HTML 富文本发送 | 内联 CSS，QQ / Gmail / Outlook 渲染一致 |
| 📎 附件自动识别 | docx / xlsx / pptx / pdf 按扩展名正确识别 MIME |
| 📅 日程邀请 | 一键生成 ICS 附件，QQ 邮箱自动识别为会议 |
| ⏰ 定时发送 | 基于 Resend API，不依赖 cron / 任务计划程序 |
| 🛡️ 安全删除 | 软删默认、回收站兜底、硬删需二次确认 + 审计日志 |
| 🔐 凭据本地化 | 账号信息保存在用户主目录，绝不在仓库内 |

## 一分钟上手

```bash
git clone https://github.com/Reznovs/EMail-Ops-skill.git
cd EMail-Ops-skill

# 配置 QQ 邮箱（或 Gmail / 自定义）
PYTHONPATH=scripts python3 scripts/mail_client.py setup_account \
  --account default --provider qq \
  --email you@qq.com --auth-mode auth_code --auth-secret <授权码>

# 发邮件
PYTHONPATH=scripts python3 scripts/mail_client.py send_email \
  --account default --to someone@example.com \
  --subject "周报" --html '<p>本周进展 <strong>正常</strong>。</p>'

# 定时发送（需要 RESEND_API_KEY）
export RESEND_API_KEY=re_xxxxxxxx
PYTHONPATH=scripts python3 scripts/mail_client.py send_scheduled_email \
  --to someone@example.com --subject "定时提醒" \
  --html '<p>3 分钟后到达</p>' --delay-minutes 3
```

> 凭据文件默认保存在 `~/.config/mail-ops/accounts.json`（POSIX）或 `%APPDATA%\mail-ops\accounts.json`（Windows）。

## 两套接口

- **人工调试**：`python3 scripts/mail_client.py <command> [flags...]`
- **机器调用**：`python3 scripts/mail_tools.py <tool> --input-json '{...}'`

常用命令：`send_email`、`send_scheduled_email`、`list_messages`、`search_messages`、`get_message`、`download_attachments`、`trash_messages`、`restore_messages`、`purge_messages`、`setup_account`、`test_login`。

---

## 给 AI Agent 的 Prompt

```
You have access to the Mail Ops Skill for email operations.

Installation:
1. Clone https://github.com/Reznovs/EMail-Ops-skill.git
2. All commands require PYTHONPATH=scripts prefix

Account setup (run once):
  PYTHONPATH=scripts python3 scripts/mail_tools.py setup_account --input-json '
  {"account":"default","provider":"qq","email":"you@qq.com","login_user":"you@qq.com","auth_mode":"auth_code","auth_secret":"YOUR_AUTH_CODE"}'

Usage:
- Send email:       send_email --input-json '{"account":"default","to":"x@qq.com","subject":"s","html_body":"<p>h</p>"}'
- Schedule email:   send_scheduled_email --input-json '{"to":"x@qq.com","subject":"s","html_body":"<p>h</p>","delay_minutes":5}'
- List messages:    list_messages --input-json '{"account":"default","folder":"INBOX","limit":20}'
- Search:           search_messages --input-json '{"account":"default","query":"keyword"}'
- Read message:     get_message --input-json '{"account":"default","uid":"123"}'
- Trash (preview):  trash_messages --input-json '{"account":"default","uids":["123"]}'
- Trash (confirm):  trash_messages --input-json '{"account":"default","uids":["123"],"confirmed":true}'
- Restore:          restore_messages --input-json '{"account":"default","uids":["123"],"confirmed":true}'

Rules:
- All outgoing mail is HTML with inline CSS.
- Deletion defaults to preview (confirmed=false). Never call purge_messages unless the user explicitly says "purge / hard delete / permanently delete".
- send_scheduled_email requires RESEND_API_KEY env var (Resend API).
```
