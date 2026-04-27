# deepseek-claudecode-statusline

[中文版](README_CN.md)

Display your [DeepSeek API](https://platform.deepseek.com/) balance right below the Claude Code input box.

## How it looks

```
DeepSeek: 9.74CNY 充值:9.74 赠金:0
```

or in English:

```
DeepSeek: 9.74CNY top-up:9.74 grant:0
```

## Quick start

### 1. Save your DeepSeek API key

```bash
echo "sk-your-deepseek-api-key" > ~/.deepseek_balance_key
chmod 600 ~/.deepseek_balance_key
```

### 2. Configure Claude Code status line

Add to `~/.claude/settings.json` (user-level) or `.claude/settings.local.json` (project-level):

```json
{
  "statusLine": {
    "type": "command",
    "command": "/path/to/deepseek-claudecode-statusline/statusline-deepseek.sh",
    "refreshInterval": 120
  }
}
```

Replace `/path/to/` with the actual path where you cloned this repo.

### 3. Restart Claude Code

Start a new Claude Code session. The balance will appear below the input box.

## Configuration

All options below go in the same settings file as step 2 — `~/.claude/settings.json` or `.claude/settings.local.json`. Merge them with your existing `statusLine` block.

### Language

Set `DEEPSEEK_BALANCE_LANG` env var. Default: `zh` (Chinese).

```json
{
  "env": {
    "DEEPSEEK_BALANCE_LANG": "en"
  },
  "statusLine": {
    "type": "command",
    "command": "~/deepseek-claudecode-statusline/statusline-deepseek.sh",
    "refreshInterval": 120
  }
}
```

| Value | topped-up | granted | no-key hint |
|-------|-----------|---------|-------------|
| `zh` (default) | 充值 | 赠金 | 配置余额 |
| `en` | top-up | grant | (shorter hint) |

### Currency filter

Set `DEEPSEEK_BALANCE_CURRENCY` to show only one currency. Default: show all.

```json
{
  "env": {
    "DEEPSEEK_BALANCE_CURRENCY": "CNY"
  }
}
```

| Value | Shows |
|-------|-------|
| (unset) | All currencies, ` \| ` separated |
| `CNY` | CNY balance only |
| `USD` | USD balance only |

### refreshInterval

Seconds between API calls. Default: `120` (2 minutes).

```json
{
  "statusLine": {
    "refreshInterval": 300
  }
}
```

### Complete example

A realistic `~/.claude/settings.json` with statusline, DeepSeek balance env vars, and DeepSeek API routing all together:

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "sk-your-deepseek-api-key",
    "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
    "ANTHROPIC_MODEL": "deepseek-v4-pro[1m]",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-v4-flash",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-v4-pro[1m]",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-v4-pro[1m]",
    "CLAUDE_CODE_SUBAGENT_MODEL": "deepseek-v4-flash",
    "DEEPSEEK_BALANCE_LANG": "zh",
    "DEEPSEEK_BALANCE_CURRENCY": "CNY"
  },
  "statusLine": {
    "type": "command",
    "command": "~/deepseek-claudecode-statusline/statusline-deepseek.sh",
    "refreshInterval": 120
  }
}
```

## How it works

- Calls DeepSeek [`/user/balance`](https://api-docs.deepseek.com/zh-cn/api/get-user-balance) API
- Parses the JSON response: `total_balance`, `topped_up_balance`, `granted_balance`, `currency`
- Displays in the Claude Code status line

## API key security

- Key stored in `~/.deepseek_balance_key` (permission `600`)
- This file is **not** committed to git
- Each user sets their own key

## Requirements

- `curl`
- `python3`
- Claude Code
- DeepSeek API key

## License

MIT

