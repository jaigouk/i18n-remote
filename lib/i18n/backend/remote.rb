# frozen_string_literal: true

require "i18n/backend/base"
require "i18n/backend/transliterator"
require "i18n/utils"

module I18n
  module Backend
    class Remote
      # config and utils
      autoload :Configuration, "i18n/backend/remote/configuration"
      autoload :Utils, "i18n/backend/remote/utils"
      # Errors
      autoload :MissingBaseUrl, "i18n/backend/remote/errors"
      autoload :MissingFileList, "i18n/backend/remote/errors"
      autoload :ConfigurationError, "i18n/backend/remote/errors"
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

        attr_reader :errors

        # also rewrites the yml file
        def store_translations(locale, data, options = {})
          return unless data.is_a?(Hash)

          @translations[locale] = data
          data = I18n::Utils.deep_symbolize_keys(data) unless options.fetch(:skip_symbolize_keys, false)

          I18n::Utils.deep_merge!(@translations[locale], data)
        end

        def reload!
          @initialized = false
          @translations = {}
          @errors = []
          check_configuration
          init_translations
          self
        end

        def initialized?
          @initialized ||= false
        end

        def translations(do_init: false)
          init_translations if do_init || !initialized?
          @translations ||= {}
          @initialized = true
        end

        protected

        def lookup(locale, key, _scope = [], _options = {})
          keys = ([locale] + key.split(I18n::Backend::Flatten::FLATTEN_SEPARATOR)).map(&:to_sym)
          @translations.dig(*keys)
        end

        def check_configuration
          return if I18n::Backend::Remote.config.valid?

          @errors << "Missing configurations"
        end

        def init_translations
          fetch_remote_files
          validate_yml_string
          write_yml
          check_fall_back_locale
          @initialized = true
        end

        private

        def fetch_remote_files
          res = I18n::Backend::Remote::FetchRemoteFile.new.call
          res.each do |key, value|
            case res[key].status
            when (200...300) || 302
              @translations[key] = value.body
            else
              @errors << "server returned status #{res[key].status}"
            end
          end
        rescue MissingBaseUrl, MissingFileList => e
          @errors << e.message
        end

        def validate_yml_string
          temp = {}
          @translations.each do |key, value|
            res = I18n::Backend::Remote::ValidateYmlString.new(value).call
            root_key = res.parsed.keys.first
            temp[root_key] = res.parsed[root_key]
            @translations.delete(key)
          rescue I18n::Backend::Remote::ParseError => e
            @errors << e.message
            next
          end
          @translations.merge!(temp)
          @translations = I18n::Utils.deep_symbolize_keys(@translations)
        end

        def write_yml
          puts "x"
        end

        # fill @translations from local yml files if they exist
        def check_fall_back_locale
          puts "x"
        end

        # def nil_or_empty?(data)
        #   I18n::Backend::Remote::Utils.nil_or_empty?(data)
        # end
      end

      include Implementation
    end
  end
end
