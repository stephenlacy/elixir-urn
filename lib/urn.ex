defmodule Urn do
  @moduledoc """
  Documentation for Urn.

  ## Examples

  ### parse

      iex> Urn.parse("urn:mycoll:143")
      %Urn.Schema{collection: "mycoll", identifier: "143", namespace: "urn"}

  ### verify

      iex> Urn.verify("urn:mycoll:143", "urn:mycoll:143")
      true

  ### verify_namespace

      iex> Urn.verify_namespace("urn:mycoll:143", "urn")
      true

  ### verify_collection

      iex> Urn.verify_collection("urn:mycoll:143", "mycoll")
      true

  """
  defmodule Schema do
    @moduledoc """
    URN Schema

    Follows the format identified [here](http://philcalcado.com/2017/03/22/pattern_using_seudo-uris_with_microservices.html#creating-a-good-enough-puri-spec)

    ## Example:

    "namespace:collection:identifier"

    ```elixir
      %Schema{
        namespace: "namespace",
        collection: "collection",
        identifier: "identifier"
      }
    ```

    """
    defstruct namespace: nil, collection: nil, identifier: nil
  end

  def parse([ namespace, collection, identifier ]) do
    %Schema{
      namespace: namespace,
      collection: collection,
      identifier: identifier,
    }
  end

  def parse(str) when is_binary(str) do
    parse(String.split(str, ":"))
  end

  def parse (str) do
    raise "A valid URN is required in this format: namespace:collection:identifier, received: #{str}"
  end

  def verify(a, a), do: true

  def verify(a, b) do
    raise "Validation failed: #{a} does not match #{b}"
  end

  def verify_namespace(str, namespace) when is_binary(str) do
    parsed = parse str
    verify_namespace parsed, namespace
  end

  def verify_namespace(%Schema{ namespace: namespace }, nsp) when namespace == nsp, do: true

  def verify_namespace(%Schema{ namespace: namespace }, nsp) do
    raise "Validation failed: #{namespace} does not match #{nsp}"
  end

  def verify_collection(str, namespace) when is_binary(str) do
    parsed = parse str
    verify_collection parsed, namespace
  end

  def verify_collection(%Schema{ collection: collection }, col) when collection == col, do: true

  def verify_collection(%Schema{ collection: collection }, col) do
    raise "Validation failed: #{collection} does not match #{col}"
  end
end
