defmodule ResultParser.XML.TestCaseTest do
  use ExUnit.Case

  alias ResultParser.XML.{
    TestCase
  }

  doctest TestCase
  describe "#{TestSuite}#parse/1" do
    test "provides valid output for <testsuite> element" do
      xml = """
        <testcase file="/path/to/file" classname="some_classname" name="some_name" time="0.0001">
          <failure message="failure_message" type="failure_type">failure_text</failure>
        </testcase>
      """

      xml
      |> XMLHelper.parse_xml()
      |> ResultParser.XML.TestSuite.parse()
      |> case do
        parsed_testsuite ->
        end
      end
    end
  end
end
# name
# time
# file
# classname
# is_skipped
# is_failed
# failure_message
# failure_type
# failure_text
