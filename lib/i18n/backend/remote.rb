# frozen_string_literal: true

require "i18n/backend/base"
require "i18n/backend/transliterator"

module I18n
  module Backend
    class Remote
      autoload :Configuration, "i18n/backend/remote/configuration"
      # Operations
      autoload :FetchRemoteFile, "i18n/backend/remote/fetch_remote_file"
      autoload :ValidateYmlString, "i18n/backend/remote/validate_yml_string"
      autoload :WriteYml, "i18n/backend/remote/write_yml"
      # Errors
      autoload :MissingBaseUrl, "i18n/backend/remote/errors"
      autoload :MissingFileList, "i18n/backend/remote/errors"
      autoload :ParseError, "i18n/backend/remote/errors"
      autoload :WriteError, "i18n/backend/remote/errors"

      def initialize
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
          !@translations.nil? && !self.class.config.base_url.nil? && !self.class.config.file_list.empty?
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
