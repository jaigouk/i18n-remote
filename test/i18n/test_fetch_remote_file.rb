# frozen_string_literal: true

require "test_helper"

class I18nBackendRemoteFecthRemoteFilieTest < I18n::TestCase
  def setup
    super
    I18n::Backend::Remote.configure do |config|
      config.memory_cache_size = 5
      config.file_list = ["en.yml"]
      config.base_url = "http://localhost:8080"
    end
  end

  def test_fetch_remote_file
    VCR.use_cassette("remote_en") do
      I18n::Backend::Remote::FetchRemoteFile.new.call
    end
  end
end
