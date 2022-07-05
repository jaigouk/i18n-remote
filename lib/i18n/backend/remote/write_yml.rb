# frozen_string_literal: true

require "psych"

module I18n
  module Backend
    class Remote
      class WriteYml
        def initialize(str, filename, dir)
          @str = str
          @file_path = dir
          @filename = filename
        end

        attr_reader :str, :filename, :file_path

        def call
          guard
          write
        end

        private

        def guard
          raise ::I18n::Backend::Remote::WriteError, "Empty data for yaml file" if nil_or_empty?(str)

          raise ::I18n::Backend::Remote::WriteError, "Filename is empty" if Utils.nil_or_empty?(filename)

          raise ::I18n::Backend::Remote::WriteError, "input directory is empty" if nil_or_empty?(file_path)

          return if Dir.exist?(file_path)

          raise ::I18n::Backend::Remote::WriteError,
                "Directory to write yml file does not exist"
        end

        Response = Struct.new(:errors, keyword_init: true)
        private_constant :Response

        def write
          File.write(write_path, str)
          Response.new(errors: nil)
        rescue Errno::ENOENT => e
          Response.new(errors: e.message)
        end

        def write_path
          "#{file_path}/#{filename}"
        end

        def nil_or_empty?(data)
          I18n::Backend::Remote::Utils.nil_or_empty?(data)
        end
      end
    end
  end
end
