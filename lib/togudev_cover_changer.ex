defmodule TogudevCoverChanger do
  use Application
  use Supervisor

  def start(_type, _args) do
    children = [
      %{id: Uploader, start: {Uploader, :start_link,[[]]}}
    ]
    Supervisor.start_link(children, [strategy: :one_to_one])
  end

end
