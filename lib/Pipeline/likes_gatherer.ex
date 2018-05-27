defmodule Pipeline.LikesGatherer do
    use Utils.CredsAware
    
    @base_url "https://api.vk.com/method/"

    @doc """
    Returns a map which associates user_id to number of likes this user made
    """
    @spec gather_likes() :: %{number => number}
    def gather_likes() do
        
    end

    defp get_last_100_posts() do

        url = "#{@base_url}wall.get?#{Application.get_env(:togudev_cover_changer, )}"
    end

    defp get_count() do
        req_url = "#{@base_url}"
    end

end