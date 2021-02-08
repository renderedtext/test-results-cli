defmodule ResultParser.XML.TestSuiteTest do
  use ExUnit.Case

  alias ResultParser.XML.{
    TestSuite,
    TestCase,
    Property
  }

  doctest TestSuite

  describe "#{TestSuite}#parse/1" do
    test "provides valid output for <testsuite> element" do
      xml = """
        <testsuite id="1" name="test" tests="3" failures="0" time="0.0015" skipped="0" errors="0" timestamp="" file="/path/to/file">
        </testsuite>
      """

      xml
      |> XMLHelper.parse_xml()
      |> ResultParser.XML.TestSuite.parse()
      |> case do
        parsed_testsuite ->
          assert %TestSuite{
                   id: "1",
                   name: "test",
                   tests: "3",
                   failures: "0",
                   time: "0.0015",
                   skipped: "0",
                   errors: "0",
                   timestamp: "",
                   file: "/path/to/file",
                   testcases: [],
                   properties: []
                 } = parsed_testsuite
      end
    end

    test "provides valid output for <testsuite> element with testcases" do
      xml = """
        <testsuite id="1" name="test" tests="3" failures="0" time="0.0015" skipped="0" errors="0" timestamp="" file="/path/to/file">
          <testcase name="test"></testcase>
        </testsuite>
      """

      xml
      |> XMLHelper.parse_xml()
      |> TestSuite.parse()
      |> case do
        parsed_testsuite ->
          assert %TestSuite{
                   id: "1",
                   name: "test",
                   tests: "3",
                   failures: "0",
                   time: "0.0015",
                   skipped: "0",
                   errors: "0",
                   timestamp: "",
                   file: "/path/to/file",
                   testcases: [%TestCase{name: "test"}],
                   properties: []
                 } = parsed_testsuite
      end
    end

    test "provides valid output for <testsuite> element with properties" do
      xml = """
        <testsuite id="1" name="test" tests="3" failures="0" time="0.0015" skipped="0" errors="0" timestamp="" file="/path/to/file">
          <properties>
            <property name="foo" value="bar"></property>
          </properties>
        </testsuite>
      """

      xml
      |> XMLHelper.parse_xml()
      |> TestSuite.parse()
      |> case do
        parsed_testsuite ->
          assert %TestSuite{
                   id: "1",
                   name: "test",
                   tests: "3",
                   failures: "0",
                   time: "0.0015",
                   skipped: "0",
                   errors: "0",
                   timestamp: "",
                   file: "/path/to/file",
                   testcases: [],
                   properties: [%Property{name: "foo", value: "bar"}]
                 } = parsed_testsuite
      end
    end
  end
end
