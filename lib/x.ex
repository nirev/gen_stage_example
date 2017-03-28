defmodule X do
  @moduledoc "A simple GenStage example"

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    producers = [
      worker(X.Numbers, [0])
    ]

    consumers = [
      worker(X.Echo, [])
    ]

    opts = [strategy: :one_for_one, name: X.Supervisor]
    Supervisor.start_link(producers ++ consumers, opts)
  end
end