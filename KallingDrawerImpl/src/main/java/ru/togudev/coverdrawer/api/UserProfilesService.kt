package ru.togudev.coverdrawer.api

import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Query

interface UserProfilesService {

    @GET("users.get?fields=photo_50&v=5.78")
    fun getProfiles(@Query("access_token") key: String, @Query("user_ids") ids: String): Call<Response>

}