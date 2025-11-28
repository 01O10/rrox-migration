# #!/bin/bash

# # Check if a key name is provided
# if [ -z "$1" ]; then
#   echo "Usage: $0 <key_name>"
#   echo "Example: $0 id_ed25519"
#   exit 1
# fi

# # Key name from argument
# KEY_NAME="$1"
# SSH_DIR="/root/.ssh"
# KEY_PATH="$SSH_DIR/$KEY_NAME"

# # Ensure the key exists
# if [ ! -f "$KEY_PATH" ]; then
#   echo "Error: Key $KEY_PATH does not exist."
#   exit 1
# fi

# # Ensure correct permissions
# chmod 600 "$KEY_PATH"
# chmod 644 "$KEY_PATH.pub"

# # Start SSH agent and add the key
# eval "$(ssh-agent -s)"
# ssh-add "$KEY_PATH"

# # Create SSH config if it doesn't exist
# SSH_CONFIG="$SSH_DIR/config"
# if [ ! -f "$SSH_CONFIG" ]; then
#   cat <<EOL > "$SSH_CONFIG"
# Host github.com
#     HostName github.com
#     User git
#     IdentityFile $KEY_PATH
#     IdentitiesOnly yes
# EOL
#   chmod 600 "$SSH_CONFIG"
# fi

# # Test SSH connection to GitHub
# echo "Testing SSH connection to GitHub..."
# ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"
# if [ $? -eq 0 ]; then
#   echo "SSH setup successful. You can now use Git with SSH."
# else
#   echo "SSH setup failed. Check the output above for issues."
# fi
#!/usr/bin/env bash
set -e

if [ -z "$SSH_KEY_NAME" ] || [ ! -f "/root/.ssh/$SSH_KEY_NAME" ]; then
    echo "SSH_KEY_NAME not set or key not found. Skipping SSH setup."
    exit 0
fi

echo "Setting up SSH..."
eval "$(ssh-agent -s)" > /dev/null
ssh-add "/root/.ssh/$SSH_KEY_NAME" > /dev/null
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "SSH key '$SSH_KEY_NAME' added"
