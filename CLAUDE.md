# lex-gemini: Google Gemini API Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-ai/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Google Gemini API. Generate content, create embeddings, manage files, count tokens, and cache content.

**GitHub**: https://github.com/LegionIO/lex-gemini
**License**: MIT
**Version**: 0.1.1
**Specs**: 36 examples

## Architecture

```
Legion::Extensions::Gemini
├── Runners/
│   ├── Content          # generate(api_key:, contents:, model:, ...), stream_generate(...)
│   ├── Embeddings       # embed(api_key:, content:, model:, ...), batch_embed(...)
│   ├── Models           # list(api_key:, ...), get(api_key:, name:, ...)
│   ├── Tokens           # count(api_key:, contents:, model:, ...)
│   ├── Files            # upload(api_key:, file_path:, mime_type:, ...), list, get, delete
│   └── CachedContents   # create(api_key:, model:, contents:, ...), list, get, update, delete
└── Helpers/
    └── Client           # Faraday-based HTTP client (class, instantiated per-request)
```

Unlike lex-claude and lex-openai, `Helpers::Client` is a **class** instantiated per-request. Each runner creates `Helpers::Client.new(api_key:, model:)` inline. This means no module-level `extend` is used in runners; instead, runners call `Helpers::Client.new(...)` directly.

`include Legion::Extensions::Helpers::Lex` guard: uses `if defined?(Legion::Extensions::Helpers::Lex)` (note: slightly different guard pattern from lex-claude/lex-openai which use `const_defined?`).

## Key Design Decisions

- `Helpers::Client` is a class to allow per-request model selection without global state.
- Authentication uses query parameter `?key=<api_key>` set on the Faraday connection params, so all requests automatically include it.
- File upload falls back to raw binary upload (`X-Goog-Upload-Protocol: raw`) when `faraday-multipart` is not loaded.
- `Helpers::Client#handle_response` returns the raw body on success and `{ error: body, status: code }` on failure. All runners wrap the `Helpers::Client` return value in `{ result: ... }`, so the actual runner-level return shape is `{ result: <body> }` on success and `{ result: { error: ..., status: ... } }` on failure.
- `gemini-2.0-flash` is the default model for Content, Tokens, and `Helpers::Client` initialization.
- `gemini-embedding-exp` is the default model for Embeddings runners.

## API Base URL

`https://generativelanguage.googleapis.com` — path prefix `v1beta` is prepended per-request in `Helpers::Client`.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` >= 2.0 | HTTP client for Gemini REST API |
| `faraday-multipart` | File uploads (optional — falls back to raw binary upload if not available) |

## Testing

```bash
bundle install
bundle exec rspec        # 36 examples
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
