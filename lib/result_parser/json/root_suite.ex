defmodule ResultParser.JSON.RootSuite do
  alias __MODULE__
  alias ResultParser.JSON.TestSuite

  defstruct [
    :id,
    :name,
    :time,
    :test_suites
  ]

  @type t :: %RootSuite{
          id: String.t(),
          name: String.t(),
          time: String.t(),
          test_suites: [TestSuite.t()]
        }
  @type t_build_params :: %{
          id: String.t(),
          name: String.t(),
          time: String.t(),
          test_suites: [TestSuite.t()]
        }

  @spec build(t_build_params()) :: t()
  def build(%{
        id: id,
        name: name,
        time: time,
        test_suites: test_suites
      }) do
    %RootSuite{
      id: id,
      name: name,
      time: time,
      test_suites: test_suites
    }
  end
end
