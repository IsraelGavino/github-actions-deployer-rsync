#!/usr/bin/env bash

set -e

# Variables
SSH_HOST=$(echo "${1}" | tr -d '\r')
SSH_PORT=$(echo "${2}" | tr -d '\r')
SSH_USER=$(echo "${3}" | tr -d '\r')
SSH_KEY=$(echo "${4}" | tr -d '\r')
PATH_PUBLIC=$(echo "${5}" | tr -d '\r')
FILES_IGNORE=$(echo "${6}" | tr -d '\r')
BRANCH_NAME=$(echo "${7}" | tr -d '\r')
DEPLOY_DOMAIN=$(echo "${8}" | tr -d '\r')
USERNAME=$(echo "${9}" | tr -d '\r')
GITHUB_TOKEN=$(echo "${10}" | tr -d '\r')
GITHUB_REPOSITORY=$(echo "${11}" | tr -d '\r')
KEEP_RELEASES=$(echo "${12}" | tr -d '\r')
COMPOSER=$(echo "${13}" | tr -d '\r')
COMPOSER_RUN_SCRIPTS=$(echo "${14}" | tr -d '\r')
USER=$(id -u -n)
GROUP=$(id -g -n)
SSH_HOST_IP=$(dig +short ${SSH_HOST})

# Librerias
. "/scripts/base.sh"

echo "🕸️ Configuramos SSH"
ssh_config "$SSH_KEY" $USER $GROUP $SSH_HOST $SSH_PORT $SSH_HOST_IP

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