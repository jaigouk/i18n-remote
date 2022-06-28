# frozen_string_literal: true

require "faraday"

module I18n
  module Backend
    class Remote
      class NotFound < StandardError; end
      class FetchRemoteFile

        def initialize
          @base_url = I18n::Backend::Remote.config.base_url
          @file_list = I18n::Backend::Remote.config.file_list
        end

        attr_reader :base_url, :file_list

        # iterate through yml file list
        # parse yaml and save.
        # return @translate
        #
        # Guard
        #
        # - empty file_list
        # -
        #
        # error cases
        #
        # - connection problem
        # - missing file
        # - wrong yaml
        # - local dir does not exist
        def call
          conn = Faraday.new(base_url)
          response = conn.get("en.yml", nil, { "User-Agent" => "Mozilla/5.0" })

          if response.status == 401
            @token = nil

            raise NotFound
          end
          response
        end

        # private
      end
    end
  end
end
