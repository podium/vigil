defmodule Vigil.MixProject do
  use Mix.Project

  def project do
    [
      app: :vigil,
      version: "0.4.4",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/podium/vigil",
      test_coverage: [summary: [threshold: 70]],
      description: description(),
      package: package()
    ]
  end

  defp package do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "vigil",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/podium/vigil"}
    ]
  end

  defp description do
    "Disable introspection and exfiltration of GraphQL schemas"
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: :dev, runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:jason, "~> 1.2"},
      {:plug, "~> 1.12"}
    ]
  end
end
