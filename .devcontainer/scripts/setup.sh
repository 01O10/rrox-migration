#!/usr/bin/env bash
set -e

# --- Determine script directory ---
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$DIR/loader.sh" ]; then
    source "$DIR/loader.sh"
    USE_MODERN_LOADER=true
else
    USE_MODERN_LOADER=false
fi

# --- Safe load .env ---
if [ -f /root/.env ]; then
    set -a
    . /root/.env
    set +a
else
    echo "⚠ /root/.env not found. Exiting."
    exit 1
fi

# --- Wrapper to conditionally run tasks ---
run_with_loader() {
    local number=$1
    local task_name=$2
    shift 2
    
    if [ "$USE_MODERN_LOADER" = true ]; then
        # Use the run_task function from loader.sh
        if ! run_task "$number" "$task_name" "$@"; then
            exit 1
        fi
    else
        # Just run normally without spinner
        echo "[$number] $task_name"
        if ! "$@"; then
            exit 1
        fi
    fi
}

# --- Sequential tasks ---
run_with_loader 1 "Config Git" bash /root/scripts/set-git-config.sh
run_with_loader 2 "SSH Setup" bash /root/scripts/set-ssh-config.sh  

# Special handling for GH CLI which may return exit code 1 for informational messages
echo "Authenticating gh CLI..."
if bash /root/scripts/set-gh-config.sh 2>&1 | tee /tmp/gh_output; then
    gh_exit_code=0
else
    gh_exit_code=$?
fi

# Check if the output indicates success despite non-zero exit code
if [ $gh_exit_code -eq 1 ] && grep -q "GH_TOKEN environment variable" /tmp/gh_output; then
    echo -e "${GREEN}✔ [3] Authenticate GH CLI${NC}"
    gh_exit_code=0
elif [ $gh_exit_code -eq 0 ]; then
    echo -e "${GREEN}✔ [3] Authenticate GH CLI${NC}"
else
    echo -e "${RED}× [3] Authenticate GH CLI failed with exit code: $gh_exit_code${NC}"
    cat /tmp/gh_output
    exit $gh_exit_code
fi

rm -f /tmp/gh_output

if [ "$USE_MODERN_LOADER" = true ]; then
    GREEN='\033[1;32m'
    NC='\033[0m'
    echo -e "${GREEN}🎉 DevContainer setup complete!${NC}"
else
    echo "🎉 DevContainer setup complete!"
fi