defmodule Vigil.Query do
  @moduledoc """
  Utilities for determining whether GraphQL query strings are introspection queries.
  """

  @doc """
  When passed a connection of the type Plug.Conn.t(), parses out the "query" key from the
  :body_params or :query_params of the conn and returns true if the query is not a GraphQL
  introspection query.

  Reserved GraphQL introspection query strings are defined [here](https://graphql.org/learn/introspection/).
  """
  @spec safe?(conn :: Plug.Conn.t()) :: boolean()
  def safe?(%Plug.Conn{} = conn) do
    case graphql_query_string(conn) do
      {:ok, query_string} -> not has_introspection_type?(query_string)
      {:error, _} -> false
    end
  end

  def safe?(_conn), do: false

  # Parse out the GraphQL query string from a plug connection.
  @spec graphql_query_string(Plug.Conn.t()) :: {atom(), String.t()}
  ## POST
  defp graphql_query_string(%Plug.Conn{body_params: %{"query" => query_string}}),
    do: {:ok, query_string}

  ## GET
  defp graphql_query_string(%Plug.Conn{query_params: %{"query" => query_string}}),
    do: {:ok, query_string}

  ## ???
  defp graphql_query_string(_conn), do: {:error, "no query string found"}

  # Matches any string that contains a reserved GraphQL introspection query string
  @spec has_introspection_type?(query_string :: String.t()) :: boolean()
  defp has_introspection_type?(query_string) do
    Regex.match?(
      ~r/\b(__schema|__type|__typekind|__field|__inputvalue|__enumvalue|__directive)\b/i,
      query_string
    )
  end
end
