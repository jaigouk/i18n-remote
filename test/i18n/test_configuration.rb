# frozen_string_literal: true

require "test_helper"

class TestConfiguration < I18n::TestCase
  def setup
    super

    I18n.backend = I18n::Backend::Remote.new
  end

  def test_config
    I18n::Backend::Remote.configure do |config|
      config.memory_cache_size = 5
      config.file_list = ["en.yml"]
      config.base_url = "http://example.com/files/"
    end

    assert_equal I18n::Backend::Remote.config.memory_cache_size, 5
    assert_equal I18n::Backend::Remote.config.file_list, ["en.yml"]
    assert_equal I18n::Backend::Remote.config.base_url, "http://example.com/files/"
  end
end
