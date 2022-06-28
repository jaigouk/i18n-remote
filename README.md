# i18n-remote

based on [i18n gem](https://github.com/ruby-i18n/i18n) supports multiple backends to store and retrieve translations.

- fetching translation files via HTTP rather than just relying on local translation files
- fall back to local translation files in case of any network issues

## setting up project

```
bundle install
```

## test

```
bundle exec rake test
```

## usage

Gemfile


```ruby
gem 'i18n-remote', git: "https://github.com/jaigouk/i18n-remote.git", require: 'i18n/backend/remote'
```

Config

```ruby
I18n::Backend::Remote.configure do |config|
  config.memory_cache_size = 10
end
```
