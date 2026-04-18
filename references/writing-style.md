# Writing Style

## Default Tone

- natural
- direct
- polite but not stiff
- clear about the next step

## Default Structure (HTML)

所有外发邮件均为 HTML 正文，用内联样式以兼容 QQ 邮箱。最小模板：

```html
<div style="font-family:'Microsoft YaHei','PingFang SC',Arial,sans-serif;font-size:14px;color:#222;line-height:1.7;">
  <p>Hi <strong>&lt;Name&gt;</strong>,</p>
  <p>&lt;Reason for writing.&gt;</p>
  <p>&lt;Main point or update.&gt;</p>
  <p>&lt;Requested action or next step.&gt;</p>
  <p>Thanks,<br>&lt;Sender Name&gt;</p>
</div>
```

需要强调时用 `<strong>`、`<em>`、`<span style="color:...;background:...;">`、列表、表格、`<blockquote>` 等；Unicode 表情直接写入；自定义图片/表情用 `cid:` 引用（`inline_images` 参数）。

## Send Rules

- If recipients are ambiguous, stop and clarify
- If attachments are mentioned but paths are missing, stop and clarify
- If the user asks for a draft, do not send
- **All mail is authored as HTML.** Use inline CSS for fonts, sizes, colors, backgrounds, and emphasis so QQ Mail renders them correctly.
- Plain-text alternative is auto-derived; do not write one by hand.
- Custom emoji / images go via `inline_images` (cid references). Unicode emoji can be inlined directly.
- Calendar / schedule invites go via `ics_event`, `ics_file`, or `ics_content`; they land as a `text/calendar` attachment.
