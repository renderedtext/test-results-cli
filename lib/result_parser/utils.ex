defmodule ResultParser.Utils do
  def to_json!(map) do
    Poison.encode!(map)
  end

  def ensure_name(name, default \\ "Generic") do
    cond do
      not is_nil(name) and is_bitstring(name) ->
        name

      true ->
        default
    end
  end

  def to_id(string) do
    :crypto.hash(:md5, string)
    |> Base.encode16()
    |> String.downcase()
  end

  def format_duration(float) do
    float
    |> Float.parse()
    |> case do
      {duration, _garbage} -> duration
    end
  end

  def format_timestamp(timestamp) do
    Timex.parse(timestamp, "{ISO:Extended}")
    |> case do
      {:ok, timestamp} -> timestamp
      _ -> nil
    end
  end

  def cast_to_integer(nil), do: 0

  def cast_to_integer(binary) do
    binary
    |> Integer.parse()
    |> case do
      {integer, _remainder} -> integer
      _ -> 0
    end
  end

  def cast_to_float(nil), do: 0

  def cast_to_float(binary) do
    binary
    |> Float.parse()
    |> case do
      {float, _remainder} -> float
      _ -> 0
    end
  end

  @spec calculate_root_suite_stats(ResultParser.XML.t()) ::
          {tests_count :: non_neg_integer(), failures_count :: non_neg_integer(),
           skipped_count :: non_neg_integer(), errors_count :: non_neg_integer()}
  def calculate_root_suite_stats(%ResultParser.XML.RootSuite{} = root_suite) do
    root_suite.test_suites
    |> Enum.reduce({0, 0, 0, 0}, fn %ResultParser.XML.TestSuite{
                                      tests: tests,
                                      failures: failures,
                                      skipped: skipped,
                                      errors: errors
                                    },
                                    {test_count, failures_count, skipped_count, errors_count} ->
      {test_count + tests, failures_count + failures, skipped_count + skipped,
       errors_count + errors}
    end)
  end

  def calculate_root_suite_time(%ResultParser.XML.RootSuite{} = root_suite) do
    root_suite.time
    |> case do
      nil ->
        root_suite.test_suites
        |> Enum.map(& &1.time)
        |> Enum.sum()

      time ->
        time
    end
  end
end
