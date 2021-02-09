defmodule ResultParser.XML.TestSuite do
  @moduledoc """
  Handles parsing `<testsuite>` element from JUnit XML export.
  """

  alias __MODULE__

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
          tests: String.t() | nil,
          failures: String.t() | nil,
          time: String.t() | nil,
          skipped: String.t() | nil,
          errors: String.t() | nil,
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
      tests: Node.attr(xml_node, "tests"),
      failures: Node.attr(xml_node, "failures"),
      time: Node.attr(xml_node, "time"),
      skipped: Node.attr(xml_node, "skipped"),
      errors: Node.attr(xml_node, "errors"),
      timestamp: Node.attr(xml_node, "timestamp"),
      file: Node.attr(xml_node, "file"),
      properties: properties,
      test_cases: test_cases
    }
  end
end
