#!/bin/bash

# Variables
PATH_PUBLIC="${1}"
PATH_DEPLOY="${1}/deploy-ftp"
USERNAME="${2}"
SHA_PREVIOUS="${3}"

# Directorio deploy
if [ ! -d $PATH_DEPLOY ]; then 
	mkdir -p $PATH_DEPLOY 
fi

# Nos posicionamos en el directorio
cd $PATH_DEPLOY

# Directorio metadata
if [ ! -d .dep ]; then 
	mkdir .dep;
fi

# Si no existe informacion de releases
if [ ! -f .dep/releases ]; then 
	date=$(date +%Y-%m-%d_%H:%M:%S)
	echo "$date,$SHA_PREVIOUS,$USERNAME" >> .dep/releases
fi

# Directorio .trash
if [ ! -d .trash ]; then 
	mkdir .trash;
fi