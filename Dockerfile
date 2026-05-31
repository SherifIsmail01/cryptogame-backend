FROM ruby:2.7-alpine

# Install system dependencies including git (required by some old gems)
RUN apk add --no-cache \
    build-base \
    nodejs \
    mariadb-client \
    mariadb-dev \
    postgresql-client \
    postgresql-dev \
    tzdata \
    git \
    libxml2-dev \
    libxslt-dev


WORKDIR /myapp

# Copy gem files
COPY Gemfile Gemfile.lock ./

# Install Bundler 2
RUN gem install bundler -v 2.4.22

# WIPE OUT local files and force an isolated runtime vendor configuration
RUN rm -rf .bundle vendor/bundle Gemfile.lock && \
    bundle config set --local deployment 'false' && \
    bundle config set --local without '' && \
    bundle config set --local path 'vendor/bundle' && \
    bundle install

# Copy the rest of the project files
COPY . .

# WIPE OUT any old local bundle caches
RUN rm -rf .bundle vendor/bundle tmp/cache

EXPOSE 3000

# Start the Rails server bound to all network interfaces
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
