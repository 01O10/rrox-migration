#!/usr/bin/env bash
set -e

# Load environment variables
if [ -f /root/.env ]; then
    set -a
    . /root/.env
    set +a
fi

if [ -z "$GH_TOKEN" ]; then
    echo "GH_TOKEN is not set. Cannot authenticate."
    exit 1
fi

# Authenticate non-interactively
echo "$GH_TOKEN" | gh auth login --with-token
