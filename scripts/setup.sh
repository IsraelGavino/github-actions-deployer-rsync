#!/bin/bash

# Variables
PATH_PUBLIC="${1}"
SHA_CURRENT=${2}

# Directorio metadata
if [ ! -d $PATH_PUBLIC/.dep ]; then 
	mkdir $PATH_PUBLIC/.dep;
fi

# Directorio .clone
if [ ! -d $PATH_PUBLIC/.dep/.clone ]; then 
	mkdir $PATH_PUBLIC/.dep/.clone;
fi

# Directorio releases
if [ ! -d $PATH_PUBLIC/.dep/releases ]; then 
	mkdir $PATH_PUBLIC/.dep/releases;
fi

# Si no existe informacion de releases
if [ ! -f $PATH_PUBLIC/.dep/latest_release ]; then 
	echo $SHA_CURRENT > $PATH_PUBLIC/.dep/latest_release
fi

# Si no existe htaccess
if [ ! -f $PATH_PUBLIC/.dep/.htaccess ]; then 
	echo "Deny from all" > $PATH_PUBLIC/.dep/.htaccess
fi