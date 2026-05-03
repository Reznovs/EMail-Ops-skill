# Mail Ops Skill

> 让 AI Agent 真正收发邮件。HTML 富文本、附件、日程邀请、定时发送、安全删除，零依赖，开箱即用。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.10%2B-blue.svg)](https://www.python.org/)

## 这是什么？

一个纯 Python 邮件运维工具包，专为 AI Agent 设计。不依赖任何第三方库，直接用 Python 标准库完成 IMAP 收信、SMTP 发信。AI Agent 通过简单的 JSON 调用就能完成完整的邮件操作。

## 能做什么？

| 能力 | 说明 |
|------|------|
| HTML 富文本发送 | 内联 CSS，QQ / Gmail / Outlook 渲染一致 |
| 附件 | docx / xlsx / pptx / pdf 自动识别 MIME 类型 |
| 日程邀请 | 一键生成 ICS 附件，QQ 邮箱自动识别为会议 |
| 定时发送 | 基于 Resend API，无需 cron / 任务计划 |
| 安全删除 | 默认移到回收站，硬删需二次确认 + 审计日志 |
| 跨平台 | Windows / Linux / macOS 配置统一 |

## 使用场景

**发邮件**
```
用户：帮我给张三发一份周报，告诉他项目进展正常
AI：自动起草 HTML 邮件 → 发送 → 确认送达
```

**收邮件**
```
用户：看看今天有没有新邮件
AI：连接邮箱 → 列出最新邮件 → 摘要呈现
```

**定时提醒**
```
用户：3 分钟后提醒我开会
AI：调用 Resend API → 3 分钟后邮件到达
```

**安全删除**
```
用户：把那封垃圾邮件删了
AI：预览确认 → 移到回收站 → 告知可恢复
```

## 项目结构

```
SKILL.md                          # Skill 入口定义
scripts/
├── mail_core.py                  # 核心逻辑（IMAP/SMTP/配置/删除安全）
├── mail_tools.py                 # JSON 工具调度器（AI Agent 入口）
└── mail_client.py                # 人工 CLI 接口
references/
├── tool-calls.md                 # 工具调用参数文档
├── safety.md                     # 删除安全规则
├── writing-style.md              # HTML 邮件写作规范
├── providers.md                  # 邮箱服务商配置说明
├── storage.md                    # 附件存储模式
└── accounts.example.json         # 配置文件示例
config/
└── accounts.json                 # 实际配置（git 不追踪）
tests/
└── test_mail_tools.py            # 单元测试（21 项）
```

## 安装

**方式一：让 AI 帮你装（推荐）**

把 [INSTALL.md](INSTALL.md) 的内容喂给 AI，它会引导你完成安装。

**方式二：手动安装**

```bash
git clone https://github.com/Reznovs/EMail-Ops-skill.git
cd EMail-Ops-skill

# 参考 references/accounts.example.json 创建 config/accounts.json
# 然后测试连接
scripts/mail_tools.sh test_login --input-json '{}'
```

## 两套接口

| 接口 | 命令 | 适用场景 |
|------|------|----------|
| AI 工具调用 | `scripts/mail_tools.sh <tool> --input-json '{...}'` | Agent 自动化 |
| 人工 CLI | `scripts/mail_client.sh <command> [flags...]` | 手动调试 |

所有命令的 shell 入口脚本会自动探测 Python 解释器，兼容 Linux / macOS / Windows（python3 → python → py）。

## 支持的邮箱

- QQ 邮箱（推荐，使用授权码）
- Gmail（使用应用专用密码）
- 自定义 IMAP/SMTP 服务器

## License

MIT
