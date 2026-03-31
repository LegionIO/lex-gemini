# frozen_string_literal: true

require 'legion/extensions/gemini/version'
require 'legion/extensions/gemini/helpers/client'
require 'legion/extensions/gemini/helpers/usage'
require 'legion/extensions/gemini/runners/content'
require 'legion/extensions/gemini/runners/embeddings'
require 'legion/extensions/gemini/runners/models'
require 'legion/extensions/gemini/runners/tokens'
require 'legion/extensions/gemini/runners/files'
require 'legion/extensions/gemini/runners/cached_contents'

module Legion
  module Extensions
    module Gemini
      extend Legion::Extensions::Core if defined?(Legion::Extensions::Core)
    end
  end
end
