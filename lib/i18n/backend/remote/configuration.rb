# frozen_string_literal: true

module I18n
  module Backend
    class Remote
      class I18n::Backend::Remote::Configuration
        attr_accessor :root_dir,
                      :http_open_timeout, :http_read_timeout,
                      :base_url, :file_list, :faraday_process_count

        def initialize
          @http_open_timeout = 1
          @http_read_timout = 0
          @base_url = ""
          @faraday_process_count = 4
          @file_list = []
          @root_dir = "tmp"
        end

        def load_list
          file_list.map { |f| "#{root_dir}/#{f}" }.sort
        end
      end
    end
  end
end
