#!/bin/bash
input=$(cat)

# Colors
RESET='\033[0m'
BOLD='\033[1m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
MAGENTA='\033[35m'

# Format compact numbers
format_compact() {
    local value="$1"

    if [ "$value" -ge 1000000 ]; then
        # 1250000 -> 1.2m
        awk -v n="$value" 'BEGIN { printf "%.1fm", n/1000000 }' | sed 's/\.0m$/m/'
    elif [ "$value" -ge 1000 ]; then
        # 200000 -> 200k
        awk -v n="$value" 'BEGIN { printf "%.1fk", n/1000 }' | sed 's/\.0k$/k/'
    else
        echo "$value"
    fi
}

# Return color by usage percentage (context window)
get_color_by_pct() {
    local pct="$1"
    if [ "$pct" -le 40 ]; then
        echo "$GREEN"
    elif [ "$pct" -le 60 ]; then
        echo "$YELLOW"
    else
        echo "$RED"
    fi
}

# Return color by rate limit usage percentage
get_rate_color_by_pct() {
    local pct="$1"
    if [ "$pct" -le 69 ]; then
        echo "$GREEN"
    elif [ "$pct" -le 89 ]; then
        echo "$YELLOW"
    else
        echo "$RED"
    fi
}

# Build a fixed-width progress bar
build_bar() {
    local pct="$1"
    local width="$2"
    local filled=$((pct * width / 100))
    local empty=$((width - filled))
    local bar=""
    local fill=""
    local pad=""

    [ "$filled" -gt 0 ] && printf -v fill "%${filled}s" && bar="${fill// /█}"
    [ "$empty" -gt 0 ] && printf -v pad "%${empty}s" && bar="${bar}${pad// /░}"
    echo "$bar"
}

# Model
MODEL=$(echo "$input" | jq -r '.model.display_name // .model.id // "N/A"' | sed 's/Claude 3.5 //i')

# Context Window Used Percentage
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Progress Bar
BAR_WIDTH=10
BAR=$(build_bar "$PCT" "$BAR_WIDTH")
BAR_COLOR=$(get_color_by_pct "$PCT")

# Context Window size
CONTEXT_WINDOW_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
CONTEXT_WINDOW_SIZE_FMT=$(format_compact "$CONTEXT_WINDOW_SIZE")

# Git Status
BRANCH=$(git branch --show-current 2>/dev/null)
GIT_INFO=""
if [ -n "$BRANCH" ]; then
    # -uall garante que ele conte cada arquivo dentro de pastas novas
    STATUS=$(git status --porcelain -uall 2>/dev/null)
    STAGED=$(echo "$STATUS" | grep -c '^[MADRCU]')
    MODIFIED=$(echo "$STATUS" | grep -c '^.[MADRCU]')
    UNTRACKED=$(echo "$STATUS" | grep -c '??')
    
    GIT_INFO="${CYAN}($BRANCH)${RESET} ${GREEN}+$STAGED${RESET} ${YELLOW}~$MODIFIED${RESET} ${RED}?$UNTRACKED${RESET}"
fi

# Rate Limits
FIVE_HOUR_USED=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0')
SEVEN_DAY_USED=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0')

# Format percentage
format_pct() {
    local value="$1"
    awk -v n="$value" 'BEGIN { printf "%.1f%%", n }'
}
FIVE_HOUR_USED_FMT=$(format_pct "$FIVE_HOUR_USED")
SEVEN_DAY_USED_FMT=$(format_pct "$SEVEN_DAY_USED")

RATE_BAR_WIDTH=10
FIVE_HOUR_PCT=$(printf "%.0f" "$FIVE_HOUR_USED")
SEVEN_DAY_PCT=$(printf "%.0f" "$SEVEN_DAY_USED")
FIVE_HOUR_BAR=$(build_bar "$FIVE_HOUR_PCT" "$RATE_BAR_WIDTH")
SEVEN_DAY_BAR=$(build_bar "$SEVEN_DAY_PCT" "$RATE_BAR_WIDTH")
FIVE_HOUR_COLOR=$(get_rate_color_by_pct "$FIVE_HOUR_PCT")
SEVEN_DAY_COLOR=$(get_rate_color_by_pct "$SEVEN_DAY_PCT")

# Lines

LINE_ONE="🤖 ${MAGENTA}$MODEL${RESET} ${CYAN}($CONTEXT_WINDOW_SIZE_FMT)${RESET} | 🧠 ${BOLD}${BAR_COLOR}$BAR${RESET} $PCT% | ⏱ 5h ${BOLD}${FIVE_HOUR_COLOR}${FIVE_HOUR_BAR}${RESET} ${FIVE_HOUR_USED_FMT} | 📆 7d ${BOLD}${SEVEN_DAY_COLOR}${SEVEN_DAY_BAR}${RESET} ${SEVEN_DAY_USED_FMT}"

LINE_TWO="📂 ${BOLD}$(basename "$PWD")${RESET} $GIT_INFO"

# Status Line
echo -e "${LINE_ONE} \n ${LINE_TWO}"