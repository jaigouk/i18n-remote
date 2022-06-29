# frozen_string_literal: true

require "minitest/autorun"
require "bundler/setup"
require "byebug"
require "i18n"
require "i18n/backend/transliterator"
require "i18n/backend/flatten"
require "i18n/backend/simple"
require "mocha/minitest"
require "i18n/tests"

$LOAD_PATH.unshift "lib"
require "i18n/backend/remote"

require "vcr"
VCR.configure do |c|
  c.cassette_library_dir = "test/fixtures/vcr"
  c.hook_into :webmock
end

module I18n
  class TestCase < Minitest::Test
    def assert_nothing_raised(*_args)
      yield
    end

    def setup
      super
      I18n.load_path = nil
      I18n.enforce_available_locales = false
    end

    protected

    def translations
      I18n.backend.instance_variable_get(:@translations)
    end

    def store_translations(locale, data, options = I18n::EMPTY_HASH)
      I18n.backend.store_translations(locale, data, options)
    end

    def locales_dir
      "#{File.dirname(__FILE__)}/fixtures/locales"
    end
  end
end

TEST_CASE = defined?(Minitest::Test) ? Minitest::Test : MiniTest::Unit::TestCase

class TEST_CASE # rubocop:disable Naming/ClassAndModuleCamelCase
  alias assert_raise assert_raises
  alias assert_not_equal refute_equal

  def assert_nothing_raised(*_args)
    yield
  end
end

module I18n
  class TestCase < TEST_CASE
    def setup
      I18n.enforce_available_locales = false
      I18n.available_locales = []
      I18n.locale = :en
      I18n.default_locale = :en
      I18n.load_path = []
      super
    end

    def teardown
      I18n.enforce_available_locales = false
      I18n.available_locales = []
      I18n.locale = :en
      I18n.default_locale = :en
      I18n.load_path = []
      I18n.backend = nil
      super
    end

    def store_translations(locale, data)
      I18n.backend.store_translations(locale, data)
    end

    def locales_dir
      "#{File.dirname(__FILE__)}/fixtures/locales"
    end
  end
end

def en_body
  "---\nen:\n  activerecord:\n    attributes:\n      user:\n        confirmation_sent_at: Confirmation sent at\n        confirmation_token: Confirmation token\n        confirmed_at: Confirmed at\n        created_at: Created at\n        current_password: Current password\n        current_sign_in_at: Current sign in at\n        current_sign_in_ip: Current sign in IP\n        email: Email\n        encrypted_password: Encrypted password\n        failed_attempts: Failed attempts\n        last_sign_in_at: Last sign in at\n        last_sign_in_ip: Last sign in IP\n        locked_at: Locked at\n        password: Password\n        password_confirmation: Password confirmation\n        remember_created_at: Remember created at\n        remember_me: Remember me\n"
end

def en_body_missing_colon
  "---\nen:\n  activerecord:\n    attributes\n      user:\n        confirmation_sent_at: Confirmation sent at\n        confirmation_token: Confirmation token\n        confirmed_at: Confirmed at\n        created_at: Created at\n        current_password: Current password\n        current_sign_in_at: Current sign in at\n        current_sign_in_ip: Current sign in IP\n        email: Email\n        encrypted_password: Encrypted password\n        failed_attempts: Failed attempts\n        last_sign_in_at: Last sign in at\n        last_sign_in_ip: Last sign in IP\n        locked_at: Locked at\n        password: Password\n        password_confirmation: Password confirmation\n        remember_created_at: Remember created at\n        remember_me: Remember me\n"
end

def en_body_missing_value
  "---\nen:\n  activerecord:\n    attributes:\n      user:\n        confirmation_sent_at: \n        confirmation_token: Confirmation token\n        confirmed_at: Confirmed at\n        created_at: Created at\n        current_password: Current password\n        current_sign_in_at: Current sign in at\n        current_sign_in_ip: Current sign in IP\n        email: Email\n        encrypted_password: Encrypted password\n        failed_attempts: Failed attempts\n        last_sign_in_at: Last sign in at\n        last_sign_in_ip: Last sign in IP\n        locked_at: Locked at\n        password: Password\n        password_confirmation: Password confirmation\n        remember_created_at: Remember created at\n        remember_me: Remember me\n"
end

def en_body_missing_newline
  "---\nen:\n  activerecord:    attributes:\n      user:\n        confirmation_sent_at: Confirmation sent at\n        confirmation_token: Confirmation token\n        confirmed_at: Confirmed at\n        created_at: Created at\n        current_password: Current password\n        current_sign_in_at: Current sign in at\n        current_sign_in_ip: Current sign in IP\n        email: Email\n        encrypted_password: Encrypted password\n        failed_attempts: Failed attempts\n        last_sign_in_at: Last sign in at\n        last_sign_in_ip: Last sign in IP\n        locked_at: Locked at\n        password: Password\n        password_confirmation: Password confirmation\n        remember_created_at: Remember created at\n        remember_me: Remember me\n"
end

def de_body
  "---\nde:\n  activerecord:\n    attributes:\n      user:\n        confirmation_sent_at: Bestätigung gesendet am\n        confirmation_token: Bestätigungs-Token\n        confirmed_at: Bestätigt am\n        created_at: Erstellt am\n        current_password: Bisheriges Passwort\n        current_sign_in_at: Aktuelle Anmeldung vom\n        current_sign_in_ip: IP aktueller Anmeldung\n        email: E-Mail\n        encrypted_password: Verschlüsseltes Passwort\n        failed_attempts: Fehlversuche\n        last_sign_in_at: Letzte Anmeldung am\n        last_sign_in_ip: IP der letzten Anmeldung\n        locked_at: Gesperrt am\n        password: Passwort\n        password_confirmation: Passwortbestätigung\n        remember_created_at: Angemeldet bleiben vom\n        remember_me: Angemeldet bleiben\n"
end

def phrase_body
  "en:\r\n  views:\r\n    pagination:\r\n      first: \"First\"\r\n      last: \"Last\"\r\n      previous: \"Prev\"\r\n      next: \"Next\"\r\n      truncate: \"&hellip;\"\r\n  date:\r\n    abbr_day_names:\r\n    - Sun\r\n    - Mon\r\n    - Tue\r\n    - Wed\r\n    - Thu\r\n    - Fri\r\n    - Sat\r\n    abbr_month_names:\r\n    -\r\n    - Jan\r\n    - Feb\r\n    - Mar\r\n    - Apr\r\n    - May\r\n    - Jun\r\n    - Jul\r\n    - Aug\r\n    - Sep\r\n    - Oct\r\n    - Nov\r\n    - Dec\r\n    day_names:\r\n    - Sunday\r\n    - Monday\r\n    - Tuesday\r\n    - Wednesday\r\n    - Thursday\r\n    - Friday\r\n    - Saturday\r\n    formats:\r\n      default: ! '%Y-%m-%d'\r\n      long: ! '%B %d, %Y'\r\n      short: ! '%b %d'\r\n    month_names:\r\n    -\r\n    - January\r\n    - February\r\n    - March\r\n    - April\r\n    - May\r\n    - June\r\n    - July\r\n    - August\r\n    - September\r\n    - October\r\n    - November\r\n    - December\r\n    order:\r\n    - :year\r\n    - :month\r\n    - :day\r\n  datetime:\r\n    time_ago_in_words:\r\n      about_x_hours:\r\n        one: about 1 hour ago\r\n        other: about %{count} hours ago\r\n      about_x_months:\r\n        one: about 1 month ago\r\n        other: about %{count} months ago\r\n      about_x_years:\r\n        one: about 1 year ago\r\n        other: about %{count} years ago\r\n      almost_x_years:\r\n        one: almost 1 year ago\r\n        other: almost %{count} years ago\r\n      half_a_minute: half a minute ago\r\n      less_than_x_minutes:\r\n        one: less than a minute ago\r\n        other: less than %{count} minutes ago\r\n      less_than_x_seconds:\r\n        one: less than 1 second ago\r\n        other: less than %{count} seconds ago\r\n      over_x_years:\r\n        one: over 1 year ago\r\n        other: over %{count} years ago\r\n      x_days:\r\n        one: 1 day ago\r\n        other: ! '%{count} days ago'\r\n      x_minutes:\r\n        one: 1 minute ago\r\n        other: ! '%{count} minutes ago'\r\n      x_months:\r\n        one: 1 month ago\r\n        other: ! '%{count} months ago'\r\n      x_seconds:\r\n        one: 1 second ago\r\n        other: ! '%{count} seconds ago'\r\n    distance_in_words:\r\n      about_x_hours:\r\n        one: about 1 hour\r\n        other: about %{count} hours\r\n      about_x_months:\r\n        one: about 1 month\r\n        other: about %{count} months\r\n      about_x_years:\r\n        one: about 1 year\r\n        other: about %{count} years\r\n      almost_x_years:\r\n        one: almost 1 year\r\n        other: almost %{count} years\r\n      half_a_minute: half a minute\r\n      less_than_x_minutes:\r\n        one: less than a minute\r\n        other: less than %{count} minutes\r\n      less_than_x_seconds:\r\n        one: less than 1 second\r\n        other: less than %{count} seconds\r\n      over_x_years:\r\n        one: over 1 year\r\n        other: over %{count} years\r\n      x_days:\r\n        one: 1 day\r\n        other: ! '%{count} days'\r\n      x_minutes:\r\n        one: 1 minute\r\n        other: ! '%{count} minutes'\r\n      x_months:\r\n        one: 1 month\r\n        other: ! '%{count} months'\r\n      x_seconds:\r\n        one: 1 second\r\n        other: ! '%{count} seconds'\r\n    prompts:\r\n      day: Day\r\n      hour: Hour\r\n      minute: Minute\r\n      month: Month\r\n      second: Seconds\r\n      year: Year\r\n  errors: &errors\r\n    format: ! '%{attribute} %{message}'\r\n    messages:\r\n      accepted: must be accepted\r\n      blank: Please fill out this field\r\n      confirmation: doesn't match confirmation\r\n      empty: can't be empty\r\n      equal_to: must be equal to %{count}\r\n      even: must be even\r\n      exclusion: is reserved\r\n      greater_than: must be greater than %{count}\r\n      greater_than_or_equal_to: must be greater than or equal to %{count}\r\n      inclusion: is not included in the list\r\n      invalid: is invalid\r\n      less_than: must be less than %{count}\r\n      less_than_or_equal_to: must be less than or equal to %{count}\r\n      not_a_number: is not a number\r\n      not_an_integer: must be an integer\r\n      odd: must be odd\r\n      record_invalid: ! 'Validation failed: %{errors}'\r\n      taken: has already been taken\r\n      too_long:\r\n        one: is too long (maximum is 1 character)\r\n        other: is too long (maximum is %{count} characters)\r\n      too_short:\r\n        one: is too short (minimum is 1 character)\r\n        other: is too short (minimum is %{count} characters)\r\n      wrong_length:\r\n        one: is the wrong length (should be 1 character)\r\n        other: is the wrong length (should be %{count} characters)\r\n    template:\r\n      body: ! 'There were problems with the following fields:'\r\n      header:\r\n        one: 1 error prohibited this %{model} from being saved\r\n        other: ! '%{count} errors prohibited this %{model} from being saved'\r\n    models:\r\n      signup:\r\n        attributes:\r\n          email:\r\n            email_already_taken: Email address is already taken\r\n            blank: Please provide an email address\r\n            invalid: Please provide a valid email address\r\n          password:\r\n            blank: Please choose a password\r\n            insecure: Password isn't secure\r\n          name:\r\n            blank: Please enter your name\r\n        voucher:\r\n          invalid: The voucher code is not valid\r\n      translation:\r\n        attributes:\r\n          content:\r\n            exceeded_max_characters_allowed: 'number of allowed characters exceeded'\r\n  helpers:\r\n    select:\r\n      prompt: Please select\r\n    submit:\r\n      create: Create %{model}\r\n      submit: Save %{model}\r\n      update: Update %{model}\r\n  number:\r\n    currency:\r\n      format:\r\n        delimiter: ! ','\r\n        format: ! '%u%n'\r\n        precision: 2\r\n        separator: .\r\n        significant: false\r\n        strip_insignificant_zeros: false\r\n        unit: $\r\n    format:\r\n      delimiter: ! ','\r\n      precision: 3\r\n      separator: .\r\n      significant: false\r\n      strip_insignificant_zeros: false\r\n    human:\r\n      decimal_units:\r\n        format: ! '%n %u'\r\n        units:\r\n          billion: Billion\r\n          million: Million\r\n          quadrillion: Quadrillion\r\n          thousand: Thousand\r\n          trillion: Trillion\r\n          unit: ''\r\n      format:\r\n        delimiter: ''\r\n        precision: 3\r\n        significant: true\r\n        strip_insignificant_zeros: true\r\n      storage_units:\r\n        format: ! '%n %u'\r\n        units:\r\n          byte:\r\n            one: Byte\r\n            other: Bytes\r\n          gb: GB\r\n          kb: KB\r\n          mb: MB\r\n          tb: TB\r\n    percentage:\r\n      format:\r\n        delimiter: ''\r\n    precision:\r\n      format:\r\n        delimiter: ''\r\n  support:\r\n    array:\r\n      last_word_connector: ! ', and '\r\n      two_words_connector: ! ' and '\r\n      words_connector: ! ', '\r\n  time:\r\n    am: am\r\n    formats:\r\n      default: ! '%a, %d %b %Y %H:%M:%S %z'\r\n      long: ! '%B %d, %Y %H:%M %Z'\r\n      medium: ! '%d %b %Y, %H:%M'\r\n      short: ! '%d %b %H:%M'\r\n      precise: ! '%a, %b %-d at %l%P'\r\n    pm: pm\r\n  # remove these aliases after 'activemodel' and 'activerecord' namespaces are removed from Rails repository\r\n  activemodel:\r\n    errors:\r\n      <<: *errors\r\n  activerecord:\r\n    errors:\r\n      <<: *errors\r\n"
end
