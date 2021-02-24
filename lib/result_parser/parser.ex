defmodule ResultParser.Parser do
  alias ResultParser.{
    XML,
    JSON
  }

  @callback parse(root_suite :: XML.RootSuite.t()) :: JSON.RootSuite.t()
  @callback applicable?(root_suite :: XML.RootSuite.t()) :: boolean()
  @callback name() :: String.t()
end
