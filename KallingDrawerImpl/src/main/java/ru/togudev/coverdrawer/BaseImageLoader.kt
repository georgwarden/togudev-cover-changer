package ru.togudev.coverdrawer

import java.awt.image.BufferedImage
import javax.imageio.ImageIO

class BaseImageLoader {

    fun load(): BufferedImage = ImageIO.read(this.javaClass.getResourceAsStream("base_image.png"))

}