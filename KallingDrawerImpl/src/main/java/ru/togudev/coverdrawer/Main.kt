package ru.togudev.coverdrawer

import org.json.JSONArray
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import ru.togudev.coverdrawer.api.UserProfilesService
import java.awt.Color
import java.awt.Font
import java.awt.Graphics2D
import java.awt.geom.Ellipse2D
import java.awt.image.BufferedImage
import java.io.File
import java.net.URL
import java.util.*
import javax.imageio.ImageIO

fun main(args: Array<String>) {

    val top = JSONArray(args[0])

    val top1 = top.getJSONObject(0)
    val top2 = top.getJSONObject(1)
    val top3 = top.getJSONObject(2)

    val baseImage = BaseImageLoader().load()
    val newImage = BufferedImage(795, 200, BufferedImage.TYPE_INT_ARGB)
    val drawer = newImage.graphics as Graphics2D

    val retrofit = Retrofit.Builder().baseUrl("https://api.vk.com/method/").addConverterFactory(GsonConverterFactory.create()).build()
    val service = retrofit.create(UserProfilesService::class.java)

    val token = object{}.javaClass.classLoader.getResourceAsStream("api_key.txt").let { Scanner(it) }.nextLine()
    val response = service
            .getProfiles(token, "${top1.getInt("id")},${top2.getInt("id")},${top3.getInt("id")}")
            .execute()
            .takeIf { it.isSuccessful }
            ?.body()
            ?: throw Exception("Unsuccessful request")
    val users = response.response

    val clip = { image: BufferedImage ->
        val graphics = image.graphics as Graphics2D
        val shape = Ellipse2D.Float()
        shape.setFrame(0f, 0f, 50f, 50f)
        graphics.clip(shape)
    }
    val pfp1 = users[0].photo_50.let { ImageIO.read(URL(it)) }.apply(clip)
    val pfp2 = users[1].photo_50.let { ImageIO.read(URL(it)) }.apply(clip)
    val pfp3 = users[2].photo_50.let { ImageIO.read(URL(it)) }.apply(clip)

    //text; pfp; top-text; top-pfp
    //vertical
    //200 - 47; 200 - 63; 23; 12
    //200 - 107; 200 - 126; 90; 75
    //200 - 171; 200 - 190; 154; 138

    //horizontal
    //795 - 693; 795 - 730

    drawer.drawImage(baseImage, 0, 0, null)
    drawer.drawImage(pfp1, 730, 12, null)
    drawer.drawImage(pfp2, 730, 75, null)
    drawer.drawImage(pfp3, 730, 138, null)

    drawer.font = Font("Ubuntu", Font.PLAIN, 24)
    drawer.color = Color.decode("#C5D3E2")
    drawer.drawString(top1.getInt("likes").toString(), 693, 63 - 18)
    drawer.drawString(top2.getInt("likes").toString(), 693, 126 - 18)
    drawer.drawString(top3.getInt("likes").toString(), 693, 190 - 18)

    ImageIO.write(newImage, "png", File(args[1]))

}