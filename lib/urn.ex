defmodule URN do
  @moduledoc """
  Uniform Resource Name tooling.

  URNs are a smaller subset of URIs. Both share a scheme and the same encoding
  directives.

  For more indepth knowledge about what a URN is, check out [RFC8141][rfc8141].

  [rfc8141]: <https://tools.ietf.org/html/rfc8141>
  """

  defstruct [:nid, :nss, :resolution, :query, :fragment]

  @type t() :: %__MODULE__{
          nid: term(),
          nss: term(),
          resolution: term(),
          query: term(),
          fragment: term()
        }

  @type reason() :: String.t() | term()

  @spec new(String.t(), String.t(), []) :: t() | {:error, reason()}
  def new(nid, nss, opts \\ []) do
    %__MODULE__{
      nid: nid,
      nss: nss,
      resolution: Keyword.get(opts, :resolution),
      query: Keyword.get(opts, :query),
      fragment: Keyword.get(opts, :fragment)
    }
  end

  def parse(nil), do: {:error, "invalid urn"}

  @doc """
  Parses a urn string into it's various parts.

  # Example

      {:ok, urn} = URN.parse("urn:example:a123,z456?+abc")
  """
  @spec parse(String.t()) :: {:ok, t()} | {:reason, reason()}
  def parse(str) when is_binary(str) do
    with {:ok, parts} <- extract_parts(str) do
      try do
        {
          :ok,
          %__MODULE__{
            nid: maybe_decode(Map.get(parts, "nid")),
            nss: maybe_decode(Map.get(parts, "nss")),
            resolution: maybe_decode(Map.get(parts, "resolution")),
            query: maybe_decode(Map.get(parts, "query")),
            fragment: maybe_decode(Map.get(parts, "fragment"))
          }
        }
      rescue
        ArgumentError -> {:error, "invalid urn"}
      end
    end
  end

  def parse(_), do: {:error, "invalid urn"}

  @spec parse!(String.t()) :: t()
  def parse!(str) do
    case parse(str) do
      {:ok, urn} -> urn
      {:error, reason} -> raise "Parse error #{inspect(reason)}"
    end
  end

  @spec to_string(t()) :: String.t()
  def to_string(nil), do: ""

  def to_string(urn) do
    IO.iodata_to_binary([
      "urn",
      ?:,
      URI.encode(urn.nid),
      ?:,
      URI.encode(urn.nss),
      if_component(urn.resolution, "?+"),
      if_component(urn.query, "?="),
      if_component(urn.fragment, "#")
    ])
  end


  @doc """
  Checks if two URNs are equal.

  Something to note, when comparing URNs, resolution, query, and fragments are
  ignored. This is outlined in the [spec](https://tools.ietf.org/html/rfc8141#section-2.3).

  """
  def equal?(%__MODULE__{} = a, %__MODULE__{} = b) do
    String.downcase(a.nid) == String.downcase(b.nid) and a.nss == b.nss
  end

  def equal?(a, b) when is_binary(a) and is_binary(b) do
    with {:ok, urna} <- parse(a),
         {:ok, urnb} <- parse(b) do
      equal?(urna, urnb)
    else
      {:error, _} ->
        false
    end
  end

  ##
  ## Helpers
  ##

  defp if_component(component, prefix) do
    if component do
      [prefix, URI.encode(component)]
    else
      []
    end
  end

  defp extract_parts(str) do
    alphanum = ~r/[a-zA-Z0-9\-]+/.source
    pchar = ~r/([a-zA-Z0-9\-!\$\&'\(\)\*\+\.,;=_~:@\/\%])+/.source

    # I know this looks ugly, but I don't know a better way to compose this
    ~r/\A(?<scheme>[uU][rR][nN]):(?<nid>#{alphanum}):(?<nss>#{pchar})(\?\+(?<resolution>#{pchar}))?(\?=(?<query>#{pchar}))?(#(?<fragment>#{pchar}))?\Z/
    |> Regex.named_captures(str)
    |> case do
      nil -> {:error, "invalid urn"}
      matched -> {:ok, matched}
    end
  end

  defp maybe_decode(nil), do: nil
  defp maybe_decode(""), do: nil
  defp maybe_decode(str), do: URI.decode(str)
end
