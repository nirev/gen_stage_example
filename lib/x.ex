defmodule X do
  @moduledoc "A simple GenStage example"

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    producers = [
      worker(X.Numbers, [0]),
      worker(X.Mul, [2], id: :mul1),
      worker(X.Mul, [10], id: :mul2)
    ]

    # System.schedulers_online gives us the numbers of schedulers
    # as consumers may wait for IO or other stuff, this number * 2
    # seems like a good number of workers :)
    consumers =
      for id <- 1..(System.schedulers_online * 2) do
        worker(X.Echo, [color(id)], id: id)
      end

    opts = [strategy: :one_for_one, name: X.Supervisor]
    children = producers ++ consumers
    with {:ok, pid} <- Supervisor.start_link(children, opts),
         # this is done to synchronize consumers
         # see https://hexdocs.pm/gen_stage/GenStage.html#demand/2
         :ok <- GenStage.demand(X.Numbers, :forward) do
      {:ok, pid}
    end
  end

  defp color(id) do
    [ IO.ANSI.green,
      IO.ANSI.yellow,
      IO.ANSI.cyan,
      IO.ANSI.magenta,
      IO.ANSI.yellow_background <> IO.ANSI.black,
      IO.ANSI.yellow_background <> IO.ANSI.red,
      IO.ANSI.yellow_background <> IO.ANSI.magenta,
      IO.ANSI.yellow_background <> IO.ANSI.blue,
      IO.ANSI.white_background <> IO.ANSI.black,
      IO.ANSI.white_background <> IO.ANSI.red,
      IO.ANSI.white_background <> IO.ANSI.magenta,
      IO.ANSI.white_background <> IO.ANSI.blue,
    ] |> Enum.at(id - 1, IO.ANSI.default_color)
  end
end
