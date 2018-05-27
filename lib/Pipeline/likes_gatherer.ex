defmodule Pipeline.LikesGatherer do
    
    @base_url "https://api.vk.com/method/"

    @doc """
    Returns a map which associates user_id to number of likes this user made
    """
    @spec gather_likes() :: %{number => number}
    def gather_likes() do
        
    end

    

    defp get_count() do
        req_url = "#{@base_url}"
    end

end