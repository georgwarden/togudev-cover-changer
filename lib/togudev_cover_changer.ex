defmodule TogudevCoverChanger do
  use Application
  use Supervisor

  def start(_type, _args) do
    children = [
      %{id: UploadUrlBuilder, start: {UploadUrlBuilder, :start_link, [[]]}}
    ]
    Supervisor.start_link(children, [strategy: :one_for_one])
  end

end
