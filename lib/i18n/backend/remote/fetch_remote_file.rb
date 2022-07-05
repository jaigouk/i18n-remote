# frozen_string_literal: true

require "faraday"
require "parallel"
require "faraday/net_http_persistent"

module I18n
  module Backend
    class Remote
      class FetchRemoteFile
        def initialize
          @base_url = I18n::Backend::Remote.config.base_url
          @file_list = I18n::Backend::Remote.config.file_list
          @faraday_process_count = I18n::Backend::Remote.config.faraday_process_count
          @idle_timeout = I18n::Backend::Remote.config.http_read_timeout

          # for now we disable ssl verification
          @ssl_verify = false
          @client_certificate = nil
          @client_private_key = nil
        end

        attr_reader :base_url, :file_list, :faraday_process_count,
                    :idle_timeout, :ssl_verify, :client_certificate,
                    :client_private_key

        def call
          guard
          fetch
        end

        private

        def guard
          raise ::I18n::Backend::Remote::MissingBaseUrl if nil_or_empty?(base_url)
          raise ::I18n::Backend::Remote::MissingFileList if nil_or_empty?(file_list)
        end

        def fetch
          @result ||= {}
          Parallel.map(file_list, in_processes: faraday_process_count) do |file|
            @result[file] = http_request(file)
          end
          @result
        end

        Response = Struct.new(:status, :body, keyword_init: true)

        private_constant :Response

        # rubocop:disable  Metrics/AbcSize, Metrics/MethodLength
        def http_request(file)
          resp = connection.get(file)
          Response.new(
            status: resp.status,
            body: resp.body
          )
        rescue Faraday::ConnectionFailed => e
          Response.new(
            status: 502,
            body: e.message
          )
        rescue Faraday::UnauthorizedError => e
          Response.new(
            status: 401,
            body: e.message
          )
        rescue Faraday::ForbiddenError => e
          Response.new(
            status: 403,
            body: e.message
          )
        rescue Faraday::ResourceNotFound => e
          Response.new(
            status: 404,
            body: e.message
          )
        rescue Faraday::ProxyAuthError => e
          Response.new(
            status: 407,
            body: e.message
          )
        rescue Faraday::ConflictError => e
          Response.new(
            status: 409,
            body: e.message
          )
        rescue Faraday::UnprocessableEntityError => e
          Response.new(
            status: 422,
            body: e.message
          )
        rescue Faraday::ServerError, Faraday::SSLError, Faraday::ParsingError => e
          Response.new(
            status: 500,
            body: e.message
          )
        end
        # rubocop:enable  Metrics/AbcSize, Metrics/MethodLength

        def connection
          Faraday.new(url: base_url, ssl: ssl_options) do |f|
            f.adapter :net_http_persistent, pool_size: 5 do |http|
              http.idle_timeout = idle_timeout
            end
          end
        end

        def ssl_options
          {
            client_cert: client_certificate,
            client_key: client_private_key,
            verify: ssl_verify
          }
        end

        def nil_or_empty?(data)
          I18n::Backend::Remote::Utils.nil_or_empty?(data)
        end
      end
    end
  end
end
