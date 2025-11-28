# #!/bin/bash

# # Load environment variables from /root/.env, skipping comments and empty lines
# if [ -f /root/.env ]; then
#   # Using awk to filter out lines that are empty or start with #
#   export $(grep -v '^#' /root/.env | xargs)
# fi

# # Set git config using environment variables
# git config --global user.name "$GIT_USER_NAME"
# git config --global user.email "$GIT_USER_EMAIL"

# echo "Git configuration set for user: $GIT_USER_NAME"
#!/usr/bin/env bash
set -e

if [ -z "$GIT_USER_NAME" ] || [ -z "$GIT_USER_EMAIL" ]; then
    echo "GIT_USER_NAME or GIT_USER_EMAIL not set. Skipping Git config."
    exit 0
fi

echo "Configuring Git..."
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
echo "Git configured: $GIT_USER_NAME <$GIT_USER_EMAIL>"
