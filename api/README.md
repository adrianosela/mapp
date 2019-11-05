## Mapp API

The back end is written in Node (JavaScript) using the [Express](https://expressjs.com/) web framework.

### [Run](#running)

-   [On Your Machine](#run-on-your-machine)
-   [In Docker Container](#run-in-docker)

### [Deploy](#deploying)

-   [Acquire Deployment Credentials](#acquire-deployment-credentials)
-   [Deploy to Google App Engine](#deploy-to-google-app-engine)

### [Secrets Mgmt](#secrets-management)

-   [Using SOPS](#using-SOPS)

## Running

### Run on Your Machine

```
node index.js
```

### Run In Docker

#### build docker image

```
docker build -t mapp
```

or using the makefile target:

```
make build
```

#### run docker image

```
docker run -d --name mapp_service -p 8080:80 mapp
```

or using the makefile target:

```
make up
```

## Deploying

### Acquire Deployment Credentials

-   You are required to have privileged google application credentials in the environment to deploy
-   To become 'privileged' you must be added to the project as App Engine admin (or a more permissive role), and be authenticated with the `gcloud` CLI

<b>OR</b>

-   Create a new privileged service account for the project and download a key, then `export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json`

### Deploy To Google App Engine

```
gcloud app deploy
```

or using the makefile target:

```
make deploy
```

## Secrets Management

### Using SOPS

We use [SOPS](https://github.com/mozilla/sops) for encrypting and decrypting secrets with a shared key stored in Google Cloud KMS. Follow the download instructions for SOPS in the link.

To be able to encrypt and decrypt secrets, you are required to have google application credentials in the environment with privilege to fetch the shared KMS key. This can be achieved by having your `gcloud` user being granted the following roles:

`Cloud KMS CryptoKey Decrypter`
`Cloud KMS CryptoKey Encrypter`

<b>OR</b>

-   Create a new privileged service account for the project (with the two roles above) and download a key, then `export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json`
