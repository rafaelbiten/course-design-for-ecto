defmodule Tome.MixProject do
  use Mix.Project

  def project do
    [
      app: :tome,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      preferred_cli_env: [
        check: :test,
        check_all: :test,
        test_setup: :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Tome.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.8"},
      {:poison, "~> 5.0"},
      {:postgrex, "~> 0.16.3"}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp aliases do
    [
      get: ["deps.get", "deps.compile"],
      check: ["dialyzer  --format dialyxir", "credo --strict"],
      check_all: ["dialyzer  --format short", "credo --strict", "test"],
      test_setup: ["ecto.create --quiet", "ecto.migrate --quiet", "run priv/repo/seeds/books.exs"],
      test: ["test_setup", "test"]
    ]
  end
end
