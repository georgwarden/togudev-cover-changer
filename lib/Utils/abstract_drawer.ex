defmodule Utils.AbstractDrawer do
    use Drawers.KallingDrawer

    defmacro __using__() do
        quote do
            def abstract_draw(data) do
                real_draw(data)
            end
        end
    end

end