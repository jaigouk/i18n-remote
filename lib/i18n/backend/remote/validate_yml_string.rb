# frozen_string_literal: true

require "psych"

module I18n
  module Backend
    class Remote
      class ValidateYmlString
        def initialize(str)
          @str = str
        end
        attr_reader :str

        def call
          guard
          parse
        end

        private

        def guard
          return unless ::I18n::Backend::Remote::Utils.nil_or_empty?(str)

          raise ::I18n::Backend::Remote::ParseError, "Validation falied - nil value"
        end

        Response = Struct.new(:parsed, :str, :errors, keyword_init: true)

        def parse
          Response.new(parsed: Psych.parse(str).to_ruby, str: str, errors: nil)
        rescue Psych::SyntaxError => e
          Response.new(parsed: nil, str: str, errors: e.message)
        end
      end
    end
  end
end
