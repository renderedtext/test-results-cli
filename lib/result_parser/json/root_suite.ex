defmodule ResultParser.JSON.RootSuite do
  alias __MODULE__
  alias ResultParser.JSON.TestSuite

  defstruct [
    :id,
    :name,
    :time,
    :tests_count,
    :success_count,
    :failures_count,
    :skipped_count,
    :errors_count,
    :test_suites
  ]

  @type t :: %RootSuite{
          id: String.t(),
          name: String.t(),
          time: String.t(),
          tests_count: non_neg_integer(),
          failures_count: non_neg_integer(),
          success_count: non_neg_integer(),
          skipped_count: non_neg_integer(),
          errors_count: non_neg_integer(),
          test_suites: [TestSuite.t()]
        }
  @type t_build_params :: %{
          id: String.t(),
          name: String.t(),
          time: String.t(),
          tests_count: non_neg_integer(),
          failures_count: non_neg_integer(),
          skipped_count: non_neg_integer(),
          errors_count: non_neg_integer(),
          test_suites: [TestSuite.t()]
        }

  @spec build(t_build_params()) :: t()
  def build(%{
        id: id,
        name: name,
        time: time,
        tests_count: tests_count,
        failures_count: failures_count,
        skipped_count: skipped_count,
        errors_count: errors_count,
        test_suites: test_suites
      }) do
    %RootSuite{
      id: id,
      name: name,
      time: time,
      tests_count: tests_count,
      failures_count: failures_count,
      skipped_count: skipped_count,
      success_count: tests_count - errors_count,
      errors_count: errors_count,
      test_suites: test_suites
    }
  end
end
