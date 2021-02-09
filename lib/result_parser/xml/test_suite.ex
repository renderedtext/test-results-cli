defmodule ResultParser.XML.TestSuite do
  @moduledoc """
  Handles parsing `<testsuite>` element from JUnit XML export.
  """

  alias __MODULE__
  alias ResultParser.XML

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
          properties: [XML.Property.t()],
          test_cases: [XML.TestCase.t()]
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

  @spec parse(any()) :: t()
  def parse(xml_node) do
    test_cases =
      XML.Node.all(xml_node, ".//testcase")
      |> Enum.map(&XML.TestCase.parse/1)

    properties =
      XML.Node.all(xml_node, ".//properties/property")
      |> Enum.map(&XML.Property.parse/1)

    %TestSuite{
      id: XML.Node.attr(xml_node, "id"),
      name: XML.Node.attr(xml_node, "name"),
      tests: XML.Node.attr(xml_node, "tests"),
      failures: XML.Node.attr(xml_node, "failures"),
      time: XML.Node.attr(xml_node, "time"),
      skipped: XML.Node.attr(xml_node, "skipped"),
      errors: XML.Node.attr(xml_node, "errors"),
      timestamp: XML.Node.attr(xml_node, "timestamp"),
      file: XML.Node.attr(xml_node, "file"),
      properties: properties,
      test_cases: test_cases
    }
  end
end
