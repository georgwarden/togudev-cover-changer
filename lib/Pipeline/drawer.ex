defmodule Pipeline.Drawer do
    use Utils.AbstractDrawer

    def draw(data) do
        path_to_image = abstract_draw(data)
        PipelineKernel.upload(path_to_image)
    end

end