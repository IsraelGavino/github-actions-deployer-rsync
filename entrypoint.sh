#!/usr/bin/env bash

set -e

# Variables
SSH_HOST="${1}"
SSH_PORT="${2}"
SSH_USER="${3}"
SSH_KEY="${4}"
PATH_PUBLIC="${5}"
FILES_IGNORE="${6}"
BRANCH_NAME="${7}"
DEPLOY_DOMAIN="${8}"
USERNAME="${9}"
GITHUB_TOKEN="${10}"
GITHUB_REPOSITORY="${11}"
KEEP_RELEASES="${12}"
COMPOSER="${13}"
COMPOSER_RUN_SCRIPTS="${14}"
USER=$(id -u -n)
GROUP=$(id -g -n)
SSH_HOST_IP=$(dig +short ${SSH_HOST})


echo "$SSH_HOST" "$SSH_PORT" "$SSH_HOST_IP"
exit 1

# Librerias
. "/scripts/base.sh"

echo "🕸️ Configuramos SSH"
ssh_config "$SSH_KEY" $USER $GROUP $SSH_HOST $SSH_PORT $SSH_HOST_IP
exit 1

SHA_CURRENT=$(api_github_sha_commit_index $GITHUB_TOKEN $GITHUB_REPOSITORY $BRANCH_NAME 0)
SHA_PREVIOUS=$(api_github_sha_commit_index $GITHUB_TOKEN $GITHUB_REPOSITORY $BRANCH_NAME 1)
PATH_RELEASE=$PATH_PUBLIC/.dep/releases/$SHA_CURRENT

echo "⚙️ Ejecutamos Setup"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "setup" $PATH_PUBLIC $SHA_PREVIOUS

echo "🔒 Ejecutamos Lock"
#ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "lock" $PATH_PUBLIC $USERNAME

echo "📁 Ejecutamos Release"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "release" $PATH_PUBLIC $BRANCH_NAME $SHA_CURRENT $GITHUB_REPOSITORY $USERNAME $PATH_RELEASE "'"$FILES_IGNORE"'"

# Composer
if [ "$COMPOSER" = "true" ]; then 
	echo "🎻 Ejecutamos Composer"
	ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "composer" $PATH_PUBLIC "'"$COMPOSER_RUN_SCRIPTS"'"
fi

echo "🧽 Ejecutamos Cleanup"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "cleanup" $PATH_PUBLIC $KEEP_RELEASES

echo "🔓 Ejecutamos Unlock"
#ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "unlock" $PATH_PUBLIC