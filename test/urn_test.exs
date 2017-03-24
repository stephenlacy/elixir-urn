defmodule UrnTest do
  use ExUnit.Case
  doctest Urn

  test "parse valid URN" do
    parsed = Urn.parse("urn:mycoll:143")
    assert parsed.namespace == "urn"
    assert parsed.collection == "mycoll"
    assert parsed.identifier == "143"
  end

  test "parse invalid URN" do
    message = "A valid URN is required in this format:" <>
      " namespace:collection:identifier, received: urn143"
    assert_raise RuntimeError, message, fn ->
      Urn.parse("urn143")
    end
  end

  test "verify valid URN" do
    assert Urn.verify("test:coll:12", "test:coll:12")
  end

  test "verify invalid URN" do
    message = "Validation failed: test:coll:12 does not match test:coll:13"
    assert_raise RuntimeError, message, fn ->
      Urn.verify("test:coll:12", "test:coll:13")
    end
  end

  test "verify valid URN namespace" do
    assert Urn.verify_namespace("test:coll:12", "test")
  end

  test "verify invalid URN namespace" do
    message = "Validation failed: test does not match test2"
    assert_raise RuntimeError, message, fn ->
      Urn.verify_namespace("test:coll:12", "test2")
    end
  end

  test "verify valid URN collection" do
    assert Urn.verify_collection("test:coll:12", "coll")
  end

  test "verify invalid URN collection" do
    message = "Validation failed: coll does not match coll2"
    assert_raise RuntimeError, message, fn ->
      Urn.verify_collection("test:coll:12", "coll2")
    end
  end
end
