defmodule Flagger.MixProject do
  use Mix.Project

  def project do
    [
      app: :flagger,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Flagger.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Discord bot libraries
      {:nosedrum, "~> 0.4"},
      {:nostrum, "~> 0.4.6"},

      # Key-value database
      {:cubdb, "~> 2.0"},

      # Other
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.8.0"},
      {:nimble_parsec, "~> 1.2"}
    ]
  end
end
