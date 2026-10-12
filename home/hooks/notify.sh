#!/usr/bin/env bash
# Notification: desktop notification when Claude waits for you (permission prompt, idle, agent needs input).
# Uses terminalSequence, so it works in tmux and without /dev/tty.
input=$(cat)
msg=$(printf '%s' "$input" | jq -r '.message // "Claude Code needs your attention"' | tr -d '\007\033;' | cut -c1-180)
case "${TERM_PROGRAM:-}" in
  ghostty|WarpTerminal) seq=$(printf '\033]777;notify;Claude Code;%s\007' "$msg") ;;   # OSC 777
  *)                    seq=$(printf '\033]9;Claude Code: %s\007' "$msg") ;;           # OSC 9: iTerm2, WezTerm, Windows Terminal
esac
jq -nc --arg s "$seq" '{terminalSequence:$s}'
