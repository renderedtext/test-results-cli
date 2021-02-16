defmodule ResultParser.XML.RootSuite do
  @moduledoc """
  Handles parsing `<testcases>` or `<testsuite>` root elements JUnit XML export.
  """

  alias __MODULE__

  alias ResultParser.Utils

  alias ResultParser.XML.{
    TestSuite,
    Node
  }

  defstruct [
    :name,
    :time,
    :test_suites
  ]

  @type t() :: %RootSuite{
          name: String.t() | nil,
          time: float(),
          test_suites: [TestSuite.t()]
        }

  @spec parse(any()) :: t()
  def parse(xml_node) do
    xml_node
    |> Node.node_name()
    |> case do
      :testsuites ->
        %RootSuite{
          name: Node.attr(xml_node, "name"),
          time: Node.attr(xml_node, "time") |> Utils.cast_to_float(),
          test_suites: Node.all(xml_node, ".//testsuite") |> Enum.map(&TestSuite.parse/1)
        }

      :testsuite ->
        %RootSuite{
          name: Node.attr(xml_node, "name"),
          time: Node.attr(xml_node, "time") |> Utils.cast_to_float(),
          test_suites: [xml_node] |> Enum.map(&TestSuite.parse/1)
        }

      _ ->
        %RootSuite{
          name: "Not Found",
          time: "0" |> Utils.cast_to_float(),
          test_suites: []
        }
    end
  end
end
