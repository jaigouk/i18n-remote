# frozen_string_literal: true

require "i18n/backend/transliterator"
require "i18n/backend/base"
require "i18n/backend/flatten"
require "i18n/backend/remote/error"
require "i18n/backend/remote/configuration"

module I18n
  module Backend
    class Remote
      autoload :Error, "i18n/backend/remote/error"
      autoload :Configuration, "i18n/backend/remote/configuration"

      class << self
        def configure
          yield(config) if block_given?
        end

        def config
          @config ||= Configuration.new
        end
      end

      def initialize
        reload!
      end

      module Implementation
        include Base
        include Flatten

        def available_locales
          Translation.available_locales
        rescue ::ActiveRecord::StatementInvalid
          []
        end

        def store_translations(_locale, _data, options = {})
          escape = options.fetch(:escape, true)
          escape
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

        def lookup(locale, key, scope = [], options = {})
          key = normalize_flat_keys(locale, key, scope, options[:separator])
          key = key[1..] if key.first == "."
          key = key[0..-2] if key.last == "."
          key
        end

        def build_translation_hash_by_key(_lookup_key, _translation)
          {}
        end
      end

      include Implementation
    end
  end
end
