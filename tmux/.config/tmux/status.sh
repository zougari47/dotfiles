#!/usr/bin/env bash
# Values for the tmux status bar. Usage: status.sh cpu | ram | battery | battery-icon
export LC_ALL=C.UTF-8

case "$1" in
  cpu)
    # Usage since the last call: compare /proc/stat with the totals saved last time.
    state="${XDG_RUNTIME_DIR:-/tmp}/tmux-status-cpu"
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle=$((idle + iowait))
    prev_total=0 prev_idle=0
    [ -r "$state" ] && read -r prev_total prev_idle < "$state"
    echo "$total $idle" > "$state"
    dt=$((total - prev_total)) di=$((idle - prev_idle))
    [ "$dt" -le 0 ] && { echo " 0.0%"; exit 0; }
    p=$((1000 * (dt - di) / dt))
    # Always 5 characters, so the label keeps its width: " 8.3%", "12.5%", " 100%"
    if [ "$p" -ge 1000 ]; then echo " 100%"; else printf '%2d.%d%%\n' $((p / 10)) $((p % 10)); fi
    ;;
  ram)
    awk '/^MemTotal:/ {t=$2} /^MemAvailable:/ {a=$2} END {printf "%d%%\n", (t - a) * 100 / t}' /proc/meminfo
    ;;
  net)
    # Network speed (download + upload) since the last call, on the interface holding the default route.
    state="${XDG_RUNTIME_DIR:-/tmp}/tmux-status-net"
    iface=$(ip route show default 2>/dev/null | awk '{for (i = 1; i < NF; i++) if ($i == "dev") {print $(i + 1); exit}}')
    [ -z "$iface" ] && { echo "  off"; exit 0; }
    rx=$(cat "/sys/class/net/$iface/statistics/rx_bytes")
    tx=$(cat "/sys/class/net/$iface/statistics/tx_bytes")
    now=$(date +%s%3N)
    prev_iface="" prev_rx=0 prev_tx=0 prev_now=0
    [ -r "$state" ] && read -r prev_iface prev_rx prev_tx prev_now < "$state"
    echo "$iface $rx $tx $now" > "$state"
    ms=$((now - prev_now))
    if [ "$iface" != "$prev_iface" ] || [ "$ms" -le 0 ] || [ "$rx" -lt "$prev_rx" ] || [ "$tx" -lt "$prev_tx" ]; then
      speed=0
    else
      speed=$(((rx - prev_rx + tx - prev_tx) * 1000 / ms))   # download + upload, bytes per second
    fi
    # Always 5 characters, so the label keeps its width: "  12K", " 1.2M", " 250M"
    if [ "$speed" -lt 1048576 ]; then printf '%4dK\n' $((speed / 1024))
    elif [ "$speed" -lt 104857600 ]; then printf '%2d.%dM\n' $((speed / 1048576)) $((speed % 1048576 * 10 / 1048576))
    else printf '%4dM\n' $((speed / 1048576)); fi
    ;;
  battery)
    # Always 4 characters: " 93%", "100%"
    printf '%3d%%\n' "$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)"
    ;;
  battery-icon)
    bat=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1)
    [ -z "$bat" ] && { printf '\U000F06A5'; exit 0; }          # no battery: plug
    level=$(cat "$bat/capacity")
    if [ "$(cat "$bat/status")" = "Charging" ]; then
      # battery with a bolt beside it, filled to the nearest 10%
      icons=(F089F F089C F0086 F0087 F0088 F089D F0089 F089E F008A F008B F0085)
      printf "\\U000${icons[$((level / 10))]}"
    elif [ "$level" -ge 88 ]; then printf ''              # wide battery: full
    elif [ "$level" -ge 63 ]; then printf ''              # three quarters
    elif [ "$level" -ge 38 ]; then printf ''              # half
    elif [ "$level" -ge 13 ]; then printf ''              # quarter
    else printf ''                                        # empty
    fi
    ;;
esac
