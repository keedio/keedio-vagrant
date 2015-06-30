source 'https://rubygems.org'

gem 'rake'
gem 'puppet-lint'
gem 'rspec-puppet'
gem 'puppetlabs_spec_helper', :github => 'jenkins-infra/puppetlabs_spec_helper'
gem 'puppet-syntax'
gem 'puppet', ENV['PUPPET_VERSION'] || '~> 3.5.1'

group :development do
  gem 'rcov', :platform => :mri_19
  gem 'parallel_tests'
  gem 'ci_reporter'
  gem 'debugger', :platform => :mri
  gem 'debugger-pry', :platform => :mri

  gem 'serverspec'
  gem 'vagrant', :github => 'mitchellh/vagrant',
                 :ref => 'v1.6.2',
                 :platform => :mri
end

# Vagrant plugins
group :plugins do
  gem 'vagrant-aws', :github => 'mitchellh/vagrant-aws'
  gem 'vagrant-serverspec', :github => 'jvoorhis/vagrant-serverspec'
end
