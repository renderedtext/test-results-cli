defmodule ResultParser.XML do
  alias __MODULE__

  @spec parse(String.t()) :: XML.RootSuite.t()
  def parse(file) do
    {doc, _} =
      file
      |> :xmerl_scan.file()

    XML.RootSuite.parse(doc)
  end
end
