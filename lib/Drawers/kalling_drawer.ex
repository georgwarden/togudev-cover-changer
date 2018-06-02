defmodule Drawers.KallingDrawer do

    def real_draw(data) do
        args = Enum.map data, fn user_and_likes -> Integer.to_string(elem(user_and_likes, 0)) <> Integer.to_string(elem(user_and_likes, 1)) end
        System.cmd "java", ["-jar" | args]
    end

end