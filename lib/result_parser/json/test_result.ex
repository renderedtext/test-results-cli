defmodule ResultParser.JSON.TestResult do
  alias __MODULE__
  alias ResultParser.JSON.TestResult

  defstruct [
    :id,
    :name,
    :time,
    :file,
    :classname,
    :is_skipped,
    :is_failed,
    :failure_message,
    :failure_type,
    :failure_text
  ]

  @type t :: %TestResult{
          id: String.t(),
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
  @type t_build_params :: %{
          id: String.t(),
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

  @spec build(t_build_params()) :: t()
  def build(%{
        id: id,
        name: name,
        time: time,
        file: file,
        classname: classname,
        is_skipped: is_skipped,
        is_failed: is_failed,
        failure_message: failure_message,
        failure_type: failure_type,
        failure_text: failure_text
      }) do
    %TestResult{
      id: id,
      name: name,
      time: time,
      file: file,
      classname: classname,
      is_skipped: is_skipped,
      is_failed: is_failed,
      failure_message: failure_message,
      failure_type: failure_type,
      failure_text: failure_text
    }
  end
end
