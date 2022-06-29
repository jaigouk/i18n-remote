# frozen_string_literal: true

module I18n
  module Backend
    class Remote
      class I18n::Backend::Remote::Configuration
        attr_accessor :memory_cache_size,
                      :http_open_timeout, :http_read_timeout,
                      :base_url, :file_list, :faraday_process_count

        def initialize
          @memory_cache_size = 10
          @http_open_timeout = 1
          @http_read_timout = 0
          @memory_cache_size = 0
          @base_url = ""
          @faraday_process_count = 4
          @file_list = []
        end
      end
    end
  end
end
