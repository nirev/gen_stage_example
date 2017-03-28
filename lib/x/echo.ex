defmodule X.Echo do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :whatever)
  end

  # Callbacks
  def init(state) do
    {:consumer, state, subscribe_to: [X.Numbers]}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      IO.inspect {self(), event}
    end

    # Consumers don't emit events
    # but the return tuple is consistent
    events = []
    {:noreply, events, state}
  end
end
