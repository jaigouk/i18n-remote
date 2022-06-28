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
bundle exec rspec
```

## usage

Gemfile

```
i18n_remote, git:
```
