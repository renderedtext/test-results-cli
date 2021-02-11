use Mix.Config

# Important: first matched parser will be used by default
config :result_parser,
  available_parsers: [
    ResultParser.Parser.ExUnit,
    ResultParser.Parser.Mocha,
    ResultParser.Parser.RSpec,
    ResultParser.Parser.Generic
  ]

config :junit_formatter,
  report_file: "junit.xml",
  report_dir: "./",
  print_report_file: true,
  prepend_project_name?: false,
  include_filename?: true
