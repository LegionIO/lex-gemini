# lex-gemini: Google Gemini API Integration for LegionIO

**Repository Level 3 Documentation**
- **Category**: `/Users/miverso2/rubymine/legion/extensions/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Google Gemini API. Generate content, create embeddings, manage files, count tokens, and cache content.

**GitHub**: https://github.com/LegionIO/lex-gemini
**License**: MIT

## Architecture

```
Legion::Extensions::Gemini
├── Runners/
│   ├── Content          # Text generation (generate, stream)
│   ├── Embeddings       # Vector embeddings (single + batch)
│   ├── Models           # Model discovery (list, get)
│   ├── Tokens           # Token counting
│   ├── Files            # File management (upload, list, get, delete)
│   └── CachedContents   # Content caching (CRUD)
└── Helpers/
    └── Client           # Faraday-based HTTP client for Gemini REST API
```

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` | HTTP client for Gemini REST API |

## API Base URL

`https://generativelanguage.googleapis.com/v1beta`

Authentication via API key query parameter (`?key=`).

## Testing

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
