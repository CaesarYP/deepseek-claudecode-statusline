#!/bin/bash
# deepseek-claudecode-statusline
# Display DeepSeek API balance in Claude Code status line
# https://github.com/your-org/deepseek-claudecode-statusline
#
# Setup:
#   echo "sk-your-deepseek-api-key" > ~/.deepseek_balance_key
#   chmod 600 ~/.deepseek_balance_key
#
# Optional env vars:
#   DEEPSEEK_BALANCE_LANG=zh|en     (default: zh)
#   DEEPSEEK_BALANCE_CURRENCY=CNY|USD  (default: show all)

KEY_FILE="$HOME/.deepseek_balance_key"
API_URL="https://api.deepseek.com/user/balance"
LANG="${DEEPSEEK_BALANCE_LANG:-zh}"
FILTER_CURRENCY="${DEEPSEEK_BALANCE_CURRENCY:-}"

if [ ! -f "$KEY_FILE" ]; then
  if [ "$LANG" = "en" ]; then
    echo "DeepSeek: echo 'sk-xxx' > ~/.deepseek_balance_key"
  else
    echo "DeepSeek: echo 'sk-xxx' > ~/.deepseek_balance_key 配置余额"
  fi
  exit 0
fi

API_KEY=$(head -1 "$KEY_FILE" | tr -d '[:space:]')
if [ -z "$API_KEY" ]; then
  echo "DeepSeek: key empty"
  exit 0
fi

RESP=$(curl -s -L --max-time 5 \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  "$API_URL" 2>/dev/null)

if [ -z "$RESP" ]; then
  if [ "$LANG" = "en" ]; then
    echo "DeepSeek: API unreachable"
  else
    echo "DeepSeek: API 无响应"
  fi
  exit 0
fi

IS_AVAIL=$(echo "$RESP" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('is_available',False))" 2>/dev/null)

if [ "$IS_AVAIL" != "True" ]; then
  if [ "$LANG" = "en" ]; then
    echo "DeepSeek: balance unavailable"
  else
    echo "DeepSeek: 余额不可用"
  fi
  exit 0
fi

BALANCE=$(echo "$RESP" | python3 -c "
import sys, json, os

d = json.load(sys.stdin)
lang = os.environ.get('DEEPSEEK_BALANCE_LANG', 'zh')
filter_currency = os.environ.get('DEEPSEEK_BALANCE_CURRENCY', '')

lines = []
for b in d.get('balance_infos', []):
    currency = b['currency']
    if filter_currency and currency != filter_currency:
        continue
    total = float(b['total_balance'])
    granted = float(b['granted_balance'])
    topped = float(b['topped_up_balance'])
    if lang == 'en':
        lines.append(f'{total:.2f}{currency} top-up:{topped:.2f} grant:{granted:.2f}')
    else:
        lines.append(f'{total:.2f}{currency} 充值:{topped:.2f} 赠金:{granted:.2f}')

if not lines:
    if lang == 'en':
        print('no balance data')
    else:
        print('无余额数据')
else:
    print(' | '.join(lines))
" 2>/dev/null)

if [ -n "$BALANCE" ]; then
  echo "DeepSeek: $BALANCE"
else
  if [ "$LANG" = "en" ]; then
    echo "DeepSeek: parse error"
  else
    echo "DeepSeek: 解析失败"
  fi
fi
