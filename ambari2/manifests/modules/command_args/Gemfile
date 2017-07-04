source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :test do
  gem 'rake', '~> 10.1.0',       :require => false
  gem 'rspec', '~> 3.1.0',       :require => false
  gem 'rspec-puppet', '~> 2.2',  :require => false
  gem 'mocha',                   :require => false
  # keep for its rake task for now
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'puppet-lint',             :require => false
  gem 'metadata-json-lint',      :require => false
  gem 'pry',                     :require => false
  gem 'simplecov',               :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
