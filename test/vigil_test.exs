defmodule VigilTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest Vigil

  alias Vigil

  @default_introspection_token "valid-introspection-token"

  setup_all do
    conn =
      :post
      |> conn("/graphql")
      |> put_req_header("introspection-token", @default_introspection_token)

    %{conn: conn}
  end

  defp token_mfa(token), do: {Function, :identity, [token]}

  describe "init/1" do
    test "correctly configures default options" do
      assert Vigil.init([]) == %{allow_introspection: false, log_level: :debug}
    end

    test "correctly overrides default options" do
      assert Vigil.init(log_level: :error) == %{
               allow_introspection: false,
               log_level: :error
             }
    end

    test "correctly gets defaults even when other options are passed" do
      assert Vigil.init(something: :else) == %{
               something: :else,
               allow_introspection: false,
               log_level: :debug
             }
    end
  end

  describe "call/2" do
    test "It doesn't crash with a simple call", %{conn: conn} do
      assert Vigil.call(conn, %{allow_introspection: false})
    end

    test "It doesn't crash with a simple call that takes nonsense options", %{conn: conn} do
      assert Vigil.call(conn, %{allow_introspection: false, foo: :bar})
    end

    test "It doesn't crash with a simple call that overrides the log level", %{conn: conn} do
      assert Vigil.call(conn, %{
               allow_introspection: false,
               log_level: :warn
             })
    end
  end

  # The query is safe and the token is valid
  test "passes the plug connection on when given a valid token and a safe query", %{conn: conn} do
    conn = %{conn | body_params: %{"query" => "query foo { bar }"}}
    opts = %{token: token_mfa(@default_introspection_token)}

    conn = Vigil.call(conn, opts)

    refute conn.halted
    assert is_nil(conn.status)
    assert is_nil(conn.resp_body)
  end

  # Token is valid, so it doesn't matter if the query is an introspection query
  test "passes the plug connection on when given a valid token and an unsafe query", %{conn: conn} do
    conn = %{conn | body_params: %{"query" => "__schema"}}
    opts = %{token: token_mfa(@default_introspection_token)}

    conn = Vigil.call(conn, opts)

    refute conn.halted
    assert is_nil(conn.status)
    assert is_nil(conn.resp_body)
  end

  # Absent/invalid token, but the query string is safe
  test "passes the plug connection on when given an invalid token and a safe query", %{conn: conn} do
    conn = %{conn | body_params: %{"query" => "query foo { bar }"}}
    opts = %{token: token_mfa(@default_introspection_token <> "-invalid")}

    conn = Vigil.call(conn, opts)

    refute conn.halted
    assert is_nil(conn.status)
    assert is_nil(conn.resp_body)
  end

  # Neither a valid token nor a safe query string, so this should be forbidden.
  test "sends back a 200 OK status but 403 message when given an unsafe query and invalid token",
       %{conn: conn} do
    conn = %{conn | body_params: %{"query" => "__schema"}}
    opts = %{token: token_mfa(@default_introspection_token <> "-invalid")}

    conn = Vigil.call(conn, opts)

    assert conn.halted
    assert conn.status == 200
    assert conn.resp_body == ~s({"errors": [{"message": "Forbidden request"}]})

    assert get_resp_header(conn, "content-type") == ["application/json; charset=utf-8"]
  end
end
