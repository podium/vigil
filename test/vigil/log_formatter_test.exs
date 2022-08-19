defmodule VigilTest.LogFormatterTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  alias Vigil.LogFormatter

  describe "log/3" do
    test "it logs at the expected level and with the expected message" do
      conn = %Plug.Conn{
        resp_body: %{test: "val"},
        host: "localhost",
        method: "POST",
        path_info: "pathy"
      }

      errors = "errors"

      log = capture_log(fn -> LogFormatter.log(conn, errors, []) end)

      assert String.contains?(log, "debug")

      assert String.contains?(
               log,
               ~s(%{body: %{test: "val"}, error: "errors", host: "localhost", logger: :vigil, method: "POST", path_info: "pathy"})
             )
    end

    test "it handles encoding failures" do
      conn_with_iodata = %Plug.Conn{
        resp_body: ["errors", 32, 43 | "something"],
        host: "localhost",
        method: "POST",
        path_info: "pathy"
      }

      errors = "errors"

      log = capture_log(fn -> LogFormatter.log(conn_with_iodata, errors, []) end)

      assert log =~ "error"
    end
  end
end
