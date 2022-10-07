#!/usr/bin/env bash

set -e

# Variables
SSH_HOST="${1}"
SSH_PORT="${2}"
SSH_USER="${3}"
SSH_KEY="${4}"
PATH_PUBLIC="${5}"
DIRS_IGNORE="${6}"
FILES_IGNORE="${7}"
BRANCH_NAME="${8}"
DEPLOY_DOMAIN="${9}"
USERNAME="${10}"
GITHUB_TOKEN="${11}"
GITHUB_REPOSITORY="${12}"
USER=$(id -u -n)
GROUP=$(id -g -n)
SSH_HOST_IP=$(dig +short ${SSH_HOST})

# Librerias
. "/scripts/base.sh"

echo "🕸️ Configuramos SSH"
ssh_config "$SSH_KEY" $USER $GROUP $SSH_HOST $SSH_PORT $SSH_HOST_IP

SHA_PREVIOUS=$(api_github_sha_commit_index $GITHUB_TOKEN $GITHUB_REPOSITORY $BRANCH_NAME 1)

echo "⚙️ Ejecutamos Setup"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "setup" $PATH_PUBLIC $USERNAME $SHA_PREVIOUS

echo "🔒 Ejecutamos Lock"
#ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "lock" $PATH_PUBLIC $USERNAME

echo "⏬ Ejecutamos Download"
DOWNLOAD_FILENAME=$(api_github_download_release $GITHUB_TOKEN $GITHUB_REPOSITORY $BRANCH_NAME)

echo "🔓 Ejecutamos Unlock"
#ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "unlock" $PATH_PUBLIC