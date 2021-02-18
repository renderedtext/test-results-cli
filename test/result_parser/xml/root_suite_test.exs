defmodule ResultParser.XML.RootSuiteTest do
  use ExUnit.Case

  alias ResultParser.XML.{
    RootSuite,
    TestSuite,
    TestCase
  }

  doctest RootSuite

  describe "#{RootSuite}#parse/1" do
    test "provides valid output for root <testsuites> element" do
      xml = """
        <testsuites name="testsuites#1" time="1" tests="1" failures="1">
          <testsuite name="testsuite#1"></testsuite>
          <testsuite name="testsuite#2"></testsuite>
        </testsuites>
      """

      parsed =
        xml
        |> XMLHelper.parse_xml()
        |> RootSuite.parse()

      assert %RootSuite{
               name: "testsuites#1",
               time: 1.0,
               test_suites: [
                 %TestSuite{name: "testsuite#1"},
                 %TestSuite{name: "testsuite#2"}
               ]
             } = parsed
    end

    test "provides valid output for root <testsuite> element" do
      xml = """
        <testsuite name="testsuite#1" time="1" tests="1" failures="1">
          <testcase name="testcase#1"></testcase>
          <testcase name="testcase#2"></testcase>
        </testsuite>
      """

      parsed =
        xml
        |> XMLHelper.parse_xml()
        |> RootSuite.parse()

      assert %RootSuite{
               name: "testsuite#1",
               time: 1.0,
               test_suites: [
                 %TestSuite{
                   name: "testsuite#1",
                   test_cases: [%TestCase{name: "testcase#1"}, %TestCase{name: "testcase#2"}]
                 }
               ]
             } = parsed
    end
  end
end
