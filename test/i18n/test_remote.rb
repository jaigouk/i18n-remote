# frozen_string_literal: true

require "test_helper"

class TestRemote < I18n::TestCase
  def setup
    super

    I18n.backend = I18n::Backend::Remote.new
  end

  def test_that_it_has_a_version_number
    refute_nil ::I18n::Backend::Remote::VERSION
  end
end
