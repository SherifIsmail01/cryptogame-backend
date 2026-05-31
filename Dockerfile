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

# Force absolute default paths for Ruby gems inside the container
ENV GEM_HOME="/usr/local/bundle"
ENV BUNDLE_PATH="/usr/local/bundle"
ENV PATH="$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH"


WORKDIR /myapp

# Copy gem files
COPY Gemfile Gemfile.lock ./

# Install Bundler 2
RUN gem install bundler -v 2.4.22

# FORCE bundler to install ALL groups (including development/test) to get Rake
RUN rm -f Gemfile.lock && \
    bundle config set --local without '' && \
    bundle config set --local development 'true' && \
    bundle config set --local test 'true' && \
    bundle install

# FORCE bundler to accept the Linux environment platforms, then run install
RUN bundle lock --add-platform x86_64-linux && \
    bundle lock --add-platform aarch64-linux && \
    bundle install

# Copy the rest of the project files
COPY . .

# WIPE OUT any old local bundle caches
RUN rm -rf .bundle vendor/bundle tmp/cache

EXPOSE 3000

# Start the Rails server bound to all network interfaces
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
