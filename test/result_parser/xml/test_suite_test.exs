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

      parsed =
        xml
        |> XMLHelper.parse_xml()
        |> TestSuite.parse()

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
               test_cases: [],
               properties: []
             } = parsed
    end

    test "provides valid output for <testsuite> element with testcases" do
      xml = """
        <testsuite id="1" name="test" tests="3" failures="0" time="0.0015" skipped="0" errors="0" timestamp="" file="/path/to/file">
          <testcase name="test"></testcase>
        </testsuite>
      """

      parsed =
        xml
        |> XMLHelper.parse_xml()
        |> TestSuite.parse()

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
               test_cases: [%TestCase{name: "test"}],
               properties: []
             } = parsed
    end

    test "provides valid output for <testsuite> element with properties" do
      xml = """
        <testsuite id="1" name="test" tests="3" failures="0" time="0.0015" skipped="0" errors="0" timestamp="" file="/path/to/file">
          <properties>
            <property name="foo" value="bar"></property>
          </properties>
        </testsuite>
      """

      parsed =
        xml
        |> XMLHelper.parse_xml()
        |> TestSuite.parse()

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
               test_cases: [],
               properties: [%Property{name: "foo", value: "bar"}]
             } = parsed
    end
  end
end
