# frozen_string_literal: true

require "test_helper"

module I18n
  class TestRemote < I18n::TestCase
    def setup
      super

      I18n.backend = I18n::Backend::Remote.new
    end

    def teardown
      # I18n::Backend::Remote.instance_variable_set :@config, I18n::Backend::Remote::Configuration.new

      super
    end

    def test_that_it_has_a_version_number
      refute_nil ::I18n::Backend::Remote::VERSION
    end
  end
end
