defmodule ResultParser.XML do
  alias __MODULE__

  @spec parse(String.t()) :: XML.RootSuite.t()
  def parse(file) do
    {doc, _} =
      file
      |> :xmerl_scan.file()

    XML.RootSuite.parse(doc)
  end

  # @spec parse_rootsuite(term()) :: t()
  # def parse_rootsuite(xml_node) do
  #   first_node = Node.first(xml_node, "/*")

  #   first_node
  #   |> Node.node_name()
  #   |> case do
  #     :testsuites ->
  #       %{
  #         name: Node.attr(first_node, "name"),
  #         time: Node.attr(first_node, "time"),
  #         tests: Node.attr(first_node, "tests"),
  #         failures: Node.attr(first_node, "failures"),
  #         testsuites: Node.all(first_node, ".//testsuite") |> Enum.map(&parse_testsuite/1)
  #       }

  #     :testsuite ->
  #       %{
  #         name: Node.attr(first_node, "name"),
  #         time: Node.attr(first_node, "time"),
  #         tests: Node.attr(first_node, "tests"),
  #         failures: Node.attr(first_node, "failures"),
  #         testsuites: [first_node] |> Enum.map(&parse_testsuite/1)
  #       }

  #     _ ->
  #       %{
  #         name: "Not Found",
  #         time: "0",
  #         tests: "0",
  #         failures: "0",
  #         testsuites: []
  #       }
  #   end
  # end

  # @spec parse_testsuite(term()) :: testsuite()
  # def parse_testsuite(testsuite_node) do
  #   test_cases =
  #     Node.all(testsuite_node, ".//testcase")
  #     |> Enum.map(&parse_testcase/1)

  #   properties =
  #     Node.all(testsuite_node, ".//properties/property")
  #     |> Enum.map(&parse_property/1)

  #   %{
  #     id: Node.attr(testsuite_node, "id"),
  #     name: Node.attr(testsuite_node, "name"),
  #     tests: Node.attr(testsuite_node, "tests"),
  #     failures: Node.attr(testsuite_node, "failures"),
  #     time: Node.attr(testsuite_node, "time"),
  #     skipped: Node.attr(testsuite_node, "skipped"),
  #     errors: Node.attr(testsuite_node, "errors"),
  #     timestamp: Node.attr(testsuite_node, "timestamp"),
  #     file: Node.attr(testsuite_node, "file"),
  #     properties: properties,
  #     testcases: test_cases
  #   }
  # end

  # @spec parse_property(term()) :: property()
  # def parse_property(property_node) do
  #   %{
  #     name: Node.attr(property_node, "name"),
  #     value: Node.attr(property_node, "value")
  #   }
  # end

  # @spec parse_testcase(term()) :: testcase()
  # def parse_testcase(testcase_node) do
  #   failure_node = Node.first(testcase_node, "./failure")

  #   %{
  #     name: Node.attr(testcase_node, "name"),
  #     time: Node.attr(testcase_node, "time"),
  #     file: Node.attr(testcase_node, "file"),
  #     classname: Node.attr(testcase_node, "classname"),
  #     is_skipped: not is_nil(Node.first(testcase_node, "./skipped")),
  #     is_failed: not is_nil(failure_node),
  #     failure_message: Node.attr(failure_node, "message"),
  #     failure_type: Node.attr(failure_node, "type"),
  #     failure_text: Node.text(failure_node)
  #   }
  # end
end
