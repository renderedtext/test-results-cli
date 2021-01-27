defmodule ResultParser do
  @moduledoc """
    Based on schema: https://www.ibm.com/support/knowledgecenter/en/SSQ2R2_14.1.0/com.ibm.rsar.analysis.codereview.cobol.doc/topics/cac_useresults_junit.html
  """

  import SweetXml

  def to_stdout(in_path) do
    with true <- File.exists?(in_path) do
      in_path
      |> File.stream!()
      |> process_stream()
      |> to_json()
      |> IO.write()
    else
      _ -> IO.write(:stderr, "#{Path.expand(in_path)} doesn't exist\n")
    end
  end

  def to_file(in_path, out_path) do
    with true <- File.exists?(in_path) do
      in_path
      |> File.stream!()
      |> process_stream()
      |> to_json()
      |> save_file(out_path)
      |> case do
        :ok -> IO.write("Save to #{Path.expand(out_path)} successful\n")
        _ -> IO.write(:stderr, "Save to #{Path.expand(out_path)} failed\n")
      end
    else
      _ -> IO.write(:stderr, "#{Path.expand(in_path)} doesn't exist\n")
    end
  end

  def process_stream(stream) do
    stream
    |> stream_tags([:testsuite])
    |> Stream.map(fn
      {_, doc} ->
        doc
        |> xmap(
          # Schema defined attributes for testsuite
          id: ~x"//testsuite/@id"so,
          name: ~x"//testsuite/@name"s,
          tests: ~x"//testsuite/@tests"i,
          failures: ~x"//testsuite/@failures"i,
          time: ~x"//testsuite/@time"s,
          # Vendor-specific attributes
          skipped: ~x"//testsuite/@skipped"io,
          errors: ~x"//testsuite/@errors"io,
          timestamp: ~x"//testsuite/@timestamp"so,
          testcases: [
            ~x"./testcase"l,
            # Schema defined attributes for testcase
            id: ~x"./@id"so,
            name: ~x"./@name"s,
            time: ~x"./@time"s,

            # Vendor-specific attributes
            file: ~x"./@file"s,
            classname: ~x"./@classname"s,
            failure: [
              ~x"./failure"o,
              # Schema defined attributes for failure
              message: ~x"./@message"s,
              type: ~x"./@type"s,
              text: ~x"./text()"s
            ]
          ]
        )
    end)
  end

  defp to_json(results) do
    results
    |> Poison.encode!()
  end

  defp save_file(json, file) do
    file
    |> File.write(json, [:binary])
  end
end
