# Padzilla

A nodejs app to sync, renew and verify Zoho subscriptions.

**NPM Dependencies**
  - "axios": "^0.27.2" - `For third party API calls of Zoho`
  - "dotenv": "^16.0.1" - `For using environment variables`
  - "express": "~4.16.1" - `Framework for NodeJS`
  - "express-openapi": "^11.0.0" - `For open API implementation`
  - "jsonwebtoken": "^8.5.1" - `For JWT token creation`
  - "moment": "^2.29.3" - `For Datetime manipulation`
  - "mysql": "^2.18.1" - `For mysql DB connection`
  - "passport": "^0.6.0" - `For Padzilla API endpoints authentication`
  - "swagger-ui-express": "^4.4.0" - `For swagger UI interface of open APIs`
  - "yamljs": "^0.3.0" - `For swagger.yaml file reading in JSON format for implementation`

**NPM Dev Dependencies**
  - "jest": "^28.1.0" - `For test cases writing and running using supertes`
  - "prompt-sync": "^4.2.0" - `For prompting user for inputs via terminal during test cases execution`
  - "supertest": "^6.2.3" - `For test cases creation`

---
## Environment Setup

### **Production**

For production, you will just need **`DOCKER`**, installed in your environement.

  - ### Docker
    - #### Docker installation on Windows

      Just go on [official Docker website](https://docs.docker.com/desktop/windows/install/) and download the installer.

    - #### Docker installation on Ubuntu
      **`Ubuntu 20.04`**
      Docker installtion instructions can be found [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04).

      **`Ubuntu 18.04`**
      Docker installtion instructions can be found [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04).

    - #### Other Operating Systems
      You can find more information about the installation on the [official Docker website](https://docs.docker.com/get-docker/).

    - #### Post installation
      - If the installation was successful, you should be able to run the following command.

          $ ***docker info***

            Client:
              Context:    default
              Debug Mode: false
              Plugins:
                buildx: Docker Buildx (Docker Inc., v0.8.2)
                compose: Docker Compose (Docker Inc., v2.5.1)

### **Development**

For development, you will need **`NODE.JS`**, **`NPM`** and **`MYSQL`** installed in your environement.

  - ### Node
    - #### Node installation on Windows

      Just go on [official Node.js website](https://nodejs.org/) and download the installer.
      Also, be sure to have `git` available in your PATH, `npm` might need it (You can find git [here](https://git-scm.com/)).

    - #### Node installation on Ubuntu

      You can install nodejs and npm easily with apt install, just run the following commands.

        $ ***sudo apt install nodejs***

        $ ***sudo apt install npm***

    - #### Other Operating Systems
      You can find more information about the installation on the [official Node.js website](https://nodejs.org/) and the [official NPM website](https://npmjs.org/).

    - #### Post installation
      - If the installation was successful, you should be able to run the following command.

          $ ***node --version***

            v16.15.0

          $ ***npm --version***

            v8.5.5


      - If you need to update `npm`, you can make it using `npm`! Cool right? After running the following command, just open again the command line and be happy.

          $ ***npm install npm -g***

  - ### Mysql
    - #### Mysql installation on Windows

      Just go on [official Mysql website](https://dev.mysql.com/downloads/mysql/) and download the installer.

    - #### Mysql installation on Ubuntu
      **`Ubuntu 20.04`**
      Mysql installtion instructions can be found [here](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04).
      **`Ubuntu 18.04`**
      Mysql installtion instructions can be found [here](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-18-04).

    - #### Other Operating Systems
      You can find more information about the installation on the [official Mysql website](https://dev.mysql.com/downloads/mysql/).

    - #### Post installation
      - If the installation was successful, you should be able to run the following command.

          $ ***mysqld --version***

            Ver 8.0.29

---

## Project Installation

  $ ***git clone [PROJECT_GIT_URL]***

  $ ***cd [PROJECT_FOLDER_NAME]***

  $ ***npm install***

---

## Project Configuration

- Put the **`public.pem`** file in the **`root`** folder.

  `// The `**`public.pem `**`file should have the public key for JWT encryption.`

- Edit the **`.env`** file environment variables as follows:-
    ###### **SELF_PROTOCOL**=http
    ###### **SELF_HOST**=localhost
    ###### **SELF_PORT**=3000
    ###### **SELF_PUBLIC_KEY_PATH**=/usr/src/app/public.pem `// For development - give full path`
    
    ###### **SELF_DATABASE**=padzilla_database
    ###### **SELF_DATABASE_HOST**=db `// For development - use 127.0.0.1`
    ###### **SELF_DATABASE_USER**=root
    ###### **SELF_DATABASE_PASSWORD**=CG-vak123

    ###### **SELF_ZOHO_CLIENT_ID**=1000.3IIM80SYKPGU3HCHJ9SF1VMBWTLZUV `// Provided By Client`
    ###### **SELF_ZOHO_SECRET**=0d3e06e5ff52d9e20ca04ee8e36b1cd63e70193443 `// Provided By Client`
    ###### **SELF_ZOHO_REFRESH_TOKEN**=1000.941aeb6fd3d0efb7c680b045ffbbf922.b11b2235e486e6aa4c1156688953e98e `// Provided By Client`
    ###### **SELF_ZOHO_ORGANIZATION_ID**=772821291 `// Provided By Client`
    ###### **SELF_ZOHO_REDIRECT_URI**=http://localhost:3000 `// Provided By Client`
    ###### **SELF_ZOHO_POLL_RATE_SECONDS**=14400 `// Sync Process At Every 4 Hours`

---

## Starting The Project

  $ ***docker-compose up***

## Configuring Database Tables

  $ ***cat [PATH_TO_SQL_FILE] | docker exec -i [DATABASE_CONTAINER_NAME] mysql -u[DATABASE_USER] -p[DATABASE_PASSWORD] [DATABASE_NAME]***

## Testing The Project

  $ ***npm test***
  #### `// Give full path of `**`public.pem `**`file in the `**`subscription.test.js `**`file.`

## Stopping The Project

  $ ***docker-compose down***

## Stopping The Project

  $ ***docker-compose down***

## Stopping The Project

  $ ***docker-compose down***

## Project Server

  - Local server will start at **http://localhost:3000/**

  - Open APIs can be accessed at **http://localhost:3000/api-docs/**

---