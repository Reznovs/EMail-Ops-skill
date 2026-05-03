# AI 安装引导

把这个链接丢给 AI 就能完成安装：`https://github.com/Reznovs/EMail-Ops-skill`

---

以下内容是给 AI 看的安装引导 Prompt。你可以直接复制下面整段内容发给 AI，它会帮你完成全部配置。

---

## Prompt（复制给 AI）

```
你需要帮我安装和配置 Mail Ops Skill。项目地址：https://github.com/Reznovs/EMail-Ops-skill

请按以下步骤操作：

## 第一步：克隆项目

git clone https://github.com/Reznovs/EMail-Ops-skill.git
cd EMail-Ops-skill

## 第二步：引导我提供信息

请用提问的方式依次获取以下三个信息：

1. 发件邮箱 —— AI 用来收发邮件的邮箱地址
2. 发件邮箱的授权码 —— 不是邮箱密码，是专门的授权码
3. 收件邮箱 —— 你希望收到通知邮件的地址

### QQ 邮箱获取授权码的步骤（默认引导用户按此操作）：

第一步：打开 https://wx.mail.qq.com/home/index 并登录
第二步：点击「设置」
第三步：点击「账号与安全」
第四步：点击「安全设置」
第五步：找到「IMAP/SMTP 服务」，点击「生成授权码」

> 如果用户使用 Gmail，引导他开启两步验证后生成「应用专用密码」。

## 第三步：写入配置

收集到信息后，运行以下命令创建配置（把实际值替换进去）：

scripts/mail_tools.sh setup_account --input-json '{
  "provider": "qq",
  "email": "<发件邮箱>",
  "auth_code": "<授权码>",
  "display_name": "AI Agent",
  "recipients": [
    {"email": "<收件邮箱>", "name": "Me", "main": true}
  ]
}'

> 如果是 Gmail，把 provider 改为 "gmail"。

## 第四步：验证连接

scripts/mail_tools.sh test_login --input-json '{}'

看到 "test_login_status": "ok" 就说明配置成功。

## 第五步：发一封测试邮件

scripts/mail_tools.sh send_email --input-json '{
  "subject": "Mail Ops Skill 配置成功",
  "html_body": "<p>如果你看到这封邮件，说明配置一切正常！</p>"
}'

配置完成。之后你可以直接让我帮你收发邮件。
```

---

## 常用工具一览

| 工具 | 用途 |
|------|------|
| `send_email` | 发送邮件（HTML 格式，支持附件） |
| `send_scheduled_email` | 定时发送（需 Resend API Key） |
| `list_messages` | 列出最新邮件 |
| `search_messages` | 搜索邮件 |
| `get_message` | 读取指定邮件 |
| `download_attachments` | 下载附件 |
| `register_attachments` | 注册本地文件为附件 |
| `trash_messages` | 软删除（移到回收站） |
| `restore_messages` | 从回收站恢复 |
| `purge_messages` | 硬删除（仅限回收站内，不可恢复） |
| `list_folders` | 列出邮箱文件夹 |
