#!/usr/bin/env bash
# exit on error - this makes the script stop if any command fails
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
# IMPORTANT: This line runs database migrations
bundle exec rails db:migrate