#!/usr/bin/env bash
set -euo pipefail

ENV_FILE=/root/.env
SSH_DIR=/root/.ssh

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Expected env file at $ENV_FILE but it was not found."
    exit 1
fi

# Load environment variables (comments and blank lines are skipped automatically)
set -a
# shellcheck disable=SC1090
. "$ENV_FILE"
set +a

if [[ -z "${GIT_USER_NAME:-}" ]] || [[ -z "${GIT_USER_EMAIL:-}" ]]; then
    echo "GIT_USER_NAME or GIT_USER_EMAIL missing in $ENV_FILE."
    exit 1
fi

echo "Configuring Git identity..."
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

# Allow CLI argument, explicit path env, or fall back to a named key
if [[ $# -gt 0 ]]; then
    if [[ "$1" == */* ]]; then
        SSH_KEY_PATH="$1"
    else
        SSH_KEY_PATH="$SSH_DIR/$1"
    fi
elif [[ -n "${SSH_KEY_PATH:-}" ]]; then
    if [[ "$SSH_KEY_PATH" != /* ]]; then
        SSH_KEY_PATH="$SSH_DIR/$SSH_KEY_PATH"
    fi
else
    KEY_NAME="${SSH_KEY_NAME:-id_ed25519}"
    if [[ "$KEY_NAME" == */* ]]; then
        SSH_KEY_PATH="$KEY_NAME"
    else
        SSH_KEY_PATH="$SSH_DIR/$KEY_NAME"
    fi
fi

if [[ ! -f "$SSH_KEY_PATH" ]]; then
    echo "SSH key not found at $SSH_KEY_PATH."
    exit 1
fi

SSH_KEY_PUBLIC="${SSH_KEY_PATH}.pub"
if [[ -f "$SSH_KEY_PUBLIC" ]]; then
    if ! chmod 644 "$SSH_KEY_PUBLIC" 2>/dev/null; then
        echo "Warning: failed to chmod $SSH_KEY_PUBLIC (read-only file system?)."
    fi
fi

if ! chmod 600 "$SSH_KEY_PATH" 2>/dev/null; then
    echo "Warning: failed to chmod $SSH_KEY_PATH (read-only file system?)."
fi

if [[ ! -d "$SSH_DIR" ]]; then
    if ! mkdir -p "$SSH_DIR" 2>/dev/null; then
        echo "Warning: unable to create $SSH_DIR (read-only file system?)."
    fi
fi

if ! chmod 700 "$SSH_DIR" 2>/dev/null; then
    echo "Warning: failed to chmod $SSH_DIR (read-only file system?)."
fi

# Ensure an SSH agent is ready before we add the key
if [[ -z "${SSH_AUTH_SOCK:-}" ]] || ! ssh-add -l >/dev/null 2>&1; then
    eval "$(ssh-agent -s)" >/dev/null
fi

if ssh-add -l | grep -q "$SSH_KEY_PATH" 2>/dev/null; then
    echo "SSH key already added to the agent."
else
    if ssh-add "$SSH_KEY_PATH" >/dev/null; then
        echo "SSH key added to the agent."
    else
        echo "Warning: ssh-add failed for $SSH_KEY_PATH."
    fi
fi

SSH_CONFIG="$SSH_DIR/config"

can_update_config=false
if [[ -d "$SSH_DIR" ]]; then
    if [[ -e "$SSH_CONFIG" ]]; then
        if [[ -w "$SSH_CONFIG" ]]; then
            can_update_config=true
        fi
    elif [[ -w "$SSH_DIR" ]]; then
        can_update_config=true
    fi
fi

if [[ ! -f "$SSH_CONFIG" ]] || ! grep -q "Host github.com" "$SSH_CONFIG"; then
    if [[ "$can_update_config" == true ]]; then
        if ! cat >>"$SSH_CONFIG" <<EOF
Host github.com
    HostName github.com
    User git
    IdentityFile $SSH_KEY_PATH
    IdentitiesOnly yes
EOF
        then
            echo "Warning: failed to update $SSH_CONFIG (read-only file system?)."
        fi
    else
        echo "Warning: cannot update $SSH_CONFIG; directory not writable."
    fi
fi
if [[ -e "$SSH_CONFIG" ]]; then
    if ! chmod 600 "$SSH_CONFIG" 2>/dev/null; then
        echo "Warning: failed to chmod $SSH_CONFIG (read-only file system?)."
    fi
fi

echo "Git identity configured for $GIT_USER_NAME <$GIT_USER_EMAIL>."
echo "SSH ready for github.com using $SSH_KEY_PATH."
