# frozen_string_literal: true

require "i18n/backend/base"
require "i18n/backend/transliterator"

module I18n
  module Backend
    class Remote
      # config and utils
      autoload :Configuration, "i18n/backend/remote/configuration"
      autoload :Utils, "i18n/backend/remote/utils"
      # Errors
      autoload :MissingBaseUrl, "i18n/backend/remote/errors"
      autoload :MissingFileList, "i18n/backend/remote/errors"
      autoload :ParseError, "i18n/backend/remote/errors"
      autoload :WriteError, "i18n/backend/remote/errors"
      # Operations
      autoload :FetchRemoteFile, "i18n/backend/remote/fetch_remote_file"
      autoload :ValidateYmlString, "i18n/backend/remote/validate_yml_string"
      autoload :WriteYml, "i18n/backend/remote/write_yml"

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
          @translations.keys.map(&:to_sym)
        end

        def store_translations(_locale, _data, options = {})
          options.fetch(:escape, true)
        end

        def reload!
          @translations = nil
          @errors = []
          fetch_remote_files
          validate_yml_string
          write_yml
          check_fall_back_locale
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

        private

        def fetch_remote_files
          res = I18n::Backend::Remote::FetchRemoteFile.new.call
          res.each do |key, value|
            case res[key].status
            when 200...302
              translations[key] = value.body
            else
              @errors << "server returned status #{res[key].status}"
            end
          end
        rescue MissingBaseUrl, MissingFileList => e
          @errors << e.message
        end

        def validate_yml_string
          puts "x"
        end

        def write_yml
          puts "x"
        end

        # fill @translations from local yml files if they exist
        def check_fall_back_locale
          puts "x"
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
