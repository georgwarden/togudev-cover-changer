defmodule Utils.CredsAware do
    
    defmacro __using__(_) do
        quote do

            def get_group_creds() do
                {
                    Application.get_env(:togudev_cover_changer, :group_id),
                    Application.get_env(:togudev_cover_changer, :api_key)
                }
            end

            def get_service_key() do
                Application.get_env(:togudev_cover_changer, :service_key)
            end
        
        end
    end

end