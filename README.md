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

| Opción                 | Requerido | Default         | Descripción                                                                                                  |
|------------------------|-----------|-----------------|--------------------------------------------------------------------------------------------------------------|
| `SSH_HOST`             | true      |                 | Host SSH                                                                                                     |
| `SSH_PORT`             | false      |  22               | Port SSH                                                                                                     |
| `SSH_USER`             | true      |                 | User SSH                                                                                                     |
| `SSH_KEY`             | true      |                 | Key SSH                                                                                                     |
| `PATH_PUBLIC`             | true      |                 | Path deployment                                                                                                     |
| `FILES_IGNORE`             | true      |                 | List of directories and files to be ignored between releases                                                                                                     |
| `BRANCH_NAME`             | true      |                 | Branch name deployment                                                                                                     |
| `DEPLOY_DOMAIN`             | false      |                 | Deploy domain                                                                                                     |
| `USERNAME`             | true      |                 | User performing the deployment                                                                                                     |
| `GITHUB_TOKEN`             | true      |                 | Token Github                                                                                                     |
| `GITHUB_REPOSITORY`             | true      |                 | Repository Github                                                                                                     |
| `KEEP_RELEASES`             | false      |  5               | Number of releases stored                                                                                                     |
| `COMPOSER`             | true      |                 | Branch name deployment                                                                                                     |
| `COMPOSER_RUN_SCRIPTS`             | false      |                 | List of composer run script commands                                                                                                     |

### 🤔 Ejemplo
```yml
name: 🚀 production-deployment

on:
  workflow_dispatch:
  push:
    branches: 
      - 'master'

jobs:
  production-deployment:
    environment: production
    runs-on: ubuntu-latest    
    steps:
      - name: 🗳️ Checkout
        uses: actions/checkout@v3

      - name: 🧾 Variables de entorno
        uses: jose-sampedro/github-actions-deployer/set-envs-vars@v0.0.1
        with:
          varFilePath: ./.github/vars/shared.env ./.github/vars/deploy-production.env

      - name: 🚀 Deployment
        uses: jose-sampedro/github-actions-deployer-rsync@v0.0.1
        with:
          SSH_HOST: ${{ env.SSH_HOST }}
          SSH_PORT: ${{ env.SSH_PORT }}
          SSH_USER: ${{ env.SSH_USER }}
          SSH_KEY:  ${{ secrets.SSH_KEY }}
          PATH_PUBLIC: ${{ env.PATH_PUBLIC }}
          FILES_IGNORE: ${{ env.FILES_IGNORE }}
          BRANCH_NAME: ${{ env.BRANCH_NAME }}
          DEPLOY_DOMAIN: ${{ env.DEPLOY_DOMAIN }}
          USERNAME: ${{ github.actor }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GITHUB_REPOSITORY: ${{ github.event.repository.full_name }}
          KEEP_RELEASES: ${{ env.KEEP_RELEASES }}
          COMPOSER: ${{ env.COMPOSER }}
          COMPOSER_RUN_SCRIPTS: ${{ env.COMPOSER_RUN_SCRIPTS }}
```