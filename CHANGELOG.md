# Changelog

## [0.1.5] - 2026-04-06

### Added
- Credential-only identity module for Phase 8 Broker integration (`Identity` module with `provide_token`)

## [0.1.4] - 2026-03-31

### Added
- `Helpers::Usage` module with `extract_usage` helper that parses `usageMetadata` from Gemini API responses
- All runner methods now return a `usage:` key with `input_tokens`, `output_tokens`, `cache_read_tokens`, and `cache_write_tokens`
- Usage specs for all runners and the new `Helpers::Usage` module (80 examples total, up from 36)

## [0.1.3] - 2026-03-30

### Changed
- update to rubocop-legion 0.1.7, resolve all offenses

## [0.1.2] - 2026-03-22

### Changed
- add legion sub-gem runtime dependencies to gemspec (cache, crypt, data, json, logging, settings, transport)
- update spec_helper with real sub-gem requires and Helpers::Lex stub with all 7 includes

## [0.1.1] - 2026-03-18

### Changed
- deleted gemfile.lock

## [0.1.0] - 2026-03-13

### Added
- Initial release
