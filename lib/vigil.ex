defmodule Vigil do
  @moduledoc """
  Documentation for Vigil.

  As a gatekeeper for your GraphQL API, Vigil disallows introspection of a
  GraphQL schema and sanitizes error messages to be completely generic and not reveal information
  about your schema.

  This plug disables graphql introspection by returning a Forbidden status if an
  introspection query of any kind is contained in the query string.

  It also returns a `Not Found` if an request is made on a non-existent field, and `Bad Request`
  if required arguments are missing.

  For more information about introspection queries see the GraphQL documentation [here](https://graphql.org/learn/introspection/).
  """

  @behaviour Plug
  import Plug.Conn

  alias Vigil.LogFormatter
  alias Vigil.Query
  alias Vigil.Sanitizer
  alias Vigil.Token

  @type token :: binary() | mfa()

  @spec init(allow_introspection: boolean(), log_level: Logger.level(), token: token()) :: map()
  def init(opts) do
    Enum.into(opts, %{allow_introspection: false, log_level: :debug})
  end

  @spec call(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def call(%Plug.Conn{} = conn, %{allow_introspection: true}), do: conn

  # Perform all the checks, sanitization etc.
  def call(%Plug.Conn{} = conn, opts) do
    if Token.valid?(conn, opts[:token]) or Query.safe?(conn) do
      Plug.Conn.register_before_send(conn, &Sanitizer.sanitize_response(&1, opts))
    else
      forbid_connection(conn)
    end
  rescue
    e ->
      LogFormatter.log(conn, e, opts)
  end

  defp forbid_connection(%Plug.Conn{} = conn) do
    conn
    |> put_resp_content_type("application/json")
    |> resp(200, ~s({"errors": [{"message": "Forbidden request"}]}))
    |> halt()
  end
end
