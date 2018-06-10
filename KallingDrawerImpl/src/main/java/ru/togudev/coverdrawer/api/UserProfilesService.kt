package ru.togudev.coverdrawer.api

import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Query

interface UserProfilesService {

    @GET("user.get?fields=photo_50")
    fun getProfiles(@Query("user_ids") vararg id: Int): Call<Response>

}