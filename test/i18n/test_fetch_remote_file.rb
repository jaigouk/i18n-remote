# frozen_string_literal: true

require "test_helper"

class TestFetchRemoteFile < I18n::TestCase
  def test_fetch_multiple_files
    I18n::Backend::Remote.configure do |config|
      config.file_list = ["en.yml", "de.yml", "en-phrase.yml"]
      config.base_url = "http://localhost:8080"
      config.faraday_process_count = 0
      config.root_dir = "tmp"
    end

    res = nil

    VCR.use_cassette("remote_multi") do
      res = I18n::Backend::Remote::FetchRemoteFile.new.call
    end
    assert_equal res.keys.sort, ["de.yml", "en-phrase.yml", "en.yml"]
    assert_equal res["en.yml"].status, 200
    assert_equal res["de.yml"].status, 200
    assert_equal res["en-phrase.yml"].status, 200
    assert_equal res["en.yml"].body, en_body
    assert_equal res["de.yml"].body, de_body
    assert_equal res["en-phrase.yml"].body, phrase_body
  end

  def test_preconditions_missing_base_url
    I18n::Backend::Remote.configure do |config|
      config.file_list = ["en.yml"]
      config.base_url = ""
      config.root_dir = "tmp"
    end
    VCR.use_cassette("missing_base_url") do
      assert_raises ::I18n::Backend::Remote::MissingBaseUrl do
        I18n::Backend::Remote::FetchRemoteFile.new.call
      end
    end
  end

  def test_preconditions_empty_file_list
    I18n::Backend::Remote.configure do |config|
      config.file_list = []
      config.base_url = "http://localhost:8080"
      config.root_dir = "tmp"
    end

    assert_raises ::I18n::Backend::Remote::MissingFileList do
      I18n::Backend::Remote::FetchRemoteFile.new.call
    end
  end
end
