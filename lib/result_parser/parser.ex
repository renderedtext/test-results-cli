defmodule ResultParser.Parser do
  alias ResultParser.{
    XML,
    Result
  }

  @callback parse(XML.t()) :: Result.t()
  @callback applicable?(XML.t()) :: true | false
end
