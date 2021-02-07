defmodule ResultParser.XMLTest do
  use ExUnit.Case
  doctest ResultParser.XML

  describe "different root elements" do
    test "parses correctly single root <testsuites> element" do
      testsuites_xml = """
        <testsuites name="testsuites#1" time="1" tests="1" failures="1">
          <testsuite name="testsuite#1"></testsuite>
          <testsuite name="testsuite#2"></testsuite>
        </testsuites>
      """

      results =
        testsuites_xml
        |> parse_xml()
        |> ResultParser.XML.parse_root()

      assert %{
               name: "testsuites#1",
               time: "1",
               tests: "1",
               failures: "1",
               testsuites: [%{name: "testsuite#1"}, %{name: "testsuite#2"}]
             } = results
    end

    test "parses correctly single root <testsuite> element" do
      testsuites_xml = """
        <testsuite name="testsuite#1" time="1" tests="1" failures="1">
          <testcase name="testcase#1"></testcase>
          <testcase name="testcase#2"></testcase>
        </testsuite>
      """

      results =
        testsuites_xml
        |> parse_xml()
        |> ResultParser.XML.parse_root()

      assert %{
               name: "testsuite#1",
               time: "1",
               tests: "1",
               failures: "1",
               testsuites: [
                 %{name: "testsuite#1", testcases: [%{name: "testcase#1"}, %{name: "testcase#2"}]}
               ]
             } = results
    end
  end

  describe "plain testsuite" do
    setup do
      xml = """
        <testsuite id="1" name="test" tests="3" failures="0" time="0.0015" skipped="0" errors="0" timestamp="" file="/path/to/file">
        </testsuite>
      """

      [
        xml: xml
      ]
    end

    test "parses correctly", %{xml: xml} do
      xml
      |> parse_xml
      |> ResultParser.XML.parse_testsuite()
      |> case do
        parsed_testsuite ->
          assert %{
                   id: "1",
                   name: "test",
                   tests: "3",
                   failures: "0",
                   time: "0.0015",
                   skipped: "0",
                   errors: "0",
                   timestamp: "",
                   file: "/path/to/file"
                 } = parsed_testsuite
      end
    end
  end

  describe "testsuite with properties" do
    setup do
      xml = """
        <testsuite id="1" name="test" tests="3" failures="0" time="0.0015" skipped="0" errors="0" timestamp="" file="/path/to/file">
          <properties>
            <property name="foo" value="bar" />
            <property name="baz" value="true" />
          </properties>
        </testsuite>
      """

      [
        xml: xml
      ]
    end

    test "parses correctly", %{xml: xml} do
      xml
      |> parse_xml
      |> ResultParser.XML.parse_testsuite()
      |> case do
        parsed_testsuite ->
          assert %{
                   id: "1",
                   name: "test",
                   tests: "3",
                   failures: "0",
                   time: "0.0015",
                   skipped: "0",
                   errors: "0",
                   timestamp: "",
                   file: "/path/to/file",
                   properties: [
                     %{name: "foo", value: "bar"},
                     %{name: "baz", value: "true"}
                   ]
                 } = parsed_testsuite
      end
    end
  end

  describe "testsuite with testcases" do
    setup do
      xml = """
        <testsuite id="1" name="test" tests="3" failures="1" time="0.0015" skipped="1" errors="0" timestamp="" file="/path/to/file">
          <testcase file="/path/to/file" classname="some_classname" name="some_name" time="0.0001">
            <failure message="failure_message" type="failure_type">failure_text</failure>
          </testcase>
          <testcase file="/path/to/file" classname="some_classname1" name="some_name1" time="0.0002">
            <skipped />
          </testcase>
          <testcase file="/path/to/file" classname="some_classname2" name="some_name2" time="0.0003">
          </testcase>
        </testsuite>
      """

      [
        xml: xml
      ]
    end

    test "parses correctly", %{xml: xml} do
      xml
      |> parse_xml
      |> ResultParser.XML.parse_testsuite()
      |> case do
        parsed_testsuite ->
          assert %{
                   id: "1",
                   name: "test",
                   tests: "3",
                   failures: "1",
                   time: "0.0015",
                   skipped: "1",
                   errors: "0",
                   timestamp: "",
                   file: "/path/to/file",
                   properties: [],
                   testcases: [
                     %{
                       file: "/path/to/file",
                       classname: "some_classname",
                       name: "some_name",
                       is_skipped: false,
                       is_failed: true,
                       time: "0.0001",
                       failure_message: "failure_message",
                       failure_type: "failure_type",
                       failure_text: "failure_text"
                     },
                     %{
                       file: "/path/to/file",
                       classname: "some_classname1",
                       name: "some_name1",
                       is_skipped: true,
                       is_failed: false,
                       time: "0.0002",
                       failure_message: nil,
                       failure_type: nil,
                       failure_text: nil
                     },
                     %{
                       file: "/path/to/file",
                       classname: "some_classname2",
                       name: "some_name2",
                       is_skipped: false,
                       is_failed: false,
                       time: "0.0003",
                       failure_message: nil,
                       failure_type: nil,
                       failure_text: nil
                     }
                   ]
                 } = parsed_testsuite
      end
    end
  end

  def parse_xml(xml) do
    xml
    |> to_charlist
    |> :xmerl_scan.string()
    |> case do
      {xml, _rest} -> xml
    end
  end
end
