defmodule UploadUrlBuilder do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: UploadUrlBuilder)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    api_key = "" #stub
    group_id = "" #stub
    upload_address_request = RequestBuilder.get_upload_link api_key, group_id, 1590, 400
    [{_, upload_url}] = HTTPoison.get(upload_address_request) |> ExJSON.parse upload_address_request |> Enum.find(&(elem(&1, 0) == "response")) |> elem(1)
    GenServer.cast DataGatherer, upload_url
    {:noreply, state}
  end
end