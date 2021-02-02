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

  def process_dir(out_dir \\ ".") do
    dir =
      :code.priv_dir(:result_parser)
      |> Path.join("results")

    dir
    |> Path.join("**/*.xml")
    |> Path.wildcard()
    |> Enum.map(fn file ->
      out_file =
        Path.relative_to(file, dir)
        |> Path.rootname()

      {
        file,
        out_dir |> Path.join(out_file <> ".json")
      }
    end)
    |> Enum.each(fn {in_file, out_file} ->
      out_dir = Path.dirname(out_file)

      out_dir
      |> File.exists?()
      |> case do
        false ->
          File.mkdir_p(out_dir)

        _ ->
          nil
      end

      ResultParser.to_file(in_file, out_file)
    end)
  end
end
