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
      |> process_output()
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
      |> process_output()
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
          file: ~x"//testsuite/@file"so,
          properties: [
            ~x"./properties/property"lo,
            name: ~x"./@name"s,
            value: ~x"./@value"s
          ],
          testcases: [
            ~x"./testcase"l,
            # Schema defined attributes for testcase
            id: ~x"./@id"so,
            name: ~x"./@name"s,
            time: ~x"./@time"s,

            # Vendor-specific attributes
            file: ~x"./@file"s,
            classname: ~x"./@classname"s,
            skipped: ~x"./skipped"o,
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

  def process_output(results) do
    results
    |> Enum.map(fn %{
                     testcases: testcases,
                     name: testsuite_name,
                     file: testsuite_file,
                     properties: properties
                   } = testsuite ->
      files =
        testcases
        |> Enum.map(fn
          %{file: file} = testcase when file == "" or is_nil(file) ->
            testsuite_file
            |> case do
              testsuite_file when testsuite_file == "" or is_nil(testsuite_file) ->
                %{testcase | file: testsuite_name}

              testsuite_file ->
                %{testcase | file: testsuite_file}
            end

          testcase ->
            testcase
        end)
        |> Enum.group_by(fn %{file: file} ->
          file
        end)
        |> Enum.map(fn {file, file_cases} ->
          {failed_cases, success_cases} =
            file_cases
            |> Enum.split_with(fn
              %{failure: nil} -> false
              %{failure: _} -> true
            end)

          failed_cases =
            failed_cases
            |> Enum.map(&format_failure(&1, testsuite))

          success_cases =
            success_cases
            |> Enum.map(&format_success(&1, testsuite))

          %{
            file: file,
            failed_cases: failed_cases,
            success_cases: success_cases,
            properties: properties
          }
        end)

      %{
        name: testsuite.name,
        test_count: testsuite.tests,
        failure_count: testsuite.failures,
        success_count: testsuite.tests - testsuite.failures,
        timestamp: format_timestamp(testsuite.timestamp),
        duration: format_duration(testsuite.time),
        files: files
      }
    end)
  end

  defp format_failure(
         %{
           classname: classname,
           name: name,
           failure: %{
             message: message_short,
             text: message_long,
             type: failure_type
           },
           time: time,
           skipped: skipped
         },
         testsuite
       ) do
    %{
      id: to_id("#{testsuite.name}.#{classname}.#{name}"),
      class: classname,
      name: name,
      duration: format_duration(time),
      message_short: message_short,
      message_long: message_long,
      failure_type: failure_type,
      skipped: not is_nil(skipped)
    }
  end

  defp format_success(
         %{
           classname: classname,
           name: name,
           time: time,
           skipped: skipped
         },
         testsuite
       ) do
    %{
      id: to_id("#{testsuite.name}.#{classname}.#{name}"),
      class: classname,
      name: name,
      duration: format_duration(time),
      message_short: nil,
      message_long: nil,
      failure_type: nil,
      skipped: not is_nil(skipped)
    }
  end

  defp to_json(results) do
    results
    |> Poison.encode!()
  end

  defp save_file(json, file) do
    file
    |> File.write(json, [:binary])
  end

  defp to_id(string) do
    :crypto.hash(:md5, string)
    |> Base.encode16()
    |> String.downcase()
  end

  defp format_duration(duration) do
    duration
    |> Float.parse()
    |> case do
      {duration, _garbage} -> duration
    end
  end

  defp format_timestamp(timestamp) do
    Timex.parse(timestamp, "{ISO:Extended}")
    |> case do
      {:ok, timestamp} -> timestamp
      _ -> nil
    end
  end
end
