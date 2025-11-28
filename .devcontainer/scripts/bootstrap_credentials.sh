#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE_PATH:-/root/.env}"
if [[ ! -r "$ENV_FILE" ]]; then
  echo "Missing readable env file at $ENV_FILE" >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

git config --global user.name "${GIT_USER_NAME:?GIT_USER_NAME missing}"
git config --global user.email "${GIT_USER_EMAIL:?GIT_USER_EMAIL missing}"

SSH_KEY_PATH="${SSH_KEY_PATH:-/root/.ssh/id_ed25519_win}"
if [[ ! -r "$SSH_KEY_PATH" ]]; then
  echo "Missing readable SSH key at $SSH_KEY_PATH" >&2
  exit 1
fi

eval "$(ssh-agent -s)" >/dev/null
ssh-add "$SSH_KEY_PATH"

gh auth login --with-token <<< "${GH_TOKEN}"
