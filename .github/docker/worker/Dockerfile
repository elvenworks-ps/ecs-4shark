FROM ruby:3.4.1

ARG BUNDLE_WITHOUT
ARG DIFFEND_PROJECT_ID
ARG DIFFEND_SHAREABLE_ID
ARG DIFFEND_SHAREABLE_KEY
ARG SIDEKIQ_CONFIG
ENV SIDEKIQ_CONFIG=$SIDEKIQ_CONFIG

WORKDIR /app

# System dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  curl \
  git \
  graphicsmagick \
  libicu-dev \
  libmagickwand-dev \
  libpq-dev \
  libxml2-dev \
  libxslt1-dev \
  && rm -rf /var/lib/apt/lists/*

# Bundler
RUN gem install bundler -v 2.7.1

# Copy Gemfile and lib before bundle install
COPY Gemfile Gemfile.lock ./
COPY . .

# Configure and install gems
RUN bundle config set --local deployment 'true' && \
  bundle config set --local path 'vendor/bundle' && \
  if [ -n "$BUNDLE_WITHOUT" ]; then \
  bundle config set --local without "$BUNDLE_WITHOUT"; \
  fi
RUN bundle install --jobs 4 --retry 3

COPY . .

ENV PATH="/app/vendor/bundle/ruby/3.4.1/bin:$PATH"
ENV BUNDLE_PATH=/app/vendor/bundle
ENV GEM_HOME=/app/vendor/bundle
ENV GEM_PATH=/app/vendor/bundle

HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD test -f /app/tmp/sidekiq_ready.txt || exit 1

# CMD expects SIDEKIQ_CONFIG from environment (ECS task definition)
CMD ["sh", "-c", "bundle exec sidekiq -C config/${SIDEKIQ_CONFIG}"]
