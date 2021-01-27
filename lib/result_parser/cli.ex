defmodule ResultParser.CLI do
  def main(args) do
    {_switch_opts, argv, _} = OptionParser.parse(args, strict: [])

    argv
    |> case do
      [input_file | [output_file | _]] ->
        ResultParser.to_file(input_file, output_file)

      [input_file | _] ->
        ResultParser.to_stdout(input_file)

      _ ->
        IO.write("""

        Usage: ./result_parser INPUT_PATH [OUTPUT_PATH]

        Parsers XML file locatet at INPUT_PATH and outputs resulting JSON to OUTPUT_PATH or stdio if no output file is given
        """)
    end
  end
end
