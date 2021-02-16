defmodule ResultParser.XML.TestCase do
  @moduledoc """
  Handles parsing `<testcase>` element from JUnit XML export.
  """

  alias __MODULE__

  alias ResultParser.Utils

  alias ResultParser.XML.{
    Node
  }

  defstruct [
    :name,
    :time,
    :file,
    :classname,
    :is_skipped,
    :is_failed,
    :failure_message,
    :failure_type,
    :failure_text
  ]

  @type t() :: %TestCase{
          name: String.t() | nil,
          time: float(),
          file: String.t() | nil,
          classname: String.t() | nil,
          is_skipped: boolean(),
          is_failed: boolean(),
          failure_message: String.t() | nil,
          failure_type: String.t() | nil,
          failure_text: String.t() | nil
        }

  @spec parse(any()) :: t()
  def parse(xml_node) do
    failure_node = Node.first(xml_node, "./failure")

    %TestCase{
      name: Node.attr(xml_node, "name"),
      time: Node.attr(xml_node, "time") |> Utils.cast_to_float(),
      file: Node.attr(xml_node, "file"),
      classname: Node.attr(xml_node, "classname"),
      is_skipped: not is_nil(Node.first(xml_node, "./skipped")),
      is_failed: not is_nil(failure_node),
      failure_message: Node.attr(failure_node, "message"),
      failure_type: Node.attr(failure_node, "type"),
      failure_text: Node.text(failure_node)
    }
  end
end
