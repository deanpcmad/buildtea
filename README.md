# Buildtea

Buildtea is a tool for connecting Gitea with Buildkite.

## Installation

## Setup

### Buildkite Webhooks

When creating a Buildkite webhook, set the URL as `<your-url>/webhooks/buildkite` and choose the following events:

- ping
- build.scheduled
- build.running
- build.finished
