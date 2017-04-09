defmodule X.Mul do
  use GenStage

  def start_link(factor) do
    GenStage.start_link(__MODULE__, factor,
      name: :"mul#{factor}") # names have to be unique!
  end

  # Callbacks
  def init(factor) do
    opts = [subscribe_to: [{X.Numbers, max_demand: 10}]]
    {:producer_consumer, factor, opts}
  end

  def handle_events(events, _from, factor) do
    events = Enum.map(events, & {&1, &1 * factor})
    {:noreply, events, factor}
  end
end
