defmodule ResultParser.XML.TestSuite do
  @moduledoc """
  Handles parsing `<testsuite>` element from JUnit XML export.
  """

  alias __MODULE__

  alias ResultParser.Utils

  alias ResultParser.XML.{
    TestCase,
    Property,
    Node
  }

  defstruct [
    :id,
    :name,
    :tests,
    :failures,
    :time,
    :skipped,
    :errors,
    :timestamp,
    :file,
    :properties,
    :test_cases
  ]

  @type t() :: %TestSuite{
          id: String.t() | nil,
          name: String.t() | nil,
          time: float(),
          tests: non_neg_integer(),
          failures: non_neg_integer(),
          skipped: non_neg_integer(),
          errors: non_neg_integer(),
          timestamp: String.t() | nil,
          file: String.t() | nil,
          properties: [Property.t()],
          test_cases: [TestCase.t()]
        }

  @spec parse(any()) :: t()
  def parse(xml_node) do
    test_cases =
      Node.all(xml_node, ".//testcase")
      |> Enum.map(&TestCase.parse/1)

    properties =
      Node.all(xml_node, ".//properties/property")
      |> Enum.map(&Property.parse/1)

    %TestSuite{
      id: Node.attr(xml_node, "id"),
      name: Node.attr(xml_node, "name"),
      time: Node.attr(xml_node, "time") |> Utils.cast_to_float(),
      tests: Node.attr(xml_node, "tests") |> Utils.cast_to_integer(),
      failures: Node.attr(xml_node, "failures") |> Utils.cast_to_integer(),
      skipped: Node.attr(xml_node, "skipped") |> Utils.cast_to_integer(),
      errors: Node.attr(xml_node, "errors") |> Utils.cast_to_integer(),
      timestamp: Node.attr(xml_node, "timestamp"),
      file: Node.attr(xml_node, "file"),
      properties: properties,
      test_cases: test_cases
    }
  end
end
