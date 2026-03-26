FROM ruby:3.2-alpine

RUN apk add --no-cache \
  build-base \
  mysql-dev \
  tzdata \
  nodejs \
  yaml-dev

WORKDIR /app

COPY Gemfile Gemfile.lock* ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
