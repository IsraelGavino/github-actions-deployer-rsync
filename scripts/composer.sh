#!/bin/bash

# Variables
PATH_PUBLIC="${1}"
COMPOSER_RUN_SCRIPTS="${2}"

# Nos posicionamos
cd $PATH_PUBLIC

# Lanzamos composer
composer update --no-dev

# Lo añadimos como array
COMPOSER_RUN_SCRIPTS=(`echo "${COMPOSER_RUN_SCRIPTS}"`)

# Recorremos
for script in "${COMPOSER_RUN_SCRIPTS[@]}"
do
    composer run-script $script
done
