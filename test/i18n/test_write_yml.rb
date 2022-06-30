# frozen_string_literal: true

require "fileutils"
require "test_helper"

class TestWriteYml < I18n::TestCase
  def setup
    super
    FileUtils.mkdir_p "tmp"
  end

  def teardown
    super
    File.delete("tmp/en.yml") if File.exist?("tmp/en.yml")
  end

  def test_write_yml
    I18n::Backend::Remote::WriteYml.new(en_body, "en.yml", "tmp").call
    parsed = Psych.parse_stream(File.read("tmp/en.yml")).to_yaml

    assert_equal parsed, en_body
  end

  def test_nil_input
    assert_raises ::I18n::Backend::Remote::WriteError do
      I18n::Backend::Remote::WriteYml.new(nil, "en.yml", "tmp").call
    end
  end

  def test_empty_string_input
    assert_raises ::I18n::Backend::Remote::WriteError do
      I18n::Backend::Remote::WriteYml.new("", "en.yml", "tmp").call
    end
  end

  def test_nil_filename
    assert_raises ::I18n::Backend::Remote::WriteError do
      I18n::Backend::Remote::WriteYml.new(en_body, nil, "tmp").call
    end
  end

  def test_empty_filename
    assert_raises ::I18n::Backend::Remote::WriteError do
      I18n::Backend::Remote::WriteYml.new(en_body, nil, "tmp").call
    end
  end

  def test_nil_dir
    assert_raises ::I18n::Backend::Remote::WriteError do
      I18n::Backend::Remote::WriteYml.new(en_body, "en.yml", nil).call
    end
  end

  def test_empty_dir
    assert_raises ::I18n::Backend::Remote::WriteError do
      I18n::Backend::Remote::WriteYml.new(en_body, "en.yml", "").call
    end
  end

  def test_not_existing_dir
    assert_raises ::I18n::Backend::Remote::WriteError do
      I18n::Backend::Remote::WriteYml.new(en_body, "en.yml", "not_existing_dir").call
    end
  end
end
