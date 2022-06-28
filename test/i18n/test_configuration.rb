# frozen_string_literal: true

require "test_helper"

class I18nBackendRemoteTest < I18n::TestCase
  def setup
    super

    I18n.backend = I18n::Backend::Remote.new
  end

  def test_config
    I18n::Backend::Remote.configure { |config| config.memory_cache_size = 5 }

    assert_equal I18n::Backend::Remote.config.memory_cache_size, 5
  end
end
