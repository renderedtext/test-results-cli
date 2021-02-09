defmodule ResultParser.Utils do
  def to_json!(map) do
    Poison.encode!(map)
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
end
