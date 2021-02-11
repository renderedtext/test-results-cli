defmodule ResultParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :result_parser,
      version: "0.1.0",
      elixir: "~> 1.8.2",
      deps: deps(),
      escript: escript(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def escript() do
    [main_module: ResultParser.CLI]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sweet_xml, "~> 0.6.6"},
      {:poison, "~> 3.1"},
      {:timex, "~> 3.6.3"},
      {:tzdata, "~> 0.1.8", override: true},
      {:junit_formatter, "~> 3.1", only: [:test]},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
