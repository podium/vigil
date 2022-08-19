## [0.4.4] - 2022-06-16

- Added `Introspection-Token` as valid header (`X-Introspection-Token` will still work for backwards compatibility, but is not preferred)
- Added ability to set introspection token when adding plug to pipeline via the `:token` parameter as an MFA
- Removed some unecessary debug logs
- Some error messages changed
- Internal refactors

## [0.4.3] - 2022-05-25

- Removed JSON encoding of errors, now log plain maps handed to `Kernel.inspect`

## [0.4.2] - 2022-05-11

### Fixed

- Handle exceptions formatting logs as JSON

## [0.4.1] - 2022-04-01

### Changed

- Log expected service error as debug unless to reduce log volume in prod by default

## [0.4.0] - 2022-03-29

### Changed

WARNING: This is a breaking change. Before update read the new steps
to configure the library in the README or bellow:

- add the following in your `config.exs` in order to bypass introspection
  ```
  config :vigil,
    token: System.get_env("INTROSPECTION_TOKEN")
  ```
  (The name of the env var `INTROSPECTION_TOKEN` is convention. Obviously if the value is stored under
  a different name in your service update it accordingly)
- Internal code refactoring and cleaning
- Converts :warnings into :debug
- Improve warnings message with original error

## [0.3.5] - 2021-12-15

### Changed

- Removed logging information of full connection struct to prevent leakage of sensitive data in logs.

## [0.3.4] - 2021-12-8

### Changed

- Improved Logging and Exception Handling
- Scenario where known crash occured now prevented and/or logged.

## [0.3.3] - 2021-11-18

### Changed

- Fixed bug where options were not being processed correctly
- Added sanity checks in the unit tests for `call/2` and `init/1`

## [0.3.2] - 2021-11-18

### Changed

- Improved generalized exception handling
- Log levels now default to `:warning` instead of `:error`
- Log level can now be configured in plug options

## [0.3.1] - 2021-11-17

### Changed

- Change dependency from plug_cowboy to plug
- Change dependency from poison to jason
