#!/usr/bin/env bash
# Claude Code status line (Nerd Font icons), two groups split by a divider:
#   model  high ⚡fast │ ctx 18.6k │ cache │ main [!?⇡1] │ #12 approved │ +42 -10 │ total 30.6k │ $ 2.45
#   ───────────────────────────────────────────────
#   Session ▓▓░░░░░░░░ 20.0%  03:15 (4hr 30m) │ Weekly ▓▓▓▓▓▓▓▓░░ 82.0%  Oct 29, 8am (1d 12hr) ▲ over pace
# Segments wrap to the terminal width; optional ones (effort, fast, cache, git, PR, limits) only show
# when Claude Code sends them. The limits group is Pro/Max only.
# One jq call for the JSON, one git call for branch + status; Total is read from the transcript,
# only the new bytes each run.

# context tokens where the ctx segment turns yellow / red
CTX_WARN=200000
CTX_STOP=300000

IFS=$'\x1f' read -r model ctx dir added removed cost sid transcript s_pct s_reset w_pct w_reset \
  effort fast cache pr_num pr_state < <(jq -r '[
  .model.display_name // "Claude",
  .context_window.total_input_tokens // 0,
  .workspace.current_dir // .cwd // "",
  .cost.total_lines_added // 0,
  .cost.total_lines_removed // 0,
  .cost.total_cost_usd // 0,
  .session_id // "",
  .transcript_path // "",
  .rate_limits.five_hour.used_percentage // "",
  .rate_limits.five_hour.resets_at // "",
  .rate_limits.seven_day.used_percentage // "",
  .rate_limits.seven_day.resets_at // "",
  .effort.level // "",
  .fast_mode // false,
  (.prompt_cache.warm | if . == null then "" else . end),
  .pr.number // "",
  .pr.review_state // ""
] | map(tostring) | join("\u001f")')

# 950 -> 950, 18600 -> 18.6k, 1200000 -> 1.2M
fmt_tokens() {
  awk -v t="$1" 'BEGIN {
    if (t >= 1000000) printf "%.1fM", t / 1000000
    else if (t >= 1000) printf "%.1fk", t / 1000
    else printf "%d", t
  }'
}

# 0-100 -> ▓▓░░░░░░░░
bar() {
  local filled empty out="" i
  filled=$(awk -v p="$1" 'BEGIN { f = int(p / 10 + 0.5); if (f > 10) f = 10; if (f < 0) f = 0; print f }')
  empty=$((10 - filled))
  for ((i = 0; i < filled; i++)); do out+="▓"; done
  for ((i = 0; i < empty; i++)); do out+="░"; done
  printf '%s' "$out"
}

# epoch -> "1d 12hr 30m" until then
until_reset() {
  local s=$(($1 - $(date +%s))) d h m out=""
  ((s <= 0)) && { printf 'now'; return; }
  d=$((s / 86400)) h=$((s % 86400 / 3600)) m=$((s % 3600 / 60))
  ((d > 0)) && out+="${d}d "
  ((d > 0 || h > 0)) && out+="${h}hr "
  printf '%s' "${out}${m}m"
}

# epoch -> "Oct 29, 8am" (or "Oct 29, 8:30am"), like the /usage screen
reset_date() {
  if [ "$(date -d "@$1" +%M)" = "00" ]; then
    date -d "@$1" '+%b %-d, %-I%P'
  else
    date -d "@$1" '+%b %-d, %-I:%M%P'
  fi
}

# Session total: input + cache writes + output of every response (cache reads left out, they
# re-count the same context each turn). Cached per session as "offset total last_msg_id" so each
# run only parses what was appended; a response split over several lines shares one id.
total=0
if [ -n "$sid" ] && [ -f "$transcript" ]; then
  cache_file="${XDG_RUNTIME_DIR:-/tmp}/claude-statusline-$sid"
  offset=0 last=""
  [ -f "$cache_file" ] && read -r offset total last <"$cache_file"
  size=$(stat -c %s "$transcript")
  ((size < offset)) && offset=0 total=0 last=""
  if ((size > offset)); then
    read -r new partial last < <(tail -c +$((offset + 1)) "$transcript" | head -c $((size - offset)) |
      jq -Rsr --arg last "$last" '
        split("\n") as $l
        | reduce ($l[:-1][] | try fromjson catch empty | select(.type == "assistant") | .message | select(.usage)) as $m
            ({t: 0, last: $last};
             if $m.id == .last then .
             else .t += ($m.usage | (.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.output_tokens // 0))
                | .last = $m.id end)
        | "\(.t) \($l[-1] | utf8bytelength) \(.last)"')
    total=$((total + ${new:-0}))
    offset=$((size - ${partial:-0}))
    printf '%s %s %s\n' "$offset" "$total" "$last" >"$cache_file"
  fi
fi

# Git branch + status in starship's notation: = conflicted, ✘ deleted, » renamed, ! modified,
# + staged, ? untracked, ⇡n ahead, ⇣n behind, ⇕ diverged (stash left out: it needs a second git call)
branch="" git_flags=""
if [ -n "$dir" ]; then
  IFS=$'\t' read -r branch git_flags < <(git --no-optional-locks -C "$dir" status --porcelain=v2 --branch 2>/dev/null | awk '
    /^# branch.head / { head = $3 }
    /^# branch.ab /   { ahead = substr($3, 2) + 0; behind = substr($4, 2) + 0 }
    /^u /             { conflicted = 1 }
    /^[12] / {
      x = substr($2, 1, 1); y = substr($2, 2, 1)
      if ($1 == "2") renamed = 1
      if (x == "D" || y == "D") deleted = 1
      if (x != "." && x != "D" && $1 != "2") staged = 1
      if (y == "M" || y == "T") modified = 1
    }
    /^\? /            { untracked = 1 }
    END {
      if (head == "") exit
      if (head == "(detached)") head = "detached"
      f = (conflicted ? "=" : "") (deleted ? "✘" : "") (renamed ? "»" : "") (modified ? "!" : "") \
          (staged ? "+" : "") (untracked ? "?" : "")
      if (ahead && behind) f = f "⇕"
      else if (ahead) f = f "⇡" ahead
      else if (behind) f = f "⇣" behind
      printf "%s\t%s\n", head, f
    }')
fi

reset=$'\e[0m' dim=$'\e[90m' cyan=$'\e[36m' green=$'\e[32m' yellow=$'\e[33m' red=$'\e[31m'
blue=$'\e[38;5;110m' orange=$'\e[38;5;208m' magenta=$'\e[35m'

# Nerd Font icons
i_model=$'\U000f06a9' i_effort=$'' i_fast=$'' i_ctx=$'' i_warm=$''
i_cold=$'' i_branch=$'' i_pr=$'' i_diff=$'' i_total=$'' i_cost=$''
i_session=$'' i_weekly=$'' i_clock=$''

# Print segments ("color<TAB>text") joined by " │ ", wrapping onto a new row before a segment
# would pass the terminal width. Claude Code sets COLUMNS; keep a small margin for its padding.
export LC_ALL=C.UTF-8
max=$((${COLUMNS:-200} - 4))
row() {
  local out="" width=0 seg color text
  for seg in "$@"; do
    color=${seg%%$'\t'*} text=${seg#*$'\t'}
    if ((width > 0 && width + 3 + ${#text} > max)); then
      printf '%s\n' "$out"
      out="" width=0
    fi
    ((width > 0)) && out+="${dim} │ ${reset}" width=$((width + 3))
    out+="${color}${text}${reset}" width=$((width + ${#text}))
  done
  printf '%s\n' "$out"
}

# model, plus effort and fast mode when set
m="$i_model $model"
[ -n "$effort" ] && m+="  $i_effort $effort"
[ "$fast" = "true" ] && m+="  $i_fast fast"
segs=("$cyan"$'\t'"$m")

# context size: yellow = wrap up the task, red = time to /clear
ctx_color=$dim
((ctx >= CTX_WARN)) && ctx_color=$yellow
((ctx >= CTX_STOP)) && ctx_color=$red
segs+=("$ctx_color"$'\t'"$i_ctx $(fmt_tokens "$ctx")")

# warm cache: the next message is cheap; cold: it re-sends the whole conversation
[ "$cache" = "true" ] && segs+=("$orange"$'\t'"$i_warm warm")
[ "$cache" = "false" ] && segs+=("$blue"$'\t'"$i_cold cold")

if [ -n "$branch" ]; then
  b="$i_branch $branch"
  [ -n "$git_flags" ] && b+=" [$git_flags]"
  segs+=("$magenta"$'\t'"$b")
fi

if [ -n "$pr_num" ]; then
  case $pr_state in
    approved) pr_color=$green ;;
    changes_requested) pr_color=$red pr_state="changes requested" ;;
    pending) pr_color=$yellow ;;
    *) pr_color=$dim ;;
  esac
  segs+=("$pr_color"$'\t'"$i_pr #$pr_num${pr_state:+ $pr_state}")
fi

segs+=("$yellow"$'\t'"$i_diff +$added -$removed")
segs+=("$cyan"$'\t'"$i_total $(fmt_tokens "$total")")
segs+=("$green"$'\t'"$i_cost $(printf '%.2f' "$cost")")
row "${segs[@]}"

# each limit keeps its usage and reset together, so a wrap never separates them
limits=()
if [ -n "$s_pct" ]; then
  s="$i_session Session $(bar "$s_pct") $(printf '%.1f' "$s_pct")%"
  [ -n "$s_reset" ] && s+="  $i_clock $(date -d "@$s_reset" +%H:%M) ($(until_reset "$s_reset"))"
  limits+=("$blue"$'\t'"$s")
fi
if [ -n "$w_pct" ]; then
  w="$i_weekly Weekly $(bar "$w_pct") $(printf '%.1f' "$w_pct")%"
  w_color=$blue
  if [ -n "$w_reset" ]; then
    w+="  $i_clock $(reset_date "$w_reset") ($(until_reset "$w_reset"))"
    # pace: share of the week used vs share of the week gone; red once 5 points ahead
    elapsed=$(((604800 - (w_reset - $(date +%s))) * 100 / 604800))
    if awk -v u="$w_pct" -v e="$elapsed" 'BEGIN { exit !(u > e + 5) }'; then
      w+=" ▲ over pace"
      w_color=$red
    fi
  fi
  limits+=("$w_color"$'\t'"$w")
fi
if ((${#limits[@]})); then
  rule=""
  for ((i = 0; i < max; i++)); do rule+="─"; done
  printf '%s\n' "${dim}${rule}${reset}"
  row "${limits[@]}"
fi
