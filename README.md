# lex-gemini

Google Gemini API integration for LegionIO. Generate content, create embeddings, manage files, count tokens, and cache content using Google's Gemini models.

## Purpose

Wraps the Google Gemini REST API as named runners consumable by any LegionIO task chain. Includes resource-specific operations (file management, content caching) not available through the `legion-llm` unified interface. Use this extension when you need direct access to the full Gemini API surface within the LEX runner/actor lifecycle.

## Installation

```bash
gem install lex-gemini
```

Or add to your Gemfile:

```ruby
gem 'lex-gemini'
```

## Functions

### Content
- `generate` - Generate text content using Gemini models
- `stream_generate` - Stream generated content

### Embeddings
- `embed` - Generate embedding vectors from text
- `batch_embed` - Generate multiple embeddings in one request

### Models
- `list` - List available Gemini models
- `get` - Get details about a specific model

### Tokens
- `count` - Count tokens in content

### Files
- `upload` - Upload a file for use with Gemini
- `list` - List uploaded files
- `get` - Get file metadata
- `delete` - Delete an uploaded file

### Cached Contents
- `create` - Create cached content for repeated use
- `list` - List cached contents
- `get` - Get cached content details
- `update` - Update cached content expiration
- `delete` - Delete cached content

## Configuration

Set your API key in your LegionIO settings:

```json
{
  "gemini": {
    "api_key": "AIza..."
  }
}
```

## Standalone Usage

```ruby
require 'legion/extensions/gemini/helpers/client'

client = Legion::Extensions::Gemini::Helpers::Client.new(
  api_key: ENV['GEMINI_API_KEY'],
  model: 'gemini-2.0-flash'
)

# Generate content
result = client.generate_content(
  contents: [{ parts: [{ text: 'Explain quantum entanglement in one sentence.' }] }]
)
puts result.dig('candidates', 0, 'content', 'parts', 0, 'text')

# Generate embeddings
embedding_client = Legion::Extensions::Gemini::Helpers::Client.new(
  api_key: ENV['GEMINI_API_KEY'],
  model: 'gemini-embedding-exp'
)
embedding = embedding_client.embed_content(
  content: { parts: [{ text: 'Hello world' }] }
)
puts embedding['embedding']['values'].length

# Count tokens
tokens = client.count_tokens(
  contents: [{ parts: [{ text: 'How many tokens?' }] }]
)
puts tokens['totalTokens']
```

## Dependencies

- `faraday` >= 2.0 - HTTP client
- `faraday-multipart` (optional) - required only for multipart file uploads; raw binary upload used as fallback

## Requirements

- Ruby >= 3.4
- [LegionIO](https://github.com/LegionIO/LegionIO) framework (optional for standalone usage)
- Google Gemini API key ([Get one here](https://ai.google.dev/))

## Related

- `legion-llm` — High-level LLM interface including Gemini via ruby_llm
- `extensions-ai/CLAUDE.md` — Architecture patterns shared across all AI extensions

## Version

0.1.5

## License

MIT
