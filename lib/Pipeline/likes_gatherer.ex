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
        user_ids = Enum.uniq raw_likes
        for user_id <- user_ids do
            count = Enum.filter(raw_likes, fn like_owner -> like_owner == user_id)
            |> Enum.count()
            {user_id, count}
        end
    end

    @spec get_last_100_posts() :: [number]
    defp get_last_100_posts() do
        {group_id, api_key} = get_group_creds
        req_url = "#{@base_url}wall.get?owner_id=-#{group_id}&count=100"
        case HTTPoison.get req_url do
            {:ok, %HTTPoison.Response{body: body}} -> 
                ExJSON.parse(body, :to_map)
                |> Map.get("response")
                |> Map.get("items")
                |> List.map(fn post -> Map.get(post, "id"))
            {:error, error} -> IO.inspect error
        end

    end
    
    @spec get_liking_users({number, string}) :: [number]
    defp get_liking_users(post) do
        
    end

end