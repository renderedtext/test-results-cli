defmodule ResultParser.XMLTest do
  use ExUnit.Case
  doctest ResultParser.XML

  # describe "different root elements" do
  #   test "works correctly single root <testsuites> element" do
  #     testsuites_xml = """
  #       <testsuites name="testsuites#1" time="1" tests="1" failures="1">
  #         <testsuite name="testsuite#1"></testsuite>
  #         <testsuite name="testsuite#2"></testsuite>
  #       </testsuites>
  #     """

  #     results =
  #       testsuites_xml
  #       |> parse_xml()
  #       |> ResultParser.XML.parse_root()

  #     assert %{
  #              name: "testsuites#1",
  #              time: "1",
  #              tests: "1",
  #              failures: "1",
  #              testsuites: [%{name: "testsuite#1"}, %{name: "testsuite#2"}]
  #            } = results
  #   end

  #   test "works correctly single root <testsuite> element" do
  #     testsuites_xml = """
  #       <testsuite name="testsuite#1" time="1" tests="1" failures="1">
  #         <testcase name="testcase#1"></testcase>
  #         <testcase name="testcase#2"></testcase>
  #       </testsuite>
  #     """

  #     results =
  #       testsuites_xml
  #       |> parse_xml()
  #       |> ResultParser.XML.parse_root()

  #     assert %{
  #              name: "testsuite#1",
  #              time: "1",
  #              tests: "1",
  #              failures: "1",
  #              testsuites: [
  #                %{name: "testsuite#1", testcases: [%{name: "testcase#1"}, %{name: "testcase#2"}]}
  #              ]
  #            } = results
  #   end
  # end

  # describe "parsing root <testsuites> or <testsuite> element" do
  #   test "works correctly single root <testsuites> element" do
  #     xml = """
  #       <testsuites name="testsuites#1" time="1" tests="1" failures="1">
  #       </testsuites>
  #     """

  #     results =
  #       xml
  #       |> parse_xml()
  #       |> ResultParser.XML.parse_rootsuite()

  #     assert %{
  #              name: "testsuites#1",
  #              time: "1",
  #              tests: "1",
  #              failures: "1",
  #              testsuites: []
  #            } = results
  #   end

  #   test "works correctly single root <testsuite> element" do
  #     xml = """
  #       <testsuite name="testsuite#1" time="1" tests="1" failures="1">
  #       </testsuite>
  #     """

  #     results =
  #       xml
  #       |> parse_xml()
  #       |> ResultParser.XML.parse_rootsuite()

  #     assert %{
  #              name: "testsuite#1",
  #              time: "1",
  #              tests: "1",
  #              failures: "1",
  #              testsuites: [
  #                %{
  #                  name: "testsuite#1",
  #                  time: "1",
  #                  tests: "1",
  #                  failures: "1"
  #                }
  #              ]
  #            } = results
  #   end
  # end

  # describe "parsing <testsuite> element" do
  #   test "provides valida data without testcases" do
  #     xml = """
  #       <testsuite id="1" name="test" tests="3" failures="0" time="0.0015" skipped="0" errors="0" timestamp="" file="/path/to/file">
  #       </testsuite>
  #     """

  #     xml
  #     |> parse_xml
  #     |> ResultParser.XML.parse_testsuite()
  #     |> case do
  #       parsed_testsuite ->
  #         assert %{
  #                  id: "1",
  #                  name: "test",
  #                  tests: "3",
  #                  failures: "0",
  #                  time: "0.0015",
  #                  skipped: "0",
  #                  errors: "0",
  #                  timestamp: "",
  #                  file: "/path/to/file",
  #                  testcases: []
  #                } = parsed_testsuite
  #     end
  #   end

  #   test "works correctly with testcases" do
  #     xml = """
  #       <testsuite id="1" name="test" tests="3" failures="0" time="0.0015" skipped="0" errors="0" timestamp="" file="/path/to/file">
  #         <testcase name="testcase#1"></testcase>
  #         <testcase name="testcase#2"></testcase>
  #       </testsuite>
  #     """

  #     xml
  #     |> parse_xml
  #     |> ResultParser.XML.parse_testsuite()
  #     |> case do
  #       parsed_testsuite ->
  #         assert %{
  #                  testcases: [%{name: "testcase#1"}, %{name: "testcase#2"}]
  #                } = parsed_testsuite
  #     end
  #   end

  #   test "works correctly with properties" do
  #     xml = """
  #       <testsuite id="1" name="test" tests="3" failures="0" time="0.0015" skipped="0" errors="0" timestamp="" file="/path/to/file">
  #         <testcase name="testcase#1"></testcase>
  #         <testcase name="testcase#2"></testcase>
  #       </testsuite>
  #     """

  #     xml
  #     |> parse_xml
  #     |> ResultParser.XML.parse_testsuite()
  #     |> case do
  #       parsed_testsuite ->
  #         assert %{
  #                  testcases: [%{name: "testcase#1"}, %{name: "testcase#2"}]
  #                } = parsed_testsuite
  #     end
  #   end
  # end

  # describe "parsing <testcase> element" do
  #   test "works correctly testcase with failures" do
  #     xml = """
  #     <testcase file="/path/to/file" classname="some_classname" name="some_name" time="0.0001">
  #       <failure message="failure_message" type="failure_type">failure_text</failure>
  #     </testcase>
  #     """

  #     xml
  #     |> parse_xml
  #     |> ResultParser.XML.parse_testcase()
  #     |> case do
  #       parsed_testsuite ->
  #         assert %{
  #                  name: "some_name",
  #                  time: "0.0001",
  #                  file: "/path/to/file",
  #                  classname: "some_classname",
  #                  is_skipped: false,
  #                  is_failed: true,
  #                  failure_message: "failure_message",
  #                  failure_type: "failure_type",
  #                  failure_text: "failure_text"
  #                } = parsed_testsuite
  #     end
  #   end

  #   test "works correctly testcase without failures" do
  #     xml = """
  #     <testcase file="/path/to/file" classname="some_classname2" name="some_name2" time="0.0003">
  #     </testcase>
  #     """

  #     xml
  #     |> parse_xml
  #     |> ResultParser.XML.parse_testcase()
  #     |> case do
  #       parsed_testsuite ->
  #         assert %{
  #                  name: "some_name2",
  #                  time: "0.0003",
  #                  file: "/path/to/file",
  #                  classname: "some_classname2",
  #                  is_skipped: false,
  #                  is_failed: false,
  #                  failure_message: nil,
  #                  failure_type: nil,
  #                  failure_text: nil
  #                } = parsed_testsuite
  #     end
  #   end

  #   test "works correctly skipped testcase" do
  #     xml = """
  #     <testcase file="/path/to/file" classname="some_classname1" name="some_name1" time="0.0002">
  #       <skipped />
  #     </testcase>
  #     """

  #     xml
  #     |> parse_xml
  #     |> ResultParser.XML.parse_testcase()
  #     |> case do
  #       parsed_testsuite ->
  #         assert %{
  #                  name: "some_name1",
  #                  time: "0.0002",
  #                  file: "/path/to/file",
  #                  classname: "some_classname1",
  #                  is_skipped: true,
  #                  is_failed: false,
  #                  failure_message: nil,
  #                  failure_type: nil,
  #                  failure_text: nil
  #                } = parsed_testsuite
  #     end
  #   end
  # end
end
