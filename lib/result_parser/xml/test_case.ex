defmodule ResultParser.XML.TestCase do
  @moduledoc """
  Handles parsing `<testcase>` element from JUnit XML export.
  """

  alias __MODULE__
  alias ResultParser.XML

  @type t() :: %TestCase{
          name: String.t() | nil,
          time: String.t() | nil,
          file: String.t() | nil,
          classname: String.t() | nil,
          is_skipped: boolean(),
          is_failed: boolean(),
          failure_message: String.t() | nil,
          failure_type: String.t() | nil,
          failure_text: String.t() | nil
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

  @spec parse(any()) :: t()
  def parse(xml_node) do
    failure_node = XML.Node.first(xml_node, "./failure")

    %TestCase{
      name: XML.Node.attr(xml_node, "name"),
      time: XML.Node.attr(xml_node, "time"),
      file: XML.Node.attr(xml_node, "file"),
      classname: XML.Node.attr(xml_node, "classname"),
      is_skipped: not is_nil(XML.Node.first(xml_node, "./skipped")),
      is_failed: not is_nil(failure_node),
      failure_message: XML.Node.attr(failure_node, "message"),
      failure_type: XML.Node.attr(failure_node, "type"),
      failure_text: XML.Node.text(failure_node)
    }
  end
end
