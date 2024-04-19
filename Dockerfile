FROM ruby:3.3-slim as builder

ENV RAILS_ENV=production

# Need to install build-essential so that we can build native extension gems (don't love)
RUN apt -y update && apt -y install build-essential libpq-dev && apt -y clean

WORKDIR /app

COPY Gemfile Gemfile.lock .

RUN gem install bundler -v '2.4.19'
RUN bundle install


# run the app inside a slim container without build tools installed
FROM ruby:3.3-slim as app

# need libpq shared objects
RUN apt -y update && apt -y install libpq5 && apt -y clean

WORKDIR /app

RUN gem install bundler -v '2.4.19'
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . .

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
