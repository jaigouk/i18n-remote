# i18n-remote

extending [i18n gem](https://github.com/ruby-i18n/i18n)

- fetching translation files via HTTP rather than just relying on local translation files
- fall back to local translation files in case of any network issues

## usage

Gemfile

```ruby
gem 'i18n-remote', git: "https://github.com/jaigouk/i18n-remote.git", require: 'i18n/backend/remote'
```

Config

```ruby
I18n::Backend::Remote.configure do |config|
  config.memory_cache_size = 10
  # base url for fetching yml files
  config.base_url = "http://localhost:8080/locales/"
  # file list that will be concatenated after base_url
  config.file_list = ["en.yml", "de.yml", "extra/data.yml"]
  # used for pararell http requests
  conofig.faraday_process_count = 6
end
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
