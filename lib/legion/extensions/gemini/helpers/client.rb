# frozen_string_literal: true

require 'faraday'
require 'json'

module Legion
  module Extensions
    module Gemini
      module Helpers
        class Client
          BASE_URL = 'https://generativelanguage.googleapis.com'
          API_VERSION = 'v1beta'

          attr_reader :api_key, :model, :connection

          def initialize(api_key:, model: 'gemini-2.0-flash', base_url: BASE_URL)
            @api_key = api_key
            @model   = model
            @connection = Faraday.new(url: base_url) do |conn|
              conn.request :json
              conn.response :json
              conn.params['key'] = api_key
            end
          end

          def generate_content(contents:, generation_config: nil, safety_settings: nil, system_instruction: nil, model: @model)
            body = { contents: contents }
            body[:generationConfig] = generation_config if generation_config
            body[:safetySettings] = safety_settings if safety_settings
            body[:systemInstruction] = system_instruction if system_instruction
            post("#{API_VERSION}/models/#{model}:generateContent", body)
          end

          def stream_generate_content(contents:, generation_config: nil, safety_settings: nil, system_instruction: nil, model: @model)
            body = { contents: contents }
            body[:generationConfig] = generation_config if generation_config
            body[:safetySettings] = safety_settings if safety_settings
            body[:systemInstruction] = system_instruction if system_instruction
            post("#{API_VERSION}/models/#{model}:streamGenerateContent", body)
          end

          def embed_content(content:, task_type: nil, title: nil, model: @model)
            body = { content: content }
            body[:taskType] = task_type if task_type
            body[:title] = title if title
            post("#{API_VERSION}/models/#{model}:embedContent", body)
          end

          def batch_embed_contents(requests:, model: @model)
            post("#{API_VERSION}/models/#{model}:batchEmbedContents", { requests: requests })
          end

          def list_models
            get("#{API_VERSION}/models")
          end

          def get_model(name:)
            get("#{API_VERSION}/models/#{name}")
          end

          def count_tokens(contents:, model: @model)
            post("#{API_VERSION}/models/#{model}:countTokens", { contents: contents })
          end

          def upload_file(file_path:, mime_type:, display_name: nil)
            metadata = { file: { mimeType: mime_type } }
            metadata[:file][:displayName] = display_name if display_name

            upload_conn = Faraday.new(url: BASE_URL) do |conn|
              conn.params['key'] = api_key
            end

            payload = Faraday::Multipart::FilePart.new(file_path, mime_type) if defined?(Faraday::Multipart)

            if payload
              upload_conn.request :multipart
              upload_conn.post("/upload/#{API_VERSION}/files") do |req|
                req.body = { metadata: metadata.to_json, file: payload }
              end
            else
              upload_conn.post("/upload/#{API_VERSION}/files") do |req|
                req.headers['Content-Type'] = mime_type
                req.headers['X-Goog-Upload-Protocol'] = 'raw'
                req.body = File.binread(file_path)
              end
            end
          end

          def list_files(page_size: nil, page_token: nil)
            params = {}
            params[:pageSize] = page_size if page_size
            params[:pageToken] = page_token if page_token
            get("#{API_VERSION}/files", params)
          end

          def get_file(name:)
            get("#{API_VERSION}/#{name}")
          end

          def delete_file(name:)
            delete("#{API_VERSION}/#{name}")
          end

          def create_cached_content(model:, contents:, ttl: nil, expire_time: nil, display_name: nil, system_instruction: nil)
            body = { model: "models/#{model}", contents: contents }
            body[:ttl] = ttl if ttl
            body[:expireTime] = expire_time if expire_time
            body[:displayName] = display_name if display_name
            body[:systemInstruction] = system_instruction if system_instruction
            post("#{API_VERSION}/cachedContents", body)
          end

          def list_cached_contents(page_size: nil, page_token: nil)
            params = {}
            params[:pageSize] = page_size if page_size
            params[:pageToken] = page_token if page_token
            get("#{API_VERSION}/cachedContents", params)
          end

          def get_cached_content(name:)
            get("#{API_VERSION}/#{name}")
          end

          def update_cached_content(name:, ttl: nil, expire_time: nil)
            body = {}
            update_masks = []
            if ttl
              body[:ttl] = ttl
              update_masks << 'ttl'
            end
            if expire_time
              body[:expireTime] = expire_time
              update_masks << 'expireTime'
            end
            patch("#{API_VERSION}/#{name}", body, updateMask: update_masks.join(','))
          end

          def delete_cached_content(name:)
            delete("#{API_VERSION}/#{name}")
          end

          private

          def get(path, params = {})
            response = connection.get(path, params)
            handle_response(response)
          end

          def post(path, body)
            response = connection.post(path, body)
            handle_response(response)
          end

          def patch(path, body, params = {})
            response = connection.patch(path) do |req|
              req.params = connection.params.merge(params)
              req.body = body
            end
            handle_response(response)
          end

          def delete(path)
            response = connection.delete(path)
            handle_response(response)
          end

          def handle_response(response)
            return response.body if response.success?

            { error: response.body, status: response.status }
          end
        end
      end
    end
  end
end
