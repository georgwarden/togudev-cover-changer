defmodule Pipeline.LikesGatherer do
    use Utils.CredsAware
    require Logger
    
    @base_url "https://api.vk.com/method/"

    @doc """
    Returns a map which associates user_id to number of likes this user made
    """
    @spec gather_likes() :: %{optional(integer()) => integer()}
    def gather_likes() do
        posts = get_last_100_posts
        raw_likes = posts |> Enum.map(&get_liking_users/1) # [post] to [[user_id]]
        aggregate_user_likes raw_likes
    end

    @doc """
    Transforms a list of VK user id duplicates into a map user_id => number of likes

    iex> aggregate_user_likes([134, 425, 712, 134, 134, 712])
    %{134 => 3, 425 => 1, 712 => 2}
    """
    @spec aggregate_user_likes([integer()]) :: %{optional(integer()) => integer()}
    defp aggregate_user_likes(raw_likes) do
        user_ids = Enum.uniq raw_likes
        for user_id <- user_ids do
            count = Enum.filter(raw_likes, fn like_owner -> like_owner == user_id)
            |> Enum.count()
            {user_id, count}
        end
    end

    @spec get_last_100_posts() :: [integer()]
    defp get_last_100_posts() do
        {group_id, _} = get_group_creds
        service_key = get_service_key
        req_url = posts_form_url group_id, service_key
        case HTTPoison.get req_url do
            {:ok, %HTTPoison.Response{body: body}} -> posts_parse_response body
            {:error, error} -> Logger.error("Error getting posts in LikesGatherer: #{inspect error}")
        end

    end
    
    @doc """
    Creates a proper url to refer to in order to fetch group posts

    iex>posts_form_url(45866814, "thisistotallykey")
    "https://api.vk.com/method/wall.get?owner_id=-45866814&count=100&access_token=thisistotallykey"
    """
    @spec posts_form_url(integer(), bitstring()) :: bitstring()
    defp posts_form_url(group_id, service_key) do
        "#{@base_url}wall.get?owner_id=-#{group_id}&count=100&access_token=#{service_key}"
    end

    @doc """
    Parses a response from VK API and extracts all posts id from it

    I'll write a proper doctest for it some day.
    """
    @spec posts_parse_response(bitstring()) :: [integer()]
    defp posts_parse_response(resp_body) do
        ExJSON.parse(resp_body, :to_map)
                |> Map.get("response")
                |> Map.get("items")
                |> List.map(fn post -> Map.get(post, "id"))
    end

    @spec get_liking_users({number, string}) :: [number]
    defp get_liking_users(post) do
        {group_id, _} = get_group_creds
        service_key = get_service_key
        likes_base_url = likes_form_url group_id, service_key

        count_likes_url = "#{likes_base_url}&count=0"
        count = case HTTPoison.get(count_likes_url) do
            {:ok, %HTTPoison.Response{body: body}} -> likes_parse_response body
            {:error, error} -> Logger.error("Error getting likes on a particular post: #{inspect error}")
        end
        LikesFromPost.get_all count, likes_base_url
    end

    @doc """
    Same to `Pipeline.LikesGatherer.posts_form_url/2`.
    """
    @spec likes_form_url(integer(), bitstring()) :: bitstring()
    defp likes_form_url(group_id, api_key) do
        "#{@base_url}likes.getList?type=post&owner_id=-#{group_id}&access_token=#{api_key}"
    end

    @doc """
    Same as `Pipeline.LikesGatherer.posts_parse_response/1`.
    """
    @spec likes_count_parse_response(bitstring()) :: integer()
    defp likes_count_parse_response(resp_body) do
        ExJSON.parse(body, :to_map) 
                |> Map.get("response")
                |> Map.get("count")
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