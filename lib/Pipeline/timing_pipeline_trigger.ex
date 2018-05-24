defmodule Pipeline.TimingPipelineTrigger do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: Trigger])
  end

  def init(_opts) do
    tick
    {:ok, %{}}
  end

  def handle_call(:trigger, _from, state) do
    PipelineKernel.initial_stage
    tick
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def tick() do
    Process.send_after self(), :trigger, 10 * 60 * 1000
  end

end