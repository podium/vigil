defmodule Vigil.LogFormatter do
  @moduledoc """
  A specialized log formatter for Vigil
  """
  require Logger

  @doc """
  This function is intended to be used throughout the plug (including in callbacks) to log any
  exceptions as they occur.

  It is neccessary to abstract this away into its own function because the sanitize module will be
  called outside of the general try/rescue at the root of the plug, because it is implemented as a
  callback.

  This function allows us to have the same logging schema accross the entire plug, even though we
  can't make guarantees about when certain modules will be called or in what context.
  """
  @spec log(conn :: Plug.Conn.t(), errors :: term(), opts :: keyword() | map()) :: :ok
  def log(conn, errors \\ nil, opts) do
    opts
    |> Access.get(:log_level, :debug)
    |> Logger.log(format(conn, errors))
  end

  defp format(%Plug.Conn{} = conn, errors) do
    inspect(%{
      logger: :vigil,
      error: errors,
      body: conn.resp_body,
      host: conn.host,
      method: conn.method,
      path_info: conn.path_info
    })
  end
end
