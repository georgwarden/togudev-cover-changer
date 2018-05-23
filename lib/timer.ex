defmodule Timer do
  use GenServer

  def start(state) do
    start_link(state, [])
  end

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(_opts) do
    tick
    {:ok, %{}}
  end

  def handle_call(:its_about_time, _from, state) do
    GenServer.cast UploadUrlBuilder, []
    tick
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def tick() do
    Process.send_after self(), 10 * 60 * 1000, :its_about_time
  end

end