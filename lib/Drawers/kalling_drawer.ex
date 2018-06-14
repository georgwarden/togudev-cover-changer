defmodule Drawers.KallingDrawer do

    def real_draw(data) do
        serialized = data
        |> Enum.map (fn pair -> %{id: elem(pair, 0), likes: elem(pair, 1)} end)
        |> ExJSON.generate()
        trimmed = serialized |> String.replace(" ", "") |> String.replace("\n", "")
        System.cmd "java", ("-jar kallingdrawerimpl.jar " <> trimmed <> " D:/George's/new_cover.png")
        "new_cover.png"
    end

end