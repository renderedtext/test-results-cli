defmodule ResultParser.Parser.Common do
  @behaviour ResultParser.Parser

  @impl ResultParser.Parser
  def parse(results) do
    results
  end

  @impl ResultParser.Parser
  def applicable?(_) do
    true
  end
end
