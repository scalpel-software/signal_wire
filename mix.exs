defmodule SignalWire.MixProject do
  use Mix.Project

  @source_url "https://github.com/scalpel-software/signal_wire"
  @version "0.1.1"

  def project do
    [
      app: :signal_wire,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs()
    ]
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
      {:tesla, "~> 1.12"},
      {:jason, "~> 1.4"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do 
    [
      description: "An unofficial Signal Wire API library for elixir",
      maintainers: ["tomciopp"],
      licenses: ["MIT"],
      links: %{
        "Github" => @source_url
      }
    ]
  end

  defp docs do 
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "#v{@version}",
      formatters: ["html"]
    ]
  end
end
