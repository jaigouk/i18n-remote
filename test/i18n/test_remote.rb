# frozen_string_literal: true

require "test_helper"

class TestRemote < I18n::TestCase
  def setup
    super

    I18n::Backend::Remote.configure do |config|
      config.file_list = ["en.yml", "de.yml", "en-phrase.yml"]
      config.base_url = "http://localhost:8080"
      config.faraday_process_count = 0
    end

    I18n.backend = I18n::Backend::Remote.new
    FileUtils.mkdir_p "tmp"
  end

  def teardown
    super
    File.delete("tmp/en.yml") if File.exist?("tmp/en.yml")
  end

  def test_that_it_has_a_version_number
    refute_nil ::I18n::Backend::Remote::VERSION
  end
end
