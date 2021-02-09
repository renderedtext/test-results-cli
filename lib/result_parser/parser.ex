defmodule ResultParser.Parser do
  alias ResultParser.{
    XML,
    JSON
  }

  @callback parse(XML.RootSuite.t()) :: JSON.RootSuite.t()
  @callback applicable?(XML.RootSuite.t()) :: true | false
  @callback name() :: String.t()
end
