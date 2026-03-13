# lex-gemini

Google Gemini API integration for [LegionIO](https://github.com/LegionIO/LegionIO). Generate content, create embeddings, manage files, count tokens, and cache content using Google's Gemini models.

## Installation

```bash
gem install lex-gemini
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
embedding = client.embed_content(
  content: { parts: [{ text: 'Hello world' }] },
  model: 'gemini-embedding-exp'
)
puts embedding['embedding']['values'].length

# Count tokens
tokens = client.count_tokens(
  contents: [{ parts: [{ text: 'How many tokens?' }] }]
)
puts tokens['totalTokens']
```

## Requirements

- Ruby >= 3.4
- [LegionIO](https://github.com/LegionIO/LegionIO) framework (optional for standalone usage)
- Google Gemini API key ([Get one here](https://ai.google.dev/))
- `faraday-multipart` gem (optional — required only for multipart file uploads; raw binary upload used as fallback)

## License

MIT
