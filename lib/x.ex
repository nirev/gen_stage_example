defmodule X do
  @moduledoc "A simple GenStage example"

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    producers = [
      worker(X.Numbers, [0])
    ]

    consumers = [
      worker(X.Echo, [IO.ANSI.green], id: 1),
      worker(X.Echo, [IO.ANSI.yellow], id: 2)
    ]

    opts = [strategy: :one_for_one, name: X.Supervisor]
    with {:ok, pid} <- Supervisor.start_link(producers ++ consumers, opts),
         # this is done to synchronize consumers
         # see https://hexdocs.pm/gen_stage/GenStage.html#demand/2
         :ok <- GenStage.demand(X.Numbers, :forward) do
      {:ok, pid}
    end
  end
end
