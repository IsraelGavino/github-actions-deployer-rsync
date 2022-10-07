#!/usr/bin/env bash

ssh_config() {
	local SSH_KEY="${1}"
	local USER="${2}"
	local GROUP="${3}"
	local SSH_HOST="${4}"
	local SSH_PORT="${5}"
	local SSH_HOST_IP="${6}"

	# Creamos directorios esenciales para SSH
	mkdir -p ~/.ssh
	touch ~/.ssh/id_rsa
	touch ~/.ssh/known_hosts
	touch ~/.ssh/config

	# Contenido de id_rsa
	echo "${SSH_KEY}" >> ~/.ssh/id_rsa

	# Permisos esenciales para SSH
	chmod 700 ~/.ssh/
	chmod 600 ~/.ssh/*
	chmod u+w ~/.ssh/known_hosts
	chown -R ${USER}:${GROUP} ~/.ssh/

	# Añadimos a servidores conocidos
	ssh-keyscan -p ${SSH_PORT} -t rsa,dsa ${SSH_HOST_IP} >> ~/.ssh/known_hosts
}

ssh_execute_remote() {
	local SSH_HOST="${1}"
	local SSH_PORT="${2}"
	local SSH_USER="${3}"
	local SSH_HOST_IP="${4}"
	local FILE_SCRIPT="${5}"

	ssh -o GlobalKnownHostsFile=~/.ssh/known_hosts -p$SSH_PORT -i ~/.ssh/id_rsa $SSH_USER@$SSH_HOST_IP "bash -s" -- < /scripts/$FILE_SCRIPT.sh "${@:6}"
}

ssh_execute_command_remote() {
	local SSH_HOST="${1}"
	local SSH_PORT="${2}"
	local SSH_USER="${3}"
	local SSH_HOST_IP="${4}"
	local COMMAND="${5}"

	ssh -o GlobalKnownHostsFile=~/.ssh/known_hosts -p$SSH_PORT -i ~/.ssh/id_rsa $SSH_USER@$SSH_HOST_IP "${COMMAND}"
}

scp_upload_file() {
	local SSH_HOST="${1}"
	local SSH_PORT="${2}"
	local SSH_USER="${3}"
	local SSH_HOST_IP="${4}"
	local FILE_UPLOAD="${5}"
	local PATH_REMOTE="${6}"

	scp -o GlobalKnownHostsFile=~/.ssh/known_hosts -P$SSH_PORT -i ~/.ssh/id_rsa $FILE_UPLOAD $SSH_USER@$SSH_HOST_IP:$PATH_REMOTE
}

function api_github_raw() {
	local GITHUB_TOKEN="${1}"

	curl -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3.raw" -s https://api.github.com/${@:2}
}

function api_github_object() {
	local GITHUB_TOKEN="${1}"

	curl -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" -s https://api.github.com/${@:2}
}

function api_github_last_sha_commit() {
	local GITHUB_TOKEN="${1}"
	local GITHUB_REPOSITORY="${2}"
	local BRANCH_NAME="${3}"

	COMMIT=`api_github_sha_commit_index $GITHUB_TOKEN $GITHUB_REPOSITORY $BRANCH_NAME 0`

	echo $COMMIT
}

function api_github_sha_commit_index() {
	local GITHUB_TOKEN="${1}"
	local GITHUB_REPOSITORY="${2}"
	local BRANCH_NAME="${3}"	
	local INDEX="${4}"

	COMMIT=`api_github_raw $GITHUB_TOKEN repos/$GITHUB_REPOSITORY/commits | jq -r "[.[]  | .sha][${INDEX}]"`

	echo $COMMIT
}