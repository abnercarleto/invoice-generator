FROM ruby:3.0.3
RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /api
COPY Gemfile /api/Gemfile
COPY Gemfile.lock /api/Gemfile.lock
RUN bundle install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]