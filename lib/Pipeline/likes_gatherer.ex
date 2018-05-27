defmodule Pipeline.LikesGatherer do
    use Utils.CredsAware
    require Logger
    
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
        {group_id, _} = get_group_creds
        req_url = "#{@base_url}wall.get?owner_id=-#{group_id}&count=100"
        case HTTPoison.get req_url do
            {:ok, %HTTPoison.Response{body: body}} -> 
                ExJSON.parse(body, :to_map)
                |> Map.get("response")
                |> Map.get("items")
                |> List.map(fn post -> Map.get(post, "id"))
            {:error, error} -> Logger.error("Error getting posts in LikesGatherer: #{inspect error}")
        end

    end
    
    @spec get_liking_users({number, string}) :: [number]
    defp get_liking_users(post) do
        {group_id, _} = get_group_creds
        likes_base_url = "#{@base_url}likes.getList?type=post&owner_id=-#{group_id}"

        count_likes_url = "#{likes_base_url}&count=0"
        count = case HTTPoison.get(count_likes_url) do
            {:ok, %HTTPoison.Response{body: body}} -> 
                ExJSON.parse(body, :to_map) 
                |> Map.get("response")
                |> Map.get("count")
            {:error, error} -> Logger.error("Error getting likes on a particular post: #{inspect error}")
        end
        LikesFromPost.get_all count, likes_base_url
    end

    defmodule LikesFromPost do
        
        def get_all!(count, base_url) do
            get([], count, base_url)
        end

        def get(accumulator, 0, _, _) do
            accumulator
        end

        def get!(accumulator, rest_n, total_count, base_url) do
            taken = if rest_n >= 100, do: 100, else: rest_n
            url = "#{base_url}&count=#{taken}&offset=#{total_count - rest_n}"
            case HTTPoison.get(url) do
                {:ok, %HTTPoison.Response{body: body}} ->
                    ExJSON.parse(body, :to_map)
                    |> Map.get("response")
                    |> Map.get("items")
                    |> Kernel.++(accumulator)
                    |> get(rest_n - taken, total_count, base_url)
                {:error, error} -> raise "could not iterate over likes on a post"
        end

    end

end