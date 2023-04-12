# Buildtea

Buildtea is a tool for connecting Gitea with Buildkite.

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
    environment:
      WAIT_FOR_TIMEOUT: 90
      WAIT_FOR_TARGETS: |-
        buildtea-db:3306
      DATABASE_URL: mysql2://buildteauser:buildteapass@buildtea-db/buildtea?pool=10
      # The full hostname of this app. Used when creating Gitea webhooks
      APP_HOST:
      # Used for HTTP Basic Auth
      USERNAME:
      PASSWORD:
      # The full hostname of your Gitea server, including https
      # e.g. https://git.mycompany.com
      GITEA_SERVER:
      # An Access Token for your Gitea account with the following scopes:
      # repo
      GITEA_TOKEN:
      # An API Access Token with the following scopes:
      # read_builds write_builds read_pipelines write_pipelines
      BUILDKITE_TOKEN:
      # The slug of your Buildkite account. e.g. buildkite.com/accountslug
      BUILDKITE_SLUG:

  buildtea-db:
    image: mysql:8
    container_name: buildtea-db
    command: mysqld --default-authentication-plugin=mysql_native_password --skip-mysqlx
    restart: unless-stopped
    volumes:
      - ./buildtea-db:/var/lib/mysql
    environment:
      MYSQL_DATABASE: buildtea
      MYSQL_ROOT_PASSWORD: root
      MYSQL_USER: buildteauser
      MYSQL_PASSWORD: buildteapass
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

First, choose a repo

### Gitea Webhooks

After creating a repository, you'll see the unique Gitea webhook URL for that repo.

### Buildkite Webhooks

When creating a Buildkite webhook, set the URL as `<your-url>/webhooks/buildkite` and choose the following events:

- ping
- build.scheduled
- build.running
- build.finished
