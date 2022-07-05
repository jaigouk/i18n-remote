# frozen_string_literal: true

require "i18n/backend/base"
require "i18n/backend/transliterator"
require "i18n/utils"

# config
require "i18n/backend/remote/configuration"
require "i18n/backend/remote/utils"
# Errors
require "i18n/backend/remote/errors"
# Operations
require "i18n/backend/remote/fetch_remote_file"
require "i18n/backend/remote/validate_yml_string"
require "i18n/backend/remote/write_yml"

module I18n
  module Backend
    class Remote
      # config and utils
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

        def store_translations(locale, data, options = {})
          return unless data.is_a?(Hash)

          @translations[locale] = data
          data = deep_symbolize_keys(data) unless options.fetch(:skip_symbolize_keys, false)

          deep_merge(@translations[locale], data)
        end

        def reload!
          @initialized = false
          @translations = {}
          @errors = []
          @parsed = {}
          @fallback_list = {}
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
        end

        protected

        def init_translations
          fetch_remote_files
          validate_yml_string
          write_yml
          check_fall_back_locale
          verify_initialization
        end

        def lookup(locale, key, _scope = [], _options = {})
          keys = ([locale] + key.split(I18n::Backend::Flatten::FLATTEN_SEPARATOR)).map(&:to_sym)
          @translations.dig(*keys)
        end

        def check_configuration
          return if I18n::Backend::Remote.config.valid?

          @errors << "Missing configurations"
        end

        private

        def fetch_remote_files
          res = I18n::Backend::Remote::FetchRemoteFile.new.call
          res.each do |key, value|
            case res[key].status
            when (200...300) || 302
              @translations[key] = value.body
            else
              mark_file_for_fallback(key)
              @errors << "server returned status #{res[key].status} for #{key} file"
            end
          end
        rescue MissingBaseUrl, MissingFileList => e
          @errors << e.message
        end

        def validate_yml_string
          temp = {}
          @translations.each do |key, value|
            res = I18n::Backend::Remote::ValidateYmlString.new(value).call
            assign_values(temp, res, key)
          rescue I18n::Backend::Remote::ParseError => e
            @errors << e.message
            next
          end
          @translations.merge!(temp)
          @translations = I18n::Utils.deep_symbolize_keys(@translations)
        end

        def assign_values(temp, res, key)
          root_key = res.parsed.keys.first
          temp[root_key] = res.parsed[root_key]
          @parsed[key] = res.str
          @translations.delete(key)
        end

        def write_yml
          @parsed.each do |key, value|
            I18n::Backend::Remote::WriteYml.new(
              value, key, I18n::Backend::Remote.config.root_dir
            ).call
          end
        end

        # fill @translations from local yml files if they exist
        def check_fall_back_locale
          I18n::Backend::Remote.config.load_list.each do |file|
            unless File.exist?(file)
              @errors << "#{file} does not exist"
              next
            end

            unless @fallback_list[file]
              @errors << "#{file} is not in the fallback list"
              next
            end

            data = deep_symbolize_keys(Psych.load_file(file))
            @translations.merge!(data)
          rescue Psych::SyntaxError => e
            @errors << e.message
            next
          end
        end

        def mark_file_for_fallback(filename)
          @fallback_list["#{I18n::Backend::Remote.config.root_dir}/#{filename}"] = true
        end

        def deep_symbolize_keys(data)
          I18n::Utils.deep_symbolize_keys(data)
        end

        def deep_merge(source, data)
          I18n::Utils.deep_merge!(source, data)
        end

        def verify_initialization
          @initialized = true if @translations.keys.size == I18n::Backend::Remote.config.file_list.size
        end
      end

      include Implementation
    end
  end
end
