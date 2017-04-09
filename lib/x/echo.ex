defmodule X.Echo do
  use GenStage

  def start_link(color) do
    GenStage.start_link(__MODULE__, color)
  end

  # Callbacks
  def init(color) do
    {:consumer, color,
     subscribe_to: [{X.Numbers, min_demand: 5, max_demand: 10}]}
  end

  def handle_events(events, _from, color) do
    for event <- events do
      {self(), event}
      |> inspect()
      |> print(color)
    end

    # Consumers don't emit events
    # but the return tuple is consistent
    events = []
    {:noreply, events, color}
  end

  defp print(text, color) do
    IO.puts color <> text <> IO.ANSI.default_color <> IO.ANSI.default_background
  end
end
