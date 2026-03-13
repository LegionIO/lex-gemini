# lex-gemini: Google Gemini API Integration for LegionIO

**Repository Level 3 Documentation**
- **Category**: `/Users/miverso2/rubymine/legion/extensions-ai/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Google Gemini API. Generate content, create embeddings, manage files, count tokens, and cache content.

**GitHub**: https://github.com/LegionIO/lex-gemini
**License**: MIT

## Architecture

```
Legion::Extensions::Gemini
├── Runners/
│   ├── Content          # Text generation (generate, stream_generate)
│   ├── Embeddings       # Vector embeddings (embed, batch_embed)
│   ├── Models           # Model discovery (list, get)
│   ├── Tokens           # Token counting (count)
│   ├── Files            # File management (upload, list, get, delete)
│   └── CachedContents   # Content caching (create, list, get, update, delete)
└── Helpers/
    └── Client           # Faraday-based HTTP client (class, not module)
```

Unlike lex-claude and lex-openai, `Helpers::Client` is a **class** that is instantiated per-request rather than a module with a factory method. Each runner creates a new `Helpers::Client.new(api_key:, model:)` instance.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` | HTTP client for Gemini REST API |
| `faraday-multipart` | File uploads (optional — falls back to raw binary upload if not available) |

## API Base URL

`https://generativelanguage.googleapis.com/v1beta`

Authentication via API key query parameter (`?key=`). The key is set on the Faraday connection's params, so all requests automatically include it.

## Default Models

| Runner | Default Model |
|--------|--------------|
| Content | `gemini-2.0-flash` |
| Embeddings | `gemini-embedding-exp` |
| Tokens | `gemini-2.0-flash` |

## Testing

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
