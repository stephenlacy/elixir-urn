# URN

[![Build Status](https://travis-ci.org/stevelacy/elixir-urn.png?branch=master)](https://travis-ci.org/stevelacy/elixir-urn)

> [hex.pm documentation](https://hexdocs.pm/urn/readme.html)

**Uniform Resource Name (URN) parsing and validation in Elixir**

## Installation

Add `urn` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:urn, "~> 0.1.0"}]
end
```

## Example

```elixir
defmodule Project do
  alias URN
  def action() do
    # Parse input string "urn:collection:id" to Map
    {:ok, urn} = URN.parse("urn:collection:id")

    IO.inspect urn
    # %URN{fragment: nil, nid: "collection", nss: "id", query: nil, resolution: nil}

    # Turn back into a string
    URN.to_string(urn)
    # urn:collection:id
  end

end

```

License [MIT](LICENSE)
