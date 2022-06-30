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

  def teardown
    I18n::Backend::Remote.configure do |config|
      config.file_list = []
      config.root_dir = nil
      config.base_url = nil
    end

    File.delete("tmp/en.yml") if File.exist?("tmp/en.yml")
    File.delete("tmp/de.yml") if File.exist?("tmp/de.yml")

    I18n.enforce_available_locales = false
    I18n.available_locales = []
    I18n.locale = :en
    I18n.default_locale = :en
    I18n.load_path = []
    I18n.backend = nil

    super
  end

  def test_that_it_has_a_version_number
    refute_nil ::I18n::Backend::Remote::VERSION
  end

  def test_remote
    VCR.use_cassette("integration_multi") do
      I18n.backend = I18n::Backend::Remote.new
      res = I18n.t("activerecord.attributes.user.remember_me")

      assert_equal "Remember me", res
    end
  end

  def test_configuration_error
    I18n::Backend::Remote.configure do |config|
      config.file_list = ["en.yml", "de.yml"]
      config.base_url = ""
      config.faraday_process_count = 0
      config.root_dir = "tmp"
    end

    I18n.backend = I18n::Backend::Remote.new
    assert_equal I18n.backend.errors.include?("Missing configurations"), true
    assert_equal I18n.backend.errors.include?("I18n::Backend::Remote::MissingBaseUrl"), true
    assert_equal I18n::Backend::Remote.config.valid?, false
  end
end
