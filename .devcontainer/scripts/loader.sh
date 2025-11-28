#!/usr/bin/env bash
# Modern loader for non-interactive commands

CYAN='\033[38;5;87m'
DIM_WHITE='\033[2;37m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

SPINNER=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)

spinner() {
    local pid=$1
    local number=$2
    local task_name=$3
    local i=0

    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${CYAN}${SPINNER[i % ${#SPINNER[@]}]}${NC} [$number] ${DIM_WHITE}$task_name${NC}"
        sleep 0.08
        i=$((i+1))
    done
    
    # Clear the spinner line completely
    printf "\r\033[K"
}

run_task() {
    local number=$1
    local task_name=$2
    shift 2

    local tmp
    tmp=$(mktemp)

    "$@" >"$tmp" 2>&1 &
    local pid=$!

    spinner $pid "$number" "$task_name"
    wait $pid
    local status=$?

    # Print captured output if any
    if [ -s "$tmp" ]; then
        cat "$tmp"
    fi
    rm -f "$tmp"

    # Print result with green checkmark for success
    if [ $status -eq 0 ]; then
        printf "${GREEN}✔ [$number] $task_name${NC}\n"
    else
        printf "${RED}× [$number] $task_name failed${NC}\n"
        exit $status
    fi
}