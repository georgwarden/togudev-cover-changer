package ru.togudev.coverdrawer

import javax.imageio.ImageIO
import java.awt.image.BufferedImage
import java.io.IOException

class BaseImageLoader {

    fun load(): BufferedImage = ImageIO.read(this.javaClass.classLoader.getResourceAsStream("base_image.png"))

}
