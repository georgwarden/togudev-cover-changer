defmodule RequestBuilder do

  @base_url "https://api.vk.com/method/photos.getOwnerCoverPhotoUploadServer?"
  def get_upload_link(api_key, group_id, crop_x2, crop_y2) do
    "#{@base_url}group_id=#{group_id}&crop_x2=#{crop_x2}&crop_y2=#{crop_y2}&api_key=#{api_key}"
  end

end
