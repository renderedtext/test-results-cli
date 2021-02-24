defmodule ResultParser.JSON.RootSuiteTest do
  use ExUnit.Case

  alias ResultParser.JSON.{
    RootSuite
  }

  doctest RootSuite

  describe "#{RootSuite}#build/1" do
    test "builds #{RootSuite} struct correctly" do
      build_params = %{
        id: "1",
        name: "name",
        time: 12.123,
        tests_count: 100,
        failures_count: 20,
        skipped_count: 30,
        errors_count: 40,
        test_suites: []
      }

      assert %RootSuite{
               id: "1",
               name: "name",
               time: 12.123,
               tests_count: 100,
               failures_count: 20,
               skipped_count: 30,
               errors_count: 40,
               success_count: 40,
               test_suites: []
             } == RootSuite.build(build_params)
    end
  end
end
