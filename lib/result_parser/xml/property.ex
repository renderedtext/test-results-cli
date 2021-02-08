defmodule ResultParser.XML.Property do
  @moduledoc """
  Handles parsing `<property>` element from JUnit XML export.
  """

  alias __MODULE__
  alias ResultParser.XML

  @type t() :: %Property{
          name: String.t() | nil,
          value: String.t() | nil
        }

  defstruct [
    :name,
    :value
  ]

  @spec parse(any()) :: t()
  def parse(xml_node) do
    %Property{
      name: XML.Node.attr(xml_node, "name"),
      value: XML.Node.attr(xml_node, "value")
    }
  end
end
