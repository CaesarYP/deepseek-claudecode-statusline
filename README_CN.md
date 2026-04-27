# deepseek-claudecode-statusline

[English](README.md)

在 Claude Code 输入框下方显示 [DeepSeek API](https://platform.deepseek.com/) 余额。

## 效果

```
DeepSeek: 9.74CNY 充值:10 赠金:0
```

英文模式：

```
DeepSeek: 9.74CNY top-up:10 grant:0
```

## 快速开始

### 1. 保存 DeepSeek API key

```bash
echo "sk-your-deepseek-api-key" > ~/.deepseek_balance_key
chmod 600 ~/.deepseek_balance_key
```

### 2. 配置 Claude Code 状态行

在 `~/.claude/settings.json`（用户级）或 `.claude/settings.local.json`（项目级）中添加：

```json
{
  "statusLine": {
    "type": "command",
    "command": "/path/to/deepseek-claudecode-statusline/statusline-deepseek.sh",
    "refreshInterval": 120
  }
}
```

把 `/path/to/` 替换为你 clone 本仓库的实际路径。

### 3. 重启 Claude Code

新开一个 Claude Code 会话，余额就会出现在输入框下方。

## 配置

以下所有选项都写入和第 2 步相同的配置文件 — `~/.claude/settings.json` 或 `.claude/settings.local.json`。将它们与你已有的 `statusLine` 块合并即可。

### 语言

设置环境变量 `DEEPSEEK_BALANCE_LANG`。默认：`zh`（中文）。

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

| 值 | 充值显示 | 赠金显示 | 无 key 提示 |
|-------|-----------|---------|-------------|
| `zh`（默认） | 充值 | 赠金 | 配置余额 |
| `en` | top-up | grant | 较短提示 |

### 货币过滤

设置 `DEEPSEEK_BALANCE_CURRENCY` 只显示指定货币。默认显示全部。

```json
{
  "env": {
    "DEEPSEEK_BALANCE_CURRENCY": "CNY"
  }
}
```

| 值 | 显示 |
|-------|-------|
| 不设置 | 全部货币，` \| ` 分隔 |
| `CNY` | 仅人民币 |
| `USD` | 仅美元 |

### refreshInterval

API 调用间隔（秒）。默认 `120`（2 分钟）。

```json
{
  "statusLine": {
    "refreshInterval": 300
  }
}
```

### 完整示例

一份真实的 `~/.claude/settings.json`，同时包含状态行、余额语言/货币配置、以及 DeepSeek API 路由：

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

## 工作原理

- 调用 DeepSeek [`/user/balance`](https://api-docs.deepseek.com/zh-cn/api/get-user-balance) 接口
- 解析 JSON 响应：`total_balance`、`topped_up_balance`、`granted_balance`、`currency`
- 显示在 Claude Code 状态行

## API key 安全

- Key 存储在 `~/.deepseek_balance_key`（权限 `600`）
- 此文件**不会**提交到 git
- 每个用户设置自己的 key

## 依赖

- `curl`
- `python3`
- Claude Code
- DeepSeek API key

## License

MIT
