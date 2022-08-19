# Vigil

Vigil disallows introspection queries on your GraphQL API and prevents data exfiltration via GraphQL error messages.

## Installation

This package can be installed from hex by adding `vigil` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:vigil, "~> 0.4.4"}
  ]
end
```

Then it can be used by adding:

```elixir
plug Vigil
```

to a pipeline covering a GraphQL service.

## What does Vigil do?

- Drops all introspection requests
- Sanitizes data returned from malformed requests (to avoid techniques such as the one used in [this tool](https://github.com/nikitastupin/clairvoyance))

### Introspection Requests

Malicious users often begin the reconnissance phase of an attack against a GraphQL service by obtaining as much information about the schema as possible. The easiest way to do that is through introspection with a query similar to this one:

```graphql
query IntrospectionQuery {
  __schema {
    queryType {
      name
      fields {
        fieldName: name
        type {
          fieldType: kind
          subFields: fields {
            name
            type {
              subFieldType: kind
            }
          }
        }
        args {
          argName: name
        }
      }
    }
  }
}
```

This will return a list of fields in the schema as well as other information about them. Currently Absinthe has no configuration option to disable this feature, so it is always available in production.

The `plug Vigil` portion of the pipeline case-insensitively catches any requests that contain keywords related to GraphQL introspection and sends that request back with a generic `{errors: [message: "Forbidden"]}`. Notably, this does not reflect the status of the HTTP response, which for a GraphQL service is almost always `200 OK`.

### Error Sanitization

Once introspection is disabled, an attacker needs to turn to other sources to obtain detailed schema information. One way of doing this is by performing a dictionary attack against a schema and using fields or arguments that do not exist. By default, Absinthe makes helpful suggestions about a best guess as to what the user meant. While this is well intentioned, it can be abused by an attacker through tools like [this one](https://github.com/nikitastupin/clairvoyance).

The `plug Vigil` portion of your pipeline will catch any returning requests that contain errors and examine them for commonly leaked schema data. If found, the data will be scrubbed to keep it looking like a regular GraphQL error, minus the sensitive information about the schema.

## FAQ

#### What if I need to bypass Vigil?

A developer may wish to enable introspection for development purposes (or to allow internal services to consume schema information). In which case you should include the `:token` option when initializing
the plug. You can do this by setting the value in your config file:

```elixir
config :vigil, token: System.get_env("INTROSPECTION_TOKEN")
```

(The name of the env var INTROSPECTION_TOKEN is arbitrary. Obviously if the value is stored under a different name in your service update it accordingly.)

If you need to add `Vigil` to multiple pipelines, and you want each one to have their own token, a `:token` parameter may be passed as an MFA when adding the plug to your pipeline.
For example, to pull the token out of your config, you would do:

```elixir
plug Vigil, token: {Application, :get_env, [:my_app, :public_api_introspection_token]}
# Elsewhere
plug Vigil, token: {Application, :get_env, [:my_app, :private_api_introspection_token]}
```

Once the configuration has been updated, the header `introspection-token` can be sent along with a GraphQL request, as long as the value of the header matches introspection will function normally.

#### Vigil is generating a ton of log messages, can I make that stop?

In a recent version of Vigil the [log level](https://hexdocs.pm/logger/1.13.4/Logger.html#module-levels) has been turned down to the lowest level (`:debug`) in order to prevent generating noise. The first thing you should do is update to a recent version. It is also possible to configure the application manually by passing the `:log_level` to the plug options:

```elixir
    plug Vigil, log_level: :info
```

## Contributors
- [Alex Larsen](https://github.com/alex0112)
- [Emma Hoggan](https://github.com/emmahoggan)
- [Andrew Rosa]()
- [Trevor Fenn](https://github.com/sgtpepper43)
