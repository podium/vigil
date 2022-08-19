defmodule VigilTest.TokenTest do
  use ExUnit.Case, async: false
  use Plug.Test

  alias Vigil.Token

  doctest Vigil.Token

  defp token_mfa(token), do: {Function, :identity, [token]}

  describe "valid?/1" do
    setup do
      on_exit(fn -> Application.delete_env(:vigil, :token) end)
    end

    test "true when the header is present, and the value is valid" do
      token = "example token"

      conn =
        :post
        |> conn("/graphql")
        |> put_req_header("introspection-token", token)

      assert Token.valid?(conn, token_mfa(token))
    end

    test "true when the old header is present, and the value is valid" do
      token = "example token"

      conn =
        :post
        |> conn("/graphql")
        |> put_req_header("x-introspection-token", token)

      assert Token.valid?(conn, token_mfa(token))
    end

    # Can't have people trying to guess the token by sending a bunch of the same header
    test "false when multiple header values are present, and the value is valid" do
      token = "example token"
      header = {"introspection-token", token}

      conn = %{conn(:post, "/graphql") | req_headers: [header, header]}

      refute Token.valid?(conn, token_mfa(token))
    end

    test "false when the header is present, and the value is invalid" do
      conn =
        :post
        |> conn("/graphql")
        |> put_req_header("introspection-token", "example token")

      refute Token.valid?(conn, token_mfa("nope"))
    end

    test "false when no header is present" do
      conn = conn(:post, "/graphql")

      refute Token.valid?(conn, token_mfa("nope"))
    end

    test "uses application env when token is nil" do
      token = "example token"
      Application.put_env(:vigil, :token, token)

      conn =
        :post
        |> conn("/graphql")
        |> put_req_header("introspection-token", token)

      assert Token.valid?(conn, nil)
    end

    test "false when token is nil and no token set in env" do
      conn =
        :post
        |> conn("/graphql")
        |> put_req_header("introspection-token", "example token")

      refute Token.valid?(conn, nil)
    end

    test "false when token MFA returns nil and no token set in env" do
      conn =
        :post
        |> conn("/graphql")
        |> put_req_header("introspection-token", "example token")

      refute Token.valid?(conn, token_mfa(nil))
    end

    test "false when no token is sent and token is nil and no token set in env" do
      conn = conn(:post, "/graphql")

      refute Token.valid?(conn, nil)
    end
  end
end
