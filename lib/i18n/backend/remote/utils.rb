# frozen_string_literal: true

require "psych"

module I18n
  module Backend
    class Remote
      class Utils
        def self.nil_or_empty?(data)
          data.nil? || data.empty?
        end
      end
    end
  end
end
