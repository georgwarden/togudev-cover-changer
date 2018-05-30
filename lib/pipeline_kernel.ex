defmodule PipelineKernel do

  def initial_stage() do
    likes = Pipeline.LikesGatherer.gather_likes
    reposts = %{}
    commentaries = %{}
    assemble_likes(likes)
    assemble_reposts(reposts)
    assemble_commentaries(commentaries)
  end

  def assemble_likes(data) do
    GenServer.cast Assembler, {:likes, data}
  end

  def assemble_reposts(data) do
    GenServer.cast Assembler, {:reposts, data}
  end

  def assemble_commentaries(data) do
    GenServer.cast Assembler, {:commentaries, data}
  end

  def draw(data) do
    Pipeline.Drawer.draw data
  end

  def upload(image) do
    Uploader.upload(image)
  end

end
