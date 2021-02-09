use Mix.Config

# Important: first matched parser will be used by default
config :result_parser,
  available_parsers: [
    ResultParser.Parser.ExUnit,
    ResultParser.Parser.Mocha,
    ResultParser.Parser.RSpec,
    ResultParser.Parser.Generic
  ]
