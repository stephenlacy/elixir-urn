defmodule URN.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :urn,
      version: @version,
      elixir: "~> 1.8",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "URN",
      description: description(),
      source_url: "https://github.com/stevelacy/elixir-urn",
      package: package(),
      homepage_url: "https://github.com/stevelacy/urn",
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Uniform Resource Name (URN) parsing and validation in Elixir"
  end

  defp package() do
    [
      licenses: ["MIT"],
      maintainers: ["Steve Lacy", "Matthew Johnston"],
      links: %{"Github" => "https://github.com/stevelacy/elixir-urn"}
    ]
  end

  defp docs() do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}",
      source_url: "https://github.com/stevelacy/elixir-urn"
    ]
  end
end
