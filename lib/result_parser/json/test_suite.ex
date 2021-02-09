defmodule ResultParser.JSON.TestSuite do
  alias __MODULE__
  alias ResultParser.JSON.TestResult

  defstruct [
    :id,
    :name,
    :total_tests,
    :skipped_tests,
    :passed_tests,
    :failed_tests,
    :errored_tests,
    :time,
    :test_results
  ]

  @type t :: %TestSuite{
          id: String.t(),
          name: String.t(),
          total_tests: String.t(),
          skipped_tests: String.t(),
          passed_tests: String.t(),
          failed_tests: String.t(),
          errored_tests: String.t(),
          time: String.t(),
          test_results: [TestResult.t()]
        }
  @type t_build_params :: %{
          id: String.t(),
          name: String.t(),
          total_tests: String.t(),
          skipped_tests: String.t(),
          passed_tests: String.t(),
          failed_tests: String.t(),
          errored_tests: String.t(),
          time: String.t(),
          test_results: [TestResult.t()]
        }

  @spec build(t_build_params()) :: t()
  def build(%{
        id: id,
        name: name,
        total_tests: total_tests,
        skipped_tests: skipped_tests,
        passed_tests: passed_tests,
        failed_tests: failed_tests,
        errored_tests: errored_tests,
        time: time,
        test_results: test_results
      }) do
    %TestSuite{
      id: id,
      name: name,
      total_tests: total_tests,
      skipped_tests: skipped_tests,
      passed_tests: passed_tests,
      failed_tests: failed_tests,
      errored_tests: errored_tests,
      time: time,
      test_results: test_results
    }
  end
end