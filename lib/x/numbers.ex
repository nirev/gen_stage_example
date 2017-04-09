defmodule X.Numbers do
  use GenStage

  def start_link(state) do
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  # Callbacks
  def init(state) do
    opts = [dispatcher: GenStage.BroadcastDispatcher,
            demand: :accumulate]
    {:producer, state, opts}
  end

  def handle_demand(demand, state) do
    events = Enum.to_list(state..state+demand-1)
    new_state = state + demand

    # sleep just so we can see whats happening
    :timer.sleep(1000)
    {:noreply, events, new_state}
  end
end
