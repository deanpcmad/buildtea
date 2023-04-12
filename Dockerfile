FROM ruby:3.1.2-alpine AS base

RUN apk update && \
  apk add --no-cache build-base curl git nodejs bash \
  # for mysql2
  mysql-dev \
  # for sassc-ruby
  libc6-compat \
  # for tzdata
  tzdata \
  yarn

# Setup an application
RUN adduser -S -h /opt/app -s /bin/sh app
USER app
WORKDIR /opt/app

# Configure 'app' command to work everywhere (when the binary exists
# later in this process)
ENV PATH="/opt/app/bin:${PATH}"

RUN gem update --system

# Install the latest and active gem dependencies and re-run
# the appropriate commands to handle installs.
COPY Gemfile Gemfile.lock ./
RUN bundle install -j $(nproc)

# Copy the application (and set permissions)
# COPY ./docker/wait-for.sh /docker-entrypoint.sh
COPY --chown=app . .

# Set the CMD
ENTRYPOINT ["/opt/app/bin/docker-entrypoint"]
# CMD ["rails", "s"]
CMD ["app"]

# ci target - use --target=ci to skip asset compilation
FROM base AS ci

# prod target - default if no --target option is given
FROM base AS prod

RUN RAILS_GROUPS=assets bundle exec rake assets:precompile
RUN touch /opt/app/public/assets/.prebuilt
