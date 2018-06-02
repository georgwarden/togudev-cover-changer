defmodule Pipeline.Assembler do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: Assembler])
  end

  def init(_opts) do
    {:ok, %{likes: :nil, reposts: :nil, commentaries: :nil}}
  end

  def handle_call(msg, from, state) do
    Logger.warn "Unexpected call in assembler: #{inspect msg} from #{inspect from}"
    {:reply, :ok, state}
  end

  def handle_cast(data, state) do
    new_state = case data do
      %{likes: likes} -> %{state | likes: likes}
      %{reposts: reposts} -> %{state | reposts: reposts}
      %{commentaries: commentaries} -> %{state | commentaries: commentaries}
      _ -> state; Logger.warn "Unexpected cast in assembler: #{inspect data}"
    end
    {_, new_state} = is_assemble_incomplete_or_next_stage_and_empty(data)
    {:noreply, new_state}
  end

  def is_assemble_incomplete_or_next_stage_and_empty(data) do
    if data.likes != :nil and data.reposts != :nil and data.commentaries != :nil do
      PipelineKernel.draw data
      {:complete, %{likes: :nil, reposts: :nil, commentaries: :nil}}
    else
      {:incomplete, data}
    end
  end

end