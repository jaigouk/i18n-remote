# frozen_string_literal: true

require "minitest/autorun"
require "bundler/setup"
require "byebug"
require "i18n"
require "i18n/backend/transliterator"
require "i18n/backend/flatten"
require "i18n/backend/simple"
require "mocha/setup"
require "test_declarative"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "i18n/remote"

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
      # byebug
      # I18n.load_path = []
      # I18n.backend = nil
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
