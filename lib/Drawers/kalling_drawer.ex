defmodule Drawers.KallingDrawer do

    def real_draw(data) do
        serialized = ExJSON.generate data
        trimmed = serialized |> String.replace(" ", "") |> String.replace("\n", "")
        System.cmd "java", ["-jar kallingdrawerimpl.jar" | trimmed]
    end

end