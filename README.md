<p align="center">
  <a href="https://www.denox.es/">
    <img src="https://flex.oscdenox.com/logo_oscdenox_addons.png" width="142px" height="190px"/>
  </a>
</p>

<h1 align="center">
  🚀 Deployment tool
</h1>


<p align="center">
  Herramienta de <strong>despliegue</strong> escrita en bash y usando <strong>rsync</strong> encapsulada en Docker para funcionar en cualquier lugar.
  <br />
</p>

## 🚀 Configuración

### 🐳 Herramientas necesarias

1. Instalar Docker
2. Clonar el proyecto: `git clone https://github.com/jose-sampedro/github-actions-deployer-rsync.git`
3. Moverse al directorio: `cd github-actions-deployer-rsync`


## 👩‍💻 Explicación del proyecto

Realizado mediante conexión SSH usando claves, además de rsync como transporte de los cambios de la rama al despliegue. Usaremos la opción --backcup de rsync para crear un árbol de directorios y ficheros que van a ser remplazados en el destino, almacenándolos así en el servidor la cantidad de copias de seguridad que deseemos en el directorio .dep que se creara automáticamente.

## 🧑‍🎓 Requisitos

Se necesita tener clave privada para la conexión SSH. Una vez configurada en el servidor y host podrás lanzar el despliegue desde cualquier lugar.

## 🔥 Como ejecutar

### 🔑 Obtener llave

`KEY_PASS="$(cat ~/.ssh/id_rsa)"`

### 🐳 Docker

`docker build --no-cache --progress=plain -t github-actions-deployer-rsync . && docker run --rm github-actions-deployer-rsync:latest \
SSH_HOST \
SSH_PORT \
SSH_USER \"
SSH_KEY \"
PATH_PUBLIC \"
FILES_IGNORE \"
BRANCH_NAME \"
DEPLOY_DOMAIN \"
USERNAME \"
GITHUB_TOKEN \"
GITHUB_REPOSITORY \"
KEEP_RELEASES \"
COMPOSER \"
COMPOSER_RUN_SCRIPTS \`

### 🐳 Ejemplo

`docker build --no-cache --progress=plain -t github-actions-deployer-rsync . && docker run --rm github-actions-deployer-rsync:latest \
web.com \
22 \
user \
"$KEY_PASS" \
/home/web/www/sampedro/github-prueba \
"images/ temp/ feeds/ cache/ sitemap.xml includes/configure.php" \
master \
github.web.com \
jose-sampedro \
token \
jose-sampedro/prueba-github \
5 \
true \
installs `

### 👩‍💻 Parametros

* SSH_HOST:
    * description: 'Host SSH'
    * required: true
* SSH_PORT:
    * description: 'Port SSH'
    * required: false
    * default: '22'
* SSH_USER:
    * description: 'User SSH'
    * required: true
* SSH_KEY:
    * description: 'Key SSH'
    * required: true
* PATH_PUBLIC:
    * description: 'Path deployment'
    * required: true
* FILES_IGNORE:
    * description: 'List of directories and files to be ignored between releases'
    * required: false
    * default: ''
* BRANCH_NAME:
    * description: 'Branch name deployment'
    * required: true
* DEPLOY_DOMAIN:
    * description: 'Deploy domain'
    * required: false
    * default: ''
* USERNAME:
    * description: 'User performing the deployment'
    * required: true
* GITHUB_TOKEN:
    * description: 'Token Github'
    * required: true
* GITHUB_REPOSITORY:
    * description: 'Repository Github'
    * required: true
* KEEP_RELEASES:
    * description: 'Number of releases stored'
    * required: false
    * default: 5
* COMPOSER:
    * description: 'Perform composer'
    * type: boolean
    * required: false
    * default: false
* COMPOSER_RUN_SCRIPTS:
    * description: 'List of composer run script commands'
    * required: false
    * default: ''