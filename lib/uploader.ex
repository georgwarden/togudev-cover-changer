defmodule Uploader do
  use GenServer

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_call(_msg, _from, state) do
    :timer.sleep(10 * 60 * 1000)
    api_key = "" #stub
    group_id = "" #stub
    upload_address_request = RequestBuilder.get_upload_link(api_key, group_id, 1590, 400)
    upload_address = HTTPoison.get(upload_address_request)
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end