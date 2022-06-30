# frozen_string_literal: true

module I18n
  module Backend
    class Remote
      class ConfigurationError < StandardError; end
      class ParseError < StandardError; end
      class WriteError < StandardError; end
      class MissingBaseUrl < StandardError; end
      class MissingFileList < StandardError; end
    end
  end
end
