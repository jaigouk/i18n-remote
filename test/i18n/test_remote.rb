# frozen_string_literal: true

require "test_helper"


class TestRemote < I18n::TestCase
  def setup
    super
    I18n::Backend::Remote.configure do |config|
      config.file_list = ["en.yml", "de.yml"]
      config.base_url = "http://localhost:8080"
      config.faraday_process_count = 0
      config.root_dir = "test/fixtures/write_test"
    end
  end

  def teardown
    I18n::Backend::Remote.configure do |config|
      config.file_list = []
      config.root_dir = nil
      config.base_url = nil
    end

    File.delete("test/fixtures/write_test/en.yml") if File.exist?("test/fixtures/write_test/en.yml")
    File.delete("test/fixtures/write_test/de.yml") if File.exist?("test/fixtures/write_test/de.yml")

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

  def test_store_translations
    VCR.use_cassette("integration_store_translations") do
      I18n.backend = I18n::Backend::Remote.new
      I18n.backend.store_translations(:en, { you: "there" })

      assert_equal "there", I18n.t("you")
    end
  end

  def test_yaml_file_write
    VCR.use_cassette("integration_yml_file_write") do
      I18n.backend = I18n::Backend::Remote.new
      assert_equal File.exist?("test/fixtures/write_test/de.yml"), true
      assert_equal File.exist?("test/fixtures/write_test/en.yml"), true
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
