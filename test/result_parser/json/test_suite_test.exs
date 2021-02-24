defmodule ResultParser.JSON.TestSuiteTest do
  use ExUnit.Case

  alias ResultParser.JSON.{
    TestSuite
  }

  doctest TestSuite

  describe "#{TestSuite}#build/1" do
    test "builds #{TestSuite} struct correctly" do
      build_params = %{
        id: "1",
        name: "name",
        file: "some/file",
        total_tests: 10,
        skipped_tests: 5,
        passed_tests: 3,
        failed_tests: 2,
        errored_tests: 1,
        time: 2.05,
        test_results: []
      }

      assert %TestSuite{
               id: "1",
               name: "name",
               file: "some/file",
               total_tests: 10,
               skipped_tests: 5,
               passed_tests: 3,
               failed_tests: 2,
               errored_tests: 1,
               time: 2.05,
               test_results: []
             } == TestSuite.build(build_params)
    end
  end
end
