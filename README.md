# Buildtea

Buildtea is a tool for connecting Gitea with Buildkite.

![](https://files.deanpcmad.com/2023/B0hNS/photoshop_g1BM9yMbWg.png)

## Installation

Docker is used to distribute this tool.

An example Docker Compose file is here:

```yaml
version: "3"
services:
  buildtea:
    image: ghcr.io/deanpcmad/buildtea:latest
    container_name: buildtea
    command: app web-server
    restart: unless-stopped
    depends_on:
      - buildtea-db
    ports:
      - 5000:5000
    volumes:
      # Either set this to a Docker volume
      # or as a directory but chmod it to 1000:1000
      - buildtea:/rails/storage
    environment:
      # Generate a 128 character key and enter it here
      SECRET_KEY_BASE:
      # The full hostname of this app. Used when creating Gitea webhooks
      APP_HOST:
      # Used for HTTP Basic Auth
      USERNAME:
      PASSWORD:
      # The full hostname of your Gitea server, including https
      # e.g. https://git.mycompany.com
      GITEA_SERVER:
      # An Access Token for your Gitea account with the following scopes:
      # repo - read & write
      # user - read
      GITEA_TOKEN:
      # An API Access Token with the following scopes:
      # read_builds write_builds read_pipelines write_pipelines
      BUILDKITE_TOKEN:
      # The slug of your Buildkite organization. e.g. buildkite.com/orgslug
      BUILDKITE_ORG:
```

Then start the containers:

```sh
docker compose up -d
```

Then after your containers have started, initialize the database:

```sh
docker compose exec buildtea app initialize
```

## Setup

Buildtea works by taking Gitea webhook requests and creating builds from them. Then Buildkite webhooks are used
for marking a build's status and also the Gitea commit status.

When creating a new Repo, it will grab a list of all your Gitea repos and Buildkite pipelines.

First, choose a repo, then if you already have a Buildkite pipeline created, choose the pipeline. If not, then
enter the name and description fields out as they will be used when creating a pipeline.

You'll then be redirected to the repo page where you'll see the unique Gitea webhook URl for this repo. If you
click the "Setup Webhook" link, it will create the webhook on your Gitea server for you.

### Buildkite Webhooks

When creating a Buildkite webhook, set the URL as `<your-url>/webhooks/buildkite` and choose the following events:

- ping
- build.scheduled
- build.running
- build.finished
