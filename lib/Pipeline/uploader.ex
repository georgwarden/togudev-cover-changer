defmodule Pipeline.Uploader do
    alias Uploaders.Uploader, as: Up

    def upload(object_representation) do
        Up.upload(object_representation)
    end

end