# frozen_string_literal: true

module Legion
  module Extensions
    module Gemini
      module Runners
        module Content
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          def generate(api_key:, contents:, model: 'gemini-2.0-flash', generation_config: nil, safety_settings: nil,
                       system_instruction: nil, **)
            client = Helpers::Client.new(api_key: api_key, model: model)
            { result: client.generate_content(contents: contents, generation_config: generation_config,
                                              safety_settings: safety_settings, system_instruction: system_instruction) }
          end

          def stream_generate(api_key:, contents:, model: 'gemini-2.0-flash', generation_config: nil, safety_settings: nil,
                              system_instruction: nil, **)
            client = Helpers::Client.new(api_key: api_key, model: model)
            { result: client.stream_generate_content(contents: contents, generation_config: generation_config,
                                                     safety_settings: safety_settings,
                                                     system_instruction: system_instruction) }
          end
        end
      end
    end
  end
end
