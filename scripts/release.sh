#!/bin/bash

# Variables
PATH_PUBLIC="${1}"
PATH_DEPLOY="${1}/.dep"
BRANCH_NAME="${2}"
SHA_CURRENT="${3}"
GITHUB_REPOSITORY="${4}"
USERNAME="${5}"
PATH_RELEASE="${6}"
FILES_IGNORE="${7}"
RSYNC_OPTIONS="--size-only --quiet --archive --compress --human-readable --progress --delete-after --info=DEL --exclude='.dep/' --exclude='.git*' --exclude='.git/' --exclude='README.md' --exclude='readme.md' --exclude='.gitignore'"

# Lo añadimos como array
FILES_IGNORE=(`echo "${FILES_IGNORE}"`)

# Duplicados
duplicateExists=$(printf '%s\n' "${FILES_IGNORE[@]}"|awk '!($0 in seen){seen[$0];next} 1')

# Comprobamos que no existan duplicados
if [ ! -z "$duplicateExists" ]; then
    duplicateExists=$(echo -en $duplicateExists)
    echo "Error: Los directorios compartidos $duplicateExists estan duplicados, compruebalo"
    exit 1
fi

# Recorremos
for link in "${FILES_IGNORE[@]}"
do
    RSYNC_OPTIONS+=" --exclude='${link}'"
done

# Nos posicionamos
cd $PATH_DEPLOY

# Limpiamos si ha quedado un release sin terminar
if [ -h release ]; then
    rm -rf "$(readlink release)"
    rm release
fi

# Creamos el directorio del nuevo release
mkdir -p $PATH_RELEASE
ln -snf $PATH_RELEASE $PATH_DEPLOY/release

# Clonamos
git clone --quiet -b $BRANCH_NAME git@github.com:$GITHUB_REPOSITORY.git $PATH_DEPLOY/.clone/. > /dev/null

# Rsync
RSYNC_COMMAND="rsync --backup --backup-dir=$PATH_RELEASE $RSYNC_OPTIONS $PATH_DEPLOY/.clone/ $PATH_PUBLIC"

# Ejecutamos
eval $RSYNC_COMMAND

# Fecha
date=$(date +%Y-%m-%d_%H:%M:%S)

# Guardamos informacion sobre el release
echo "$date,$SHA_CURRENT,$USERNAME" >> releases.log
echo $SHA_CURRENT > latest_release
