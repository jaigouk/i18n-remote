# frozen_string_literal: true

require "test_helper"


class TestRemote < I18n::TestCase
  def setup
    super
    I18n::Backend::Remote.configure do |config|
      config.file_list = ["en.yml", "de.yml"]
      config.base_url = "http://localhost:8080"
      config.faraday_process_count = 0
      config.root_dir = "tmp"
    end
  end


  def test_that_it_has_a_version_number
    refute_nil ::I18n::Backend::Remote::VERSION
  end

  # def test_remote
  #   VCR.use_cassette("integration_multi") do

  #   end
  # end
end
