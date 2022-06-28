# frozen_string_literal: true

module I18n
  module Backend
    class Remote
      class FetchRemote
        def initialize(options)
          @options = options
        end

        def call; end
      end
    end
  end
end
