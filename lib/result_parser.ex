defmodule ResultParser do
  @moduledoc """
    Based on schema: https://www.ibm.com/support/knowledgecenter/en/SSQ2R2_14.1.0/com.ibm.rsar.analysis.codereview.cobol.doc/topics/cac_useresults_junit.html
  """

  @available_parsers Application.get_env(:result_parser, :available_parsers)

  def to_stdout(in_path, parse_opts \\ []) do
    with true <- File.exists?(in_path) do
      in_path
      |> ResultParser.XML.parse()
      |> parse(parse_opts)
      |> ResultParser.Utils.to_json!()
      |> IO.write()
    else
      _ -> IO.write(:stderr, "#{Path.expand(in_path)} doesn't exist\n")
    end
  end

  def to_file(in_path, out_path, parse_opts \\ []) do
    with true <- File.exists?(in_path) do
      in_path
      |> ResultParser.XML.parse()
      |> parse(parse_opts)
      |> ResultParser.Utils.to_json!()
      |> save_file(out_path)
      |> case do
        :ok ->
          IO.write("Save to #{Path.expand(out_path)} successful\n")
          :ok

        _ ->
          IO.write(:stderr, "Save to #{Path.expand(out_path)} failed\n")
          :error
      end
    else
      _ ->
        IO.write(:stderr, "#{Path.expand(in_path)} doesn't exist\n")
        :error
    end
  end

  def publish_artifacts(input_file, parse_opts \\ []) do
    File.mkdir_p("/tmp/test-results")

    file_name = Path.basename(input_file)
    File.cp(input_file, "/tmp/test-results/#{file_name}")

    to_file(input_file, "/tmp/test-results/junit.json", parse_opts)
    |> case do
      :ok ->
        System.cmd("artifact", ["push", "job", "/tmp/test-results", "-d test-results"],
          into: IO.stream(:stdio, :line)
        )

      _error ->
        IO.write(:stderr, "publishing artifacts error\n")
    end
  end

  defp parse(xml, parse_opts) do
    selected_parser =
      parse_opts
      |> Keyword.get(:type)
      |> case do
        nil ->
          nil

        type ->
          @available_parsers
          |> Enum.find(&(&1.name() == type))
      end
      |> case do
        nil ->
          @available_parsers
          |> Enum.find(& &1.applicable?(xml))

        parser ->
          parser
      end

    IO.write("Parsing using #{selected_parser.name()} parser\n")

    output = selected_parser.parse(xml)

    Keyword.get(parse_opts, :name)
    |> case do
      nil ->
        output

      name ->
        %{output | name: name}
    end
  end

  defp save_file(json, file) do
    file
    |> File.write(json, [:binary])
  end
end
