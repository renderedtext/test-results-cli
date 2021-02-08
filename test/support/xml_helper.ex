defmodule XMLHelper do
  def parse_xml(xml) do
    xml
    |> to_charlist
    |> :xmerl_scan.string()
    |> case do
      {xml, _rest} -> xml
    end
  end
end
