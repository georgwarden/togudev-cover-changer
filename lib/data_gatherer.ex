defmodule DataGatherer do
  use GenServer

  def start(state) do
    start_link(state, [])
  end

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(msg, state) do
    gather_likes_on_last_n_posts 100
    {:noreply, state}
  end

  def gather_likes_on_last_n_posts(number) do
    group_id = "" #TODO
    link = RequestBuilder.get_last_n_posts group_id, number
    HTTPoison.post
  end

end