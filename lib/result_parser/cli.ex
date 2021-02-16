defmodule ResultParser.CLI do
  @available_parsers Application.get_env(:result_parser, :available_parsers)
  @moduledoc """
  Usage:
    result_parser [command]

  Available commands:
    publish      creates test results and publishes artifacts to semaphore
      INPUT_FILE [--type string] [--name string]
    generate     generates test results
      INPUT_FILE OUTPUT_FILE [--type string] [--name string]
    print        prints resulting json file from xml
      INPUT_FILE [--type string] [--name string]

  Options:
    --name string Name of test suite, by default - depends on test runner
    --type string Type of parser to be used: (#{
    @available_parsers |> Enum.map(& &1.name()) |> Enum.join("|")
  })
  """

  def main(args) do
    {switch_opts, argv, _} = OptionParser.parse(args, strict: [type: :string, name: :string])

    argv
    |> case do
      ["publish" | [input_file | _]] ->
        ResultParser.publish_artifacts(input_file, switch_opts)

      ["generate" | [input_file | [output_file | _]]] ->
        ResultParser.to_file(input_file, output_file, switch_opts)

      ["print" | [input_file | _]] ->
        ResultParser.to_stdout(input_file, switch_opts)

      _ ->
        IO.puts(@moduledoc)
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
