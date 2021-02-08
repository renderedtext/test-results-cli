defmodule ResultParser.XML.RootSuite do
  @moduledoc """
  Handles parsing `<testcases>` or `<testsuite>` root elements JUnit XML export.
  """

  alias __MODULE__
  alias ResultParser.XML

  @type t() :: %RootSuite{
          name: String.t() | nil,
          time: String.t() | nil,
          tests: String.t() | nil,
          failures: String.t() | nil,
          testsuites: [XML.TestSuite.t()]
        }

  defstruct [
    :name,
    :time,
    :tests,
    :failures,
    :testsuites
  ]

  @spec parse(any()) :: t()
  def parse(xml_node) do
    xml_node
    |> XML.Node.node_name()
    |> case do
      :testsuites ->
        %RootSuite{
          name: XML.Node.attr(xml_node, "name"),
          time: XML.Node.attr(xml_node, "time"),
          tests: XML.Node.attr(xml_node, "tests"),
          failures: XML.Node.attr(xml_node, "failures"),
          testsuites: XML.Node.all(xml_node, ".//testsuite") |> Enum.map(&XML.TestSuite.parse/1)
        }

      :testsuite ->
        %RootSuite{
          name: XML.Node.attr(xml_node, "name"),
          time: XML.Node.attr(xml_node, "time"),
          tests: XML.Node.attr(xml_node, "tests"),
          failures: XML.Node.attr(xml_node, "failures"),
          testsuites: [xml_node] |> Enum.map(&XML.TestSuite.parse/1)
        }

      _ ->
        %RootSuite{
          name: "Not Found",
          time: "0",
          tests: "0",
          failures: "0",
          testsuites: []
        }
    end
  end
end
