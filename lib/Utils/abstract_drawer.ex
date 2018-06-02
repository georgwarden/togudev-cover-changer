defmodule Utils.AbstractDrawer do
    import Drawers.KallingDrawer

    defmacro __using__(_) do
        quote do
            def abstract_draw(data) do
                real_draw(data)
            end
        end
    end

end