defmodule ResultParserTest do
  use ExUnit.Case
  doctest ResultParser

  def fixture_path() do
    Path.expand("fixtures", __DIR__)
  end
end
