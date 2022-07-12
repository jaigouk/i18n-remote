# i18n-remote
[![Ruby](https://github.com/jaigouk/i18n-remote/actions/workflows/main.yml/badge.svg)](https://github.com/jaigouk/i18n-remote/actions/workflows/main.yml)

extending [i18n gem](https://github.com/ruby-i18n/i18n)

- fetch multiple remote i18n yaml files(assuming no local files as a initial status)
- fall back to local translation files in case of any network issues

## usage

Gemfile

```ruby
gem 'i18n-remote', git: "https://github.com/jaigouk/i18n-remote.git", require: 'i18n/backend/remote'
```

Config

```ruby
I18n::Backend::Remote.configure do |config|
  # base url for fetching yml files
  config.base_url = "http://localhost:8080/locales/"
  # file list that will be concatenated after base_url
  config.file_list = ["en.yml", "de.yml", "extra/data.yml"]
  # used for pararell http requests
  config.faraday_process_count = 6
  # dir location to save fetched files
  config.root_dir = "config/locales"
end

# check configuartion is valid
I18n::Backend::Remote.config.valid?
# then initialize Remote
I18n.backend = I18n::Backend::Remote.new
```

## test

```
bundle exec rake test
```

## setting up project for development

```
brew install http-server
bundle install

cd test/fixtures
npx http-server
```

visit http://localhost:8080/invalid/missing_colon.yml

## status

- [ ] simplify error handling
- [ ] ssl connection config
- [ ] storing files in s3 or minio instead of local directory
- [ ] ruby3 support when we fetch remote files via faraday
