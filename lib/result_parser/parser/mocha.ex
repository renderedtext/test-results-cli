defmodule ResultParser.Parser.Mocha do
  @behaviour ResultParser.Parser
  alias ResultParser.{
    XML,
    JSON
  }

  @impl ResultParser.Parser
  def parse(results) do
    process_root_suite(results)
  end

  @impl ResultParser.Parser
  def applicable?(%XML.RootSuite{
        name: root_suite_name
      }) do
    String.contains?(root_suite_name, ["mocha", "Mocha"])
  end

  def applicable?(_) do
    false
  end

  @impl ResultParser.Parser
  def name() do
    "mocha"
  end

  defp process_root_suite(%XML.RootSuite{} = root_suite) do
    test_suites = Enum.map(root_suite.test_suites, &process_test_suite/1)

    JSON.RootSuite.build(%{
      id: "",
      name: root_suite.name,
      time: root_suite.time,
      test_suites: test_suites
    })
  end

  defp process_test_suite(%XML.TestSuite{} = test_suite) do
    test_results = Enum.map(test_suite.test_cases, &process_test_result/1)

    JSON.TestSuite.build(%{
      id: "",
      name: test_suite.name,
      total_tests: test_suite.tests,
      skipped_tests: test_suite.skipped,
      passed_tests: test_suite.tests,
      failed_tests: test_suite.failures,
      errored_tests: test_suite.errors,
      time: test_suite.time,
      test_results: test_results
    })
  end

  defp process_test_result(%XML.TestCase{} = test_result) do
    JSON.TestResult.build(%{
      id: "",
      name: test_result.name,
      time: test_result.time,
      file: test_result.file,
      classname: test_result.classname,
      is_skipped: test_result.is_skipped,
      is_failed: test_result.is_failed,
      failure_message: test_result.failure_message,
      failure_type: test_result.failure_type,
      failure_text: test_result.failure_text
    })
  end
end
