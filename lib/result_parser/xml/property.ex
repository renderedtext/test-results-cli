defmodule ResultParser.XML.Property do
  @moduledoc """
  Handles parsing `<property>` element from JUnit XML export.
  """

  alias __MODULE__

  alias ResultParser.XML.{
    Node
  }

  defstruct [
    :name,
    :value
  ]

  @type t() :: %Property{
          name: String.t() | nil,
          value: String.t() | nil
        }

  @spec parse(any()) :: t()
  def parse(xml_node) do
    %Property{
      name: Node.attr(xml_node, "name"),
      value: Node.attr(xml_node, "value")
    }
  end
end
