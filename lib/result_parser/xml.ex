defmodule ResultParser.XML do
  defmodule Node do
    require Record

    Record.defrecord(
      :xmlAttribute,
      Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
    )

    Record.defrecord(:xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

    def from_string(xml_string, options \\ [quiet: true]) do
      {doc, []} =
        xml_string
        |> :binary.bin_to_list()
        |> :xmerl_scan.string(options)

      doc
    end

    def all(node, path) do
      for child_element <- xpath(node, path) do
        child_element
      end
    end

    def first(node, path), do: node |> xpath(path) |> take_one
    defp take_one([head | _]), do: head
    defp take_one(_), do: nil

    def node_name(nil), do: nil
    def node_name(node), do: elem(node, 1)

    def attr(node, name), do: node |> xpath('./@#{name}') |> extract_attr
    defp extract_attr([xmlAttribute(value: value)]), do: List.to_string(value)
    defp extract_attr(_), do: nil

    def text(node), do: node |> xpath('./text()') |> extract_text
    defp extract_text([xmlText(value: value)]), do: List.to_string(value)
    defp extract_text(_x), do: nil

    defp xpath(nil, _), do: []

    defp xpath(node, path) do
      :xmerl_xpath.string(to_charlist(path), node)
    end
  end

  @type t :: %{
          name: String.t(),
          time: String.t(),
          tests: String.t(),
          failures: String.t(),
          testsuites: [testsuite()]
        }

  @type testsuite :: %{
          id: String.t(),
          name: String.t(),
          tests: String.t(),
          failures: String.t(),
          time: String.t(),
          skipped: String.t(),
          errors: String.t(),
          timestamp: String.t(),
          file: String.t(),
          properties: [property()],
          testcases: [testcase()]
        }

  @type property :: %{
          name: String.t(),
          value: String.t()
        }

  @type testcase :: %{
          name: String.t(),
          time: String.t(),
          file: String.t(),
          classname: String.t(),
          is_skipped: boolean(),
          is_failed: boolean(),
          failure_message: String.t(),
          failure_type: String.t(),
          failure_text: String.t()
        }

  @spec parse(String.t()) :: t()
  def parse(file) do
    {doc, _} =
      file
      |> :xmerl_scan.file()

    first_node = Node.first(doc, "/*")

    first_node
    |> Node.node_name()
    |> case do
      :testsuites ->
        %{
          name: Node.attr(first_node, "name"),
          time: Node.attr(first_node, "time"),
          tests: Node.attr(first_node, "tests"),
          failures: Node.attr(first_node, "failures"),
          testsuites: Node.all(first_node, ".//testsuite") |> Enum.map(&parse_testsuite/1)
        }

      :testsuite ->
        %{
          name: Node.attr(first_node, "name"),
          time: Node.attr(first_node, "time"),
          tests: Node.attr(first_node, "tests"),
          failures: Node.attr(first_node, "failures"),
          testsuites: [first_node] |> Enum.map(&parse_testsuite/1)
        }

      _ ->
        %{
          name: "Not Found",
          time: "0",
          tests: "0",
          failures: "0",
          testsuites: []
        }
    end
  end

  @spec parse_testsuite(term()) :: testsuite()
  def parse_testsuite(testsuite_node) do
    test_cases =
      Node.all(testsuite_node, ".//testcase")
      |> Enum.map(&parse_testcase/1)

    properties =
      Node.all(testsuite_node, ".//properties/property")
      |> Enum.map(&parse_property/1)

    %{
      id: Node.attr(testsuite_node, "id"),
      name: Node.attr(testsuite_node, "name"),
      tests: Node.attr(testsuite_node, "tests"),
      failures: Node.attr(testsuite_node, "failures"),
      time: Node.attr(testsuite_node, "time"),
      skipped: Node.attr(testsuite_node, "skipped"),
      errors: Node.attr(testsuite_node, "errors"),
      timestamp: Node.attr(testsuite_node, "timestamp"),
      file: Node.attr(testsuite_node, "file"),
      properties: properties,
      testcases: test_cases
    }
  end

  @spec parse_property(term()) :: property()
  def parse_property(property_node) do
    %{
      name: Node.attr(property_node, "name"),
      value: Node.attr(property_node, "value")
    }
  end

  @spec parse_testcase(term()) :: testcase()
  def parse_testcase(testcase_node) do
    failure_node = Node.first(testcase_node, "./failure")

    %{
      name: Node.attr(testcase_node, "name"),
      time: Node.attr(testcase_node, "time"),
      file: Node.attr(testcase_node, "file"),
      classname: Node.attr(testcase_node, "classname"),
      is_skipped: not is_nil(Node.first(testcase_node, "./skipped")),
      is_failed: not is_nil(failure_node),
      failure_message: Node.attr(failure_node, "message"),
      failure_type: Node.attr(failure_node, "type"),
      failure_text: Node.text(failure_node)
    }
  end
end
