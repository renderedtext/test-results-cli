defmodule ResultParser.XML.PropertyTest do
  use ExUnit.Case
  alias ResultParser.XML.Property
  doctest Property

  describe "#{Property}#parse/1" do
    test "provides valid output for <property> element" do
      xml = """
        <property name="foo" value="bar"></property>
      """

      parsed =
        xml
        |> XMLHelper.parse_xml()
        |> Property.parse()

      assert %Property{
               name: "foo",
               value: "bar"
             } = parsed
    end
  end
end
