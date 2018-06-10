package ru.togudev.coverdrawer

import org.json.JSONArray
import retrofit2.Retrofit
import ru.togudev.coverdrawer.api.UserProfilesService
import java.awt.geom.Ellipse2D
import java.awt.image.BufferedImage
import java.io.File
import java.net.URL
import javax.imageio.ImageIO

fun main(args: Array<String>) {

    val top = JSONArray(args[0])

    val top1 = top.getJSONObject(0)
    val top2 = top.getJSONObject(1)
    val top3 = top.getJSONObject(2)

    val baseImage = BaseImageLoader().load()
    val drawer = baseImage.createGraphics()

    val retrofit = Retrofit.Builder().baseUrl("https://api.vk.com/method/").build()
    val service = retrofit.create(UserProfilesService::class.java)

    val response = service
            .getProfiles(top1.getInt("id"), top2.getInt("id"), top3.getInt("id"))
            .execute()
            .takeIf { it.isSuccessful }
            ?.body()
            ?: throw Exception("Unsuccessful request")
    val users = response.users

    val clip = { image: BufferedImage ->
        val graphics = image.createGraphics()
        val shape = Ellipse2D.Float(0f, 0f, 50f, 50f)
        graphics.clip(shape)
    }
    val pfp1 = users[0].photo50.let { ImageIO.read(URL(it)) }.apply(clip)
    val pfp2 = users[1].photo50.let { ImageIO.read(URL(it)) }.apply(clip)
    val pfp3 = users[2].photo50.let { ImageIO.read(URL(it)) }.apply(clip)

    //text; pfp; top-text; top-pfp
    //vertical
    //200 - 47; 200 - 63; 23; 12
    //200 - 107; 200 - 126; 90; 75
    //200 - 171; 200 - 190; 154; 138

    //horizontal
    //795 - 693; 795 - 730

    drawer.drawImage(pfp1, 12, 730, null)
    drawer.drawImage(pfp2, , 75, 730, null)
    drawer.drawImage(pfp3, 138, 730, null)

    ImageIO.write(baseImage, "png", File(args[1]))

}