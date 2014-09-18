#!/bin/bash
#
# Installs Foreman from git using rubygems
#

VERSION=$1

WITHOUT="mysql mysql2 pg test"

# checkout foreman
git clone https://github.com/theforeman/foreman.git -b $VERSION --depth 1

# compile deps and migrate db
pushd foreman

cp config/settings.yaml.example config/settings.yaml
cp config/database.yml.example config/database.yml

gem install bundler

bundle install --without $WITHOUT --path vendor

FACTER_domain=lan FACTER_fqdn=$(hostname).lan RAILS_ENV=production bundle exec rake db:migrate assets:precompile locale:pack

popd
