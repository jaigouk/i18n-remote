# frozen_string_literal: true

module I18n
  module Backend
    class Remote
      class I18n::Backend::Remote::Configuration
        attr_accessor :memory_cache_size, :http_open_timeout, :http_read_timeout, :http_open_retries, :http_read_retries, :base_url, :file_list

        def initialize
          @memory_cache_size = 10
          @http_open_timeout = 1
          @http_open_retries = 0
          @memory_cache_size = 0
          @base_url = "https://example.com/"
          @file_list = []
        end
      end
    end
  end
end
