FROM ruby:3.4.1

ARG BUNDLE_WITHOUT
ARG DIFFEND_PROJECT_ID
ARG DIFFEND_SHAREABLE_ID
ARG DIFFEND_SHAREABLE_KEY
ARG RAILS_ENV=production
ARG SECRET_KEY_BASE_DUMMY=1

ENV RAILS_ENV=$RAILS_ENV
ENV SECRET_KEY_BASE_DUMMY=$SECRET_KEY_BASE_DUMMY

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

# Copy application code
COPY . .

# Compile Rails assets
RUN bundle exec rails assets:precompile

ENV PATH="/app/vendor/bundle/ruby/3.4.1/bin:$PATH"
ENV BUNDLE_PATH=/app/vendor/bundle
ENV GEM_HOME=/app/vendor/bundle
ENV GEM_PATH=/app/vendor/bundle

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -f http://localhost:3000/health || exit 1

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
