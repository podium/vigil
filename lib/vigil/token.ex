defmodule Vigil.Token do
  @moduledoc """
  Utilities for validating simple tokens
  """

  import Plug.Crypto, only: [secure_compare: 2]

  alias Plug.Conn

  # x-introspection-token is here for backwards compatibility
  @token_headers ["introspection-token", "x-introspection-token"]

  @doc """
  Accepts a %Plug.Conn{} struct containing the header token and the token to compare it to
  """
  @spec valid?(conn :: Conn.t(), token :: mfa() | nil) :: boolean()
  def valid?(%Conn{} = conn, token) do
    with token when not is_nil(token) <- get_token(token),
         header_token when not is_nil(header_token) <- get_header_token(conn) do
      secure_compare(header_token, token)
    else
      _ -> false
    end
  end

  defp get_header_token(conn) do
    Enum.find_value(@token_headers, fn header ->
      case Conn.get_req_header(conn, header) do
        [token] when is_binary(token) -> token
        _ -> nil
      end
    end)
  end

  defp get_token({module, function, args}), do: apply(module, function, args)
  defp get_token(nil), do: Application.get_env(:vigil, :token)
end
