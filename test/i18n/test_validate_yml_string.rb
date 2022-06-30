# frozen_string_literal: true

require "test_helper"

class TestValidateYmlString < I18n::TestCase
  def test_parse_yml_string
    res = I18n::Backend::Remote::ValidateYmlString.new(en_body).call
    assert_equal res.parsed["en"]["activerecord"]["attributes"]["user"].keys.sort, expected_keys

    assert_nil res.errors
    assert_equal res.str, en_body
  end

  def test_nil_input
    assert_raises ::I18n::Backend::Remote::ParseError do
      I18n::Backend::Remote::ValidateYmlString.new(nil).call
    end
  end

  def test_empty_string_input
    assert_raises ::I18n::Backend::Remote::ParseError do
      I18n::Backend::Remote::ValidateYmlString.new("").call
    end
  end

  def test_parse_en_body_missing_value
    res = I18n::Backend::Remote::ValidateYmlString.new(en_body_missing_value).call

    assert_equal res.parsed["en"]["activerecord"]["attributes"]["user"].keys.sort, expected_keys
    assert_nil res.errors
    assert_equal res.str, en_body_missing_value
  end

  def test_parse_en_body_missing_colon
    res = I18n::Backend::Remote::ValidateYmlString.new(en_body_missing_colon).call
    error = "mapping values are not allowed in this context"

    assert_nil res.parsed
    assert_equal res.errors.include?(error), true
    assert_equal res.str, en_body_missing_colon
  end

  def test_parse_en_body_missing_newline
    res = I18n::Backend::Remote::ValidateYmlString.new(en_body_missing_newline).call
    error = "mapping values are not allowed in this context"

    assert_nil res.parsed
    assert_equal res.errors.include?(error), true
    assert_equal res.str, en_body_missing_newline
  end

  def test_parse_en_body_wrong_indentation
    res = I18n::Backend::Remote::ValidateYmlString.new(en_body_wrong_indentation).call
    error = "mapping values are not allowed in this context"

    assert_nil res.parsed
    assert_equal res.errors.include?(error), true
    assert_equal res.str, en_body_wrong_indentation
  end

  def expected_keys
    ["confirmation_sent_at", "confirmation_token", "confirmed_at", "created_at", "current_password", "current_sign_in_at", "current_sign_in_ip", "email", "encrypted_password", "failed_attempts", "last_sign_in_at", "last_sign_in_ip", "locked_at", "password", "password_confirmation", "remember_created_at", "remember_me"]
  end
end
