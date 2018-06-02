defimpl Uploaders.Uploader, for: String do
    use Utils.CredsAware
    require Logger

    @base_url "https://api.vk.com/method/"
    @get_upload_url "#{@base_url}photo.???" # TODO
    @upload_confirm_url "#{@base_url}photo???" # TODO

    def upload(path_to_file) do
        {group_id, api_key} = get_group_creds()

    end

    defp get_upload_url(group_id, api_key) do
        case HTTPoison.get("#{@get_upload_url}owner_id=#{group_id}") do
            {:ok, %HTTPoison.Response{body: body}} ->
                ExJSON.parse(body, :to_map)
                |> Map.get("response")
                |> Map.get("upload_url") # TODO
            {:error, error} -> Logger.error "Unable to process request at UploaderFromFs to fetch upload_url"
        end
    end


end