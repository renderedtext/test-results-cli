defmodule ResultParser do
  @moduledoc """
    Based on schema: https://www.ibm.com/support/knowledgecenter/en/SSQ2R2_14.1.0/com.ibm.rsar.analysis.codereview.cobol.doc/topics/cac_useresults_junit.html
  """

  @available_parsers Application.get_env(:result_parser, :available_parsers)

  def to_stdout(in_path) do
    with true <- File.exists?(in_path) do
      in_path
      |> ResultParser.XML.parse()
      |> parse
      |> ResultParser.Utils.to_json!()
      |> IO.write()
    else
      _ -> IO.write(:stderr, "#{Path.expand(in_path)} doesn't exist\n")
    end
  end

  def to_file(in_path, out_path) do
    with true <- File.exists?(in_path) do
      in_path
      |> ResultParser.XML.parse()
      |> parse
      |> ResultParser.Utils.to_json!()
      |> save_file(out_path)
      |> case do
        :ok -> IO.write("Save to #{Path.expand(out_path)} successful\n")
        _ -> IO.write(:stderr, "Save to #{Path.expand(out_path)} failed\n")
      end
    else
      _ -> IO.write(:stderr, "#{Path.expand(in_path)} doesn't exist\n")
    end
  end

  def parse(xml) do
    @available_parsers
    |> Enum.find(& &1.applicable?(xml))
    |> case do
      nil ->
        nil

      parser ->
        parser.parse(xml)
    end
  end

  defp save_file(json, file) do
    file
    |> File.write(json, [:binary])
  end
end
