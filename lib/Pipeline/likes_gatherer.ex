defmodule Pipeline.LikesGatherer do
    use Utils.CredsAware
    
    @base_url "https://api.vk.com/method/"

    @doc """
    Returns a map which associates user_id to number of likes this user made
    """
    @spec gather_likes() :: %{number => number}
    def gather_likes() do
        posts = get_last_100_posts
        raw_likes = posts |> Enum.map(&get_liking_users/1) # [post] to [[user_id]]
        user_ids = Enum.dedup raw_likes
        for user_id <- user_ids do
            count = Enum.filter(raw_likes, fn like_owner -> like_owner == user_id)
            |> Enum.count()
            {user_id, count}
        end
    end

    defp get_last_100_posts() do
        
    end
    
    @spec get_liking_users({number, string}) :: [number]
    defp get_liking_users(post) do
        
    end

end