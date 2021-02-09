defmodule ResultParser.XML.RootSuite do
  @moduledoc """
  Handles parsing `<testcases>` or `<testsuite>` root elements JUnit XML export.
  """

  alias __MODULE__
  alias ResultParser.XML

  @type t() :: %RootSuite{
          name: String.t() | nil,
          time: String.t() | nil,
          test_suites: [XML.TestSuite.t()]
        }

  defstruct [
    :name,
    :time,
    :test_suites
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
          test_suites: XML.Node.all(xml_node, ".//testsuite") |> Enum.map(&XML.TestSuite.parse/1)
        }

      :testsuite ->
        %RootSuite{
          name: XML.Node.attr(xml_node, "name"),
          time: XML.Node.attr(xml_node, "time"),
          test_suites: [xml_node] |> Enum.map(&XML.TestSuite.parse/1)
        }

      _ ->
        %RootSuite{
          name: "Not Found",
          time: "0",
          test_suites: []
        }
    end
  end
end
