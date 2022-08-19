defmodule Vigil.Sanitizer do
  @moduledoc """
  This module provides a callback to be used in the `Plug.Conn.register_before_send/1` function.
  It checks whether the connection contains an errored response from the GraphQL API.
  If it does, the repsponse is sanitized into a generic HTTP response before it is returned to the user.
  """

  alias Vigil.LogFormatter

  @json_parse_error_msg "Possible JSON Parse Error"

  defmodule Error do
    @moduledoc false

    @type t :: %__MODULE__{
            original: binary() | nil,
            sanitized: binary() | nil,
            keep_meta?: boolean()
          }

    defstruct keep_meta?: true, original: nil, sanitized: nil
  end

  @doc """
  Takes in a %Plug.Conn{} and if it has sensitive GraphQL errors, sanitize them before continuing
  with the remainder of the pipeline.

  If an exception occurs, this isn't worth crashing for. Return the connection unchanged, and log what happened.

  As a note, the call function in the root of this project provides a similar general try/rescue,
  but it is bypassed when this function is used as a callback with the Plug.Conn.register_before_send/1 function.
  Therefore it becomes necessary to include another general try catch here to prevent exceptions
  from bubbling up to the remainder of the pipeline.
  """
  @spec sanitize_response(conn :: Plug.Conn.t(), opts :: map()) :: Plug.Conn.t()
  def sanitize_response(%Plug.Conn{} = conn, opts) do
    body = Jason.decode!(conn.resp_body)

    case get_error(body) do
      %Error{} = error ->
        LogFormatter.log(conn, error.original, opts)
        response = body |> replace_body_errors(error) |> Jason.encode!()

        %{conn | resp_body: response}

      _ ->
        conn
    end
  rescue
    _ in Jason.DecodeError ->
      LogFormatter.log(conn, @json_parse_error_msg, opts)
      conn

    e ->
      LogFormatter.log(conn, e, opts)
      conn
  end

  def sanitize_response(not_a_conn, _opts), do: not_a_conn

  ##
  # Private Functions
  #

  defp get_error(%{"errors" => [%{"message" => error} | _]}) do
    cond do
      # errors related to arguments
      Regex.match?(~r/In argument.*/i, error) ->
        # Don't give any information about arguments
        %Error{original: error, sanitized: "Bad Request", keep_meta?: false}

      # errors with suggestions
      Regex.match?(~r/.*Did you mean.*/i, error) ->
        %Error{original: error, sanitized: sanitize_error(error, ~r/Did you mean.*/i)}

      # non-existent errors
      Regex.match?(~r/.*Cannot query field.*on type.*/i, error) ->
        # Couldn't find the type, but there was no sensitive data in the response. No cleaning neccesary
        %Error{original: error, sanitized: error}

      true ->
        nil
    end
  end

  defp get_error(_), do: nil

  defp sanitize_error(error, pattern), do: error |> String.replace(pattern, "") |> String.trim()

  defp replace_body_errors(%{"errors" => _} = body, %{keep_meta?: false} = error) do
    Map.put(body, "errors", [%{"message" => error.sanitized}])
  end

  defp replace_body_errors(%{"errors" => [error_object | _]} = body, %Error{sanitized: sanitized}) do
    error_object = Map.put(error_object, "message", sanitized)
    Map.put(body, "errors", [error_object])
  end

  defp replace_body_errors(body, _), do: body
end
