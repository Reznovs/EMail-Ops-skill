# Provider Rules

## Supported Providers

- `gmail`
- `qq`
- `custom`

Do not present other built-in presets as available.

## Config Location

Default config file（三平台统一）:

```text
Linux:   ~/.config/mail-ops/accounts.json
macOS:   ~/Library/Application Support/mail-ops/accounts.json
Windows: %APPDATA%/mail-ops/accounts.json
```

Override path with:

```bash
export MAIL_OPS_ACCOUNTS=/custom/path/accounts.json
```

## Setup Sequence

1. `doctor_account`
2. `migrate_config` when the file is still `v1`
3. `setup_account`
4. `test_login`

## Provider Notes

### Gmail

- Prefer `app_password`
- Add a proxy only when the current network requires it

### QQ

- Enable IMAP/SMTP in QQ Mail settings first
- Use an `auth_code`
- Do not add a proxy by default

### Custom

- Supply explicit IMAP and SMTP hosts, ports, and security mode via `imap_host`, `imap_port`, `imap_security`, `smtp_host`, `smtp_port`, `smtp_security` parameters
- Provider name must be `"custom"`

## Minimal Setup Inputs

- `provider` (`gmail`, `qq`, or `custom`)
- `email`
- `display_name`
- `login_user` when it differs from `email`
- `auth_code` when available
- For `custom`: `imap_host`, `imap_port`, `smtp_host`, `smtp_port` (required); `imap_security`, `smtp_security` (optional, defaults to `ssl`)
- proxy settings only when required
