# frozen_string_literal: true

require "test_helper"

class TestConfiguration < I18n::TestCase
  def test_config
    I18n::Backend::Remote.configure do |config|
      config.file_list = ["en.yml"]
      config.root_dir = "tmp"
      config.base_url = "http://example.com/files/"
    end

    assert_equal I18n::Backend::Remote.config.file_list, ["en.yml"]
    assert_equal I18n::Backend::Remote.config.base_url, "http://example.com/files/"
    assert_equal I18n::Backend::Remote.config.load_list, ["tmp/en.yml"]
  end
end
