defmodule ResultParser.XML.TestCaseTest do
  use ExUnit.Case

  alias ResultParser.XML.{
    TestCase
  }

  doctest TestCase

  describe "#{TestCase}#parse/1" do
    test "provides valid output for <testcase> element" do
      xml = """
        <testcase file="/path/to/file" classname="some_classname" name="some_name" time="0.0001">
        </testcase>
      """

      parsed =
        xml
        |> XMLHelper.parse_xml()
        |> TestCase.parse()

      assert %TestCase{
               name: "some_name",
               time: 0.0001,
               file: "/path/to/file",
               classname: "some_classname",
               is_skipped: false,
               is_failed: false,
               failure_message: nil,
               failure_type: nil,
               failure_text: nil
             } = parsed
    end

    test "provides valid output for <testcase> element that is skipped" do
      xml = """
        <testcase file="/path/to/file" classname="some_classname" name="some_name" time="0.0001">
          <skipped></skipped>
        </testcase>
      """

      parsed =
        xml
        |> XMLHelper.parse_xml()
        |> TestCase.parse()

      assert %TestCase{
               name: "some_name",
               time: 0.0001,
               file: "/path/to/file",
               classname: "some_classname",
               is_skipped: true,
               is_failed: false,
               failure_message: nil,
               failure_type: nil,
               failure_text: nil
             } = parsed
    end

    test "provides valid output for <testcase> element with failure" do
      xml = """
        <testcase file="/path/to/file" classname="some_classname" name="some_name" time="0.0001">
          <failure message="failure_message" type="failure_type">failure_text</failure>
        </testcase>
      """

      parsed =
        xml
        |> XMLHelper.parse_xml()
        |> TestCase.parse()

      assert %TestCase{
               name: "some_name",
               time: 0.0001,
               file: "/path/to/file",
               classname: "some_classname",
               is_skipped: false,
               is_failed: true,
               failure_message: "failure_message",
               failure_type: "failure_type",
               failure_text: "failure_text"
             } = parsed
    end
  end
end
