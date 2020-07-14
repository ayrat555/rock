defmodule Rock.Mixfile do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :rock,
      version: "0.1.1",
      elixir: "~> 1.4",
      description: "ROCK: A Robust Clustering Algorithm for Categorical Attributes",
      package: [
        maintainers: ["Ayrat Badykov"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/ayrat555/rock"}
      ],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:elixir_uuid, "~> 1.2"},
      {:apex, "~> 1.2", only: [:dev, :test]},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
