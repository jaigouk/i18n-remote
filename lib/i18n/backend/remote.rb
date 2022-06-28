# frozen_string_literal: true

require "i18n/backend/base"
require "i18n/backend/transliterator"

module I18n
  module Backend
    class Remote
      autoload :Configuration, "i18n/backend/remote/configuration"
      autoload :Error, "i18n/backend/remote/error"
      autoload :HttpClient, "i18n/backend/remote/http_client"

      def initialize(options = {})
        @options = {
          http_open_timeout: self.class.config.http_open_timeout,
          http_read_timeout: self.class.config.http_read_timeout,
          http_open_retries: self.class.config.http_open_retries,
          http_read_retries: self.class.config.http_read_retries,
          memory_cache_size: self.class.config.memory_cache_size
        }.merge(options)
        reload!
      end

      class << self
        def configure
          yield(config) if block_given?
        end

        def config
          @config ||= Configuration.new
        end
      end

      module Implementation
        include Base
        include Flatten

        def available_locales
          []
        end

        def store_translations(_locale, _data, options = {})
          options.fetch(:escape, true)
        end

        def reload!
          @translations = nil

          self
        end

        def initialized?
          !@translations.nil?
        end

        def init_translations
          @translations = {}
        end

        def translations(do_init: false)
          init_translations if do_init || !initialized?
          @translations ||= {}
        end

        protected

        def lookup(locale, _key, _scope = [], _options = {})
          puts locale
        end
      end

      include Implementation
    end
  end
end
