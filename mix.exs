defmodule X.Mixfile do
  use Mix.Project

  def project do
    [app: :x,
     version: "0.1.0",
     elixir: "~> 1.4",
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {X, []}]
  end

  defp deps do
    [{:gen_stage, "~> 1.0"}]
  end
end
