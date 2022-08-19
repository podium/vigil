defmodule VigilTest.SanitizerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import ExUnit.CaptureLog

  alias Vigil.Sanitizer

  doctest Vigil.Sanitizer

  # Conn initial responses

  @missing_field_response %{
    errors: [
      %{
        locations: [
          %{
            column: 9,
            line: 1
          }
        ],
        message: "Cannot query field \"blah\" on type \"RootQueryType\"."
      }
    ]
  }

  @suggested_field_response %{
    errors: [
      %{
        locations: [
          %{
            column: 3,
            line: 2
          }
        ],
        message:
          "Cannot query field \"foo\" on type \"FooBarBaz\". Did you mean \"BazBangBamph\"?"
      }
    ]
  }

  @missing_arg_response %{
    errors: [
      %{
        locations: [%{column: 9, line: 1}],
        message: "In argument \"foo\": Expected type \"FOO!\", found null."
      },
      %{
        locations: [%{column: 9, line: 1}],
        message: "In argument \"bar\": Expected type \"BAR!\", found null."
      }
    ]
  }

  @missing_subfields_response %{
    errors: [
      %{
        locations: [
          %{
            column: 9,
            line: 1
          }
        ],
        message:
          "Field \"foo\" of type \"ZorkType\" must have a selection of subfields. Did you mean \"BazBangBamph { ... }\"?"
      }
    ]
  }

  # Conn sanitized responses

  @bad_request_response %{"errors" => [%{"message" => "Bad Request"}]}

  @sanitized_suggested_field_response %{
    "errors" => [
      %{
        "locations" => [%{"column" => 3, "line" => 2}],
        "message" => "Cannot query field \"foo\" on type \"FooBarBaz\"."
      }
    ]
  }

  @sanitized_missing_subfields_response %{
    "errors" => [
      %{
        "locations" => [%{"column" => 9, "line" => 1}],
        "message" => "Field \"foo\" of type \"ZorkType\" must have a selection of subfields."
      }
    ]
  }

  @default_opts %{}

  defp get_conn(response, status \\ 200) do
    %{conn(:post, "/graphql") | resp_body: response, status: status}
  end

  describe "sanitize_response/1" do
    test "returns its argument when it is not a conn" do
      assert Sanitizer.sanitize_response("foo", @default_opts) == "foo"
    end

    test "returns the connection unchanged when no errors are detected" do
      conn = get_conn("foo")

      assert Sanitizer.sanitize_response(conn, @default_opts) == conn
    end

    test "returns the connection unchanged when a missing field is detected, but no suggestion was found" do
      conn = @missing_field_response |> Jason.encode!() |> get_conn()
      sanitized = Sanitizer.sanitize_response(conn, @default_opts)

      assert sanitized.status == 200
      assert sanitized.resp_body == conn.resp_body
    end

    test "returns a sanitized version of the original error when the field cannot be found, and a suggestion was made" do
      conn = @suggested_field_response |> Jason.encode!() |> get_conn()
      sanitized = Sanitizer.sanitize_response(conn, @default_opts)

      assert sanitized.status == 200

      assert Jason.decode!(sanitized.resp_body) == @sanitized_suggested_field_response
    end

    test "returns the original status but a Bad Request message when a required argument is missing" do
      conn = @missing_arg_response |> Jason.encode!() |> get_conn()
      sanitized = Sanitizer.sanitize_response(conn, @default_opts)

      assert sanitized.status == 200
      assert Jason.decode!(sanitized.resp_body) == @bad_request_response
    end

    test "returns the original error minus the suggestion when a missing subfield was found" do
      conn = @missing_subfields_response |> Jason.encode!() |> get_conn()
      sanitized = Sanitizer.sanitize_response(conn, @default_opts)

      assert sanitized.status == 200

      assert Jason.decode!(sanitized.resp_body) == @sanitized_missing_subfields_response
    end

    test "it handles iodata as the resp_body" do
      conn = get_conn(["errors", 32, 43 | "something"])

      Sanitizer.sanitize_response(conn, @default_opts)
      # if this doesn't throw, it works
    end

    test "logs error when the response body is not valid JSON" do
      conn = get_conn("<html> <body> <h1> lol i'm an html doc </h1> </body> </html>")

      {new_conn, log} =
        with_log(fn ->
          Sanitizer.sanitize_response(conn, @default_opts)
        end)

      assert log =~ "Possible JSON Parse Error"
      assert new_conn == conn
    end

    test "does not log errors when the response body contains no errors key" do
      conn = %{foo: "bar", baz: "bang", bamph: "zork"} |> Jason.encode!() |> get_conn()

      {new_conn, log} =
        with_log(fn ->
          Sanitizer.sanitize_response(conn, @default_opts)
        end)

      assert log == ""
      assert new_conn == conn
    end

    test "does not log errors when only a data key is present" do
      conn = %{data: %{foo: %{bar: "..."}}} |> Jason.encode!() |> get_conn()

      {new_conn, log} =
        with_log(fn ->
          Sanitizer.sanitize_response(conn, @default_opts)
        end)

      assert log == ""
      assert new_conn == conn
    end

    test "does not log errors when a GraphQL error key is returned, but it points to an empty array" do
      conn = %{data: %{foo: "bar"}, errors: []} |> Jason.encode!() |> get_conn()

      {new_conn, log} =
        with_log(fn ->
          Sanitizer.sanitize_response(conn, @default_opts)
        end)

      assert log == ""
      assert new_conn == conn
    end

    test "logs error when the errors aren't a map for some reason" do
      conn = get_conn(~S({"data": {}, "errors": [{"foo", "bar"}]}))

      {new_conn, log} =
        with_log(fn ->
          Sanitizer.sanitize_response(conn, @default_opts)
        end)

      assert log =~ "Possible JSON Parse Error"
      assert new_conn == conn
    end
  end
end
