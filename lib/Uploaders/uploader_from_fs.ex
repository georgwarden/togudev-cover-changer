defimpl Uploaders.Uploader, for: String do
    use Utils.CredsAware
    require Logger

    @base_url "https://api.vk.com/method/"
    @get_upload_url "#{@base_url}photo.getOwnerCoverPhotoUploadServer?"
    @upload_confirm_url "#{@base_url}photo.saveOwnerCoverPhoto?"

    def upload(path_to_file) do
        {group_id, api_key} = get_group_creds()
        upload_url = get_upload_url group_id, api_key
        {hash, photo} = upload path_to_file, upload_url
        confirm hash, photo
    end

    defp get_upload_url(group_id, api_key) do
        request_url = upload_target_form_url group_id, api_key
        case HTTPoison.get(request_url) do
            {:ok, %HTTPoison.Response{body: body}} -> upload_target_parse_response body
            {:error, error} -> Logger.error "Unable to process request at UploaderFromFs to fetch upload_url"
        end
    end

    @spec upload_target_form_url(integer(), String.t()) :: String.t()
    def upload_target_form_url(group_id, api_key) do
        "#{@get_upload_url}owner_id=#{group_id}&access_token=#{api_key}"
    end

    @spec upload_target_parse_response(String.t()) :: String.t()
    def upload_target_parse_response(resp_body) do
        ExJSON.parse(resp_body, :to_map)
        |> Map.get("response")
        |> Map.get("upload_url")
    end

    defp upload(path_to_file, upload_url) do
        form = {:file, path_to_file}
        body = upload_form_body(form)
        case HTTPoison.post(upload_url, body) do
            {:ok, %HTTPoison.Response{body: body}} -> IO.puts "Successful"
            {:error, error} -> Log.error "Error uploading file: #{inspect error}"
        end
    end

    @spec upload_form_body({atom(), String.t()}) :: String.t()
    def upload_form_body(form) do
        body = %{"photo" => {:multipart, form}}
        ExJSON.generate(body)
    end

    @spec upload_parse_response(String.t()) :: {String.t(), String.t()}
    def upload_parse_response(resp_body) do
        body = ExJSON.parse(resp_body, :to_map)
        {Map.get(body, "hash"), Map.get(body, "photo")}
    end

    defp confirm(hash, photo) do
        body = confirm_form_body hash, photo
        case HTTPoison.post(@upload_confirm_url, body) do
            {:ok, _} -> Logger.info("Succesful upload")
            {:error, _} -> Logger.info("Failed upload on confirmation")
        end
    end

    def confirm_form_body(hash, photo) do
        ExJSON.generate({hash, photo})
    end

end