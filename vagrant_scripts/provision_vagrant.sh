#!/usr/bin/env bash

if [ -d "/usr/local/rvm/rubies"  ]; then
  echo "vagrant_provision: rvm and ruby already installed"
else
  echo "vagrant_provision: installing rvm"
  sudo -i -u vagrant -H sh -c "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"

  sudo -i -u vagrant -H sh -c "\curl -sSL https://get.rvm.io | bash -s stable --ruby"

  sudo -i -u vagrant -H sh -c "gem install bundler"
fi

if [ -e "/usr/share/postgresql-common/pg_wrapper" ];then
  echo "vagrant_provision: postgres already installed"
else
  echo "vagrant_provision: installing postgres"
  sudo apt-get update --qq
  sudo apt-get install -y postgresql-9.4
  sudo apt-get install -y postgresql-server-dev-9.4
fi