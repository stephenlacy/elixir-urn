defmodule URNTest do
  use ExUnit.Case, async: true

  alias URN

  describe ".parse/1" do
    test "urn:a:example" do
      {:ok, urn} = URN.parse("urn:a:example")

      assert urn.nid == "a"
      assert urn.nss == "example"
    end

    test "urn:A:example" do
      {:ok, urn} = URN.parse("urn:A:example")

      assert urn.nid == "A"
      assert urn.nss == "example"
    end

    test "urn:0:example" do
      {:ok, urn} = URN.parse("urn:0:example")

      assert urn.nid == "0"
      assert urn.nss == "example"
    end

    test "urn:z:example" do
      {:ok, urn} = URN.parse("urn:z:example")

      assert urn.nid == "z"
      assert urn.nss == "example"
    end

    test "urn:Z:example" do
      {:ok, urn} = URN.parse("urn:Z:example")

      assert urn.nid == "Z"
      assert urn.nss == "example"
    end

    test "urn:9:example" do
      {:ok, urn} = URN.parse("urn:9:example")

      assert urn.nid == "9"
      assert urn.nss == "example"
    end

    test "urn:abB2-:example" do
      {:ok, urn} = URN.parse("urn:abB2-:example")

      assert urn.nid == "abB2-"
      assert urn.nss == "example"
    end

    test "urn:aB2-b:example" do
      {:ok, urn} = URN.parse("urn:aB2-b:example")

      assert urn.nid == "aB2-b"
      assert urn.nss == "example"
    end

    test "urn:a2-bB:example" do
      {:ok, urn} = URN.parse("urn:a2-bB:example")

      assert urn.nid == "a2-bB"
      assert urn.nss == "example"
    end

    test "urn:a2-bB:exam%7Cple" do
      {:ok, urn} = URN.parse("urn:a2-bB:exam%7Cple")

      assert urn.nid == "a2-bB"
      assert urn.nss == "exam|ple"
    end

    test "urn:abcdef1234567890ABCDEF1234567890:example" do
      {:ok, urn} = URN.parse("urn:abcdef1234567890ABCDEF1234567890:example")

      assert urn.nid == "abcdef1234567890ABCDEF1234567890"
      assert urn.nss == "example"
    end

    test "urn:0-------------------------------:example" do
      {:ok, urn} = URN.parse("urn:0-------------------------------:example")

      assert urn.nid == "0-------------------------------"
      assert urn.nss == "example"
    end

    test "urn:12345678901234567890123456789012:example" do
      {:ok, urn} = URN.parse("urn:12345678901234567890123456789012:example")

      assert urn.nid == "12345678901234567890123456789012"
      assert urn.nss == "example"
    end

    test "urn:isbn:example" do
      {:ok, urn} = URN.parse("urn:isbn:example")

      assert urn.nid == "isbn"
      assert urn.nss == "example"
    end

    test "urn:ISBN:example" do
      {:ok, urn} = URN.parse("urn:ISBN:example")

      assert urn.nid == "ISBN"
      assert urn.nss == "example"
    end

    test "urn:somenid:example/foo" do
      {:ok, urn} = URN.parse("urn:somenid:example/foo")

      assert urn.nid == "somenid"
      assert urn.nss == "example/foo"
    end

    test "urn:somenid:example/foo,here/there" do
      {:ok, urn} = URN.parse("urn:somenid:example/foo,here/there")

      assert urn.nid == "somenid"
      assert urn.nss == "example/foo,here/there"
    end

    test "urn:somenid:a123,z456" do
      {:ok, urn} = URN.parse("urn:somenid:a123,z456")

      assert urn.nid == "somenid"
      assert urn.nss == "a123,z456"
    end

    test "urn:example:weather?=op=map&lat=39&lon=-104" do
      {:ok, urn} = URN.parse("urn:example:weather?=op=map&lat=39&lon=-104")

      assert urn.nid == "example"
      assert urn.nss == "weather"
      assert urn.query == "op=map&lat=39&lon=-104"
      assert urn.resolution == nil
      assert urn.fragment == nil
    end

    test "urn:example:foo-bar-baz-qux?+CCResolve:cc=uk" do
      {:ok, urn} = URN.parse("urn:example:foo-bar-baz-qux?+CCResolve:cc=uk")

      assert urn.nid == "example"
      assert urn.nss == "foo-bar-baz-qux"
      assert urn.query == nil
      assert urn.resolution == "CCResolve:cc=uk"
      assert urn.fragment == nil
    end

    test "urn:example:foo-bar-baz-qux#somepart" do
      {:ok, urn} = URN.parse("urn:example:foo-bar-baz-qux#somepart")

      assert urn.nid == "example"
      assert urn.nss == "foo-bar-baz-qux"
      assert urn.query == nil
      assert urn.resolution == nil
      assert urn.fragment == "somepart"
    end

    #
    # Invalid urns
    #

    test "urn:a2-bB:exam%7Jple" do
      {:error, "invalid urn"} = URN.parse("urn:a2-bB:exam%7Jple")
    end

    test "ur:nid:nss" do
      {:error, "invalid urn"} = URN.parse("ur:nid:nss")
    end

    test "urn:" do
      {:error, "invalid urn"} = URN.parse("urn:")
    end

    test "urn::" do
      {:error, "invalid urn"} = URN.parse("urn::")
    end

    test "urn: :" do
      {:error, "invalid urn"} = URN.parse("urn: :")
    end

    test "urn:nid" do
      {:error, "invalid urn"} = URN.parse("urn:nid")
    end

    test "urn:nid:" do
      {:error, "invalid urn"} = URN.parse("urn:nid:")
    end

    test "urn:nid :nss" do
      {:error, "invalid urn"} = URN.parse("urn:nid :nss")
    end

    test "urn:nid:nss " do
      {:error, "invalid urn"} = URN.parse("urn:nid:nss ")
    end
  end

  describe ".to_string/1" do
    test "urn:a:example" do
      urn = URN.new("a", "example")

      assert URN.to_string(urn) == "urn:a:example"
    end

    test "urn:A:example" do
      urn = URN.new("A", "example")

      assert URN.to_string(urn) == "urn:A:example"
    end

    test "urn:0:example" do
      urn = URN.new("0", "example")

      assert URN.to_string(urn) == "urn:0:example"
    end

    test "urn:z:example" do
      urn = URN.new("z", "example")

      assert URN.to_string(urn) == "urn:z:example"
    end

    test "urn:Z:example" do
      urn = URN.new("Z", "example")

      assert URN.to_string(urn) == "urn:Z:example"
    end

    test "urn:9:example" do
      urn = URN.new("9", "example")

      assert URN.to_string(urn) == "urn:9:example"
    end

    test "urn:abB2-:example" do
      urn = URN.new("abB2-", "example")

      assert URN.to_string(urn) == "urn:abB2-:example"
    end

    test "urn:aB2-b:example" do
      urn = URN.new("aB2-b", "example")

      assert URN.to_string(urn) == "urn:aB2-b:example"
    end

    test "urn:a2-bB:example" do
      urn = URN.new("a2-bB", "example")

      assert URN.to_string(urn) == "urn:a2-bB:example"
    end

    test "urn:a2-bB:exam|ple" do
      urn = URN.new("a2-bB", "exam|ple")

      assert URN.to_string(urn) == "urn:a2-bB:exam%7Cple"
    end

    test "urn:abcdef1234567890ABCDEF1234567890:example" do
      urn = URN.new("abcdef1234567890ABCDEF1234567890", "example")

      assert URN.to_string(urn) == "urn:abcdef1234567890ABCDEF1234567890:example"
    end

    test "urn:0-------------------------------:example" do
      urn = URN.new("0-------------------------------", "example")

      assert URN.to_string(urn) == "urn:0-------------------------------:example"
    end

    test "urn:12345678901234567890123456789012:example" do
      urn = URN.new("12345678901234567890123456789012", "example")

      assert URN.to_string(urn) == "urn:12345678901234567890123456789012:example"
    end

    test "urn:isbn:example" do
      urn = URN.new("isbn", "example")

      assert URN.to_string(urn) == "urn:isbn:example"
    end

    test "urn:ISBN:example" do
      urn = URN.new("ISBN", "example")

      assert URN.to_string(urn) == "urn:ISBN:example"
    end

    test "urn:somenid:example/foo" do
      urn = URN.new("somenid", "example/foo")

      assert URN.to_string(urn) == "urn:somenid:example/foo"
    end

    test "urn:somenid:example/foo,here/there" do
      urn = URN.new("somenid", "example/foo,here/there")

      assert URN.to_string(urn) == "urn:somenid:example/foo,here/there"
    end

    test "urn:somenid:a123,z456" do
      urn = URN.new("somenid", "a123,z456")

      assert URN.to_string(urn) == "urn:somenid:a123,z456"
    end

    test "urn:example:weather?=op=map&lat=39&lon=-104" do
      urn = URN.new("example", "weather", query: "op=map&lat=39&lon=-104")

      assert URN.to_string(urn) == "urn:example:weather?=op=map&lat=39&lon=-104"
    end

    test "urn:example:foo-bar-baz-qux?+CCResolve:cc=uk" do
      urn = URN.new("example", "foo-bar-baz-qux", resolution: "CCResolve:cc=uk")

      assert URN.to_string(urn) == "urn:example:foo-bar-baz-qux?+CCResolve:cc=uk"
    end

    test "urn:example:foo-bar-baz-qux#somepart" do
      urn = URN.new("example", "foo-bar-baz-qux", fragment: "somepart")

      assert URN.to_string(urn) == "urn:example:foo-bar-baz-qux#somepart"
    end
  end
end
