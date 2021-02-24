defmodule ResultParser.JSON.TestResultTest do
  use ExUnit.Case

  alias ResultParser.JSON.{
    TestResult
  }

  doctest TestResult

  describe "#{TestResult}#build/1" do
    test "builds #{TestResult} struct correctly" do
      build_params = %{
        id: "1",
        name: "name",
        time: 1.23,
        file: "some/path",
        classname: "SomeClassName",
        is_skipped: false,
        is_failed: true,
        failure_message: "failure message",
        failure_type: "failure type",
        failure_text: "failure text"
      }

      assert %TestResult{
               id: "1",
               name: "name",
               time: 1.23,
               file: "some/path",
               classname: "SomeClassName",
               is_skipped: false,
               is_failed: true,
               failure_message: "failure message",
               failure_type: "failure type",
               failure_text: "failure text"
             } == TestResult.build(build_params)
    end
  end
end
