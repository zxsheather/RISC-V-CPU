#!/bin/bash
set -euo pipefail

if [ $# -lt 1 ]; then
	echo "用法: ./verify.sh <workload-name> [simulation.log-path]" >&2
	echo "例如: ./verify.sh 0to100 ../.workspace/simulation.log" >&2
	exit 2
fi

NAME="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_PATH="${2:-${SCRIPT_DIR}/../.workspace/simulation.log}"
ANS_PATH="${SCRIPT_DIR}/${NAME}/${NAME}.ans"

if [ ! -f "$LOG_PATH" ]; then
	echo "找不到日志: $LOG_PATH" >&2
	exit 2
fi

if [ ! -f "$ANS_PATH" ]; then
	echo "找不到期望值: $ANS_PATH" >&2
	exit 2
fi

LAST_LINE="$(tail -n 1 "$LOG_PATH" | tr -d '\r')"
if [ -z "$LAST_LINE" ]; then
	echo "日志最后一行为空" >&2
	exit 2
fi

# 优先解析形如 "... [RS] 0" 的末尾数字
GOT="$(echo "$LAST_LINE" | sed -nE 's/.*\[RS\][[:space:]]*(-?[0-9]+)[[:space:]]*$/\1/p')"
if [ -z "$GOT" ]; then
	# 兜底：取最后一个整数
	GOT="$(echo "$LAST_LINE" | sed -nE 's/.*[^0-9-](-?[0-9]+)[[:space:]]*$/\1/p')"
fi

if [ -z "$GOT" ]; then
	echo "无法从日志最后一行解析数值: $LAST_LINE" >&2
	exit 2
fi

EXP="$(cat "$ANS_PATH" | tr -d '\r' | tr -d ' \t\n')"
if [ -z "$EXP" ]; then
	echo "ans 文件为空: $ANS_PATH" >&2
	exit 2
fi

if [ "$GOT" = "$EXP" ]; then
	echo "PASS $NAME: got=$GOT expected=$EXP"
	exit 0
else
	echo "FAIL $NAME: got=$GOT expected=$EXP" >&2
	exit 1
fi

