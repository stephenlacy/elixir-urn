# Changelog


## Unreleased

### Removed
- Removed `Urn.Schema` because the struct should just be defined at the top
  level, similar to Elixir's [URI](https://hexdocs.pm/elixir/URI.html).
- Removed `Urn` this does not follow the spec [RFC8141][rfc8141].

### Added
- `URN.equal?/2`
- `URN.parse/1`


[rfc8141]: <https://tools.ietf.org/html/rfc8141>
