package com.example.circles_app

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Bitmap.createScaledBitmap
import android.graphics.BitmapFactory
import android.media.ExifInterface
import android.util.Log
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream

const val MAX_DIM = 1080.0

fun getAspectRatio(fileName: String): Double {
    val bmp = BitmapFactory.decodeFile(fileName)
    val exif = ExifInterface(fileName)
    val orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION,
            ExifInterface.ORIENTATION_UNDEFINED)

    return when (orientation) {
        ExifInterface.ORIENTATION_ROTATE_90,
        ExifInterface.ORIENTATION_ROTATE_270 -> {
            bmp.height.toDouble() / bmp.width.toDouble()
        }
        else -> {
            bmp.width.toDouble() / bmp.height.toDouble()
        }
    }

}

fun resizeImage(fileName: String, applicationContext: Context): String {
    val file = File(fileName)
    if (!file.exists()) {
        throw Exception("file does not exist $fileName")
    }

    var bmp = BitmapFactory.decodeFile(fileName)

    // Picture is inside the max dimension, no need to compress
    if (bmp.width <= MAX_DIM && bmp.height <= MAX_DIM) {
        Log.d("ImageResize", "Image is already small: $fileName")
        return fileName
    }

    var targetWidth = MAX_DIM
    var targetHeight = MAX_DIM
    if (bmp.width > bmp.height) {
        targetHeight = bmp.height.toDouble() * (MAX_DIM / bmp.width.toDouble())
    } else if (bmp.height > bmp.width) {
        targetWidth = bmp.width.toDouble() * (MAX_DIM / bmp.height.toDouble())
    }
    Log.d("ImageResize", "Target sizes: $targetHeight x $targetWidth")

    val quality = 95

    val bos = ByteArrayOutputStream()
    bmp = createScaledBitmap(bmp, targetWidth.toInt(), targetHeight.toInt(), true)
    val newBmp = bmp.copy(Bitmap.Config.RGB_565, false)
    newBmp.compress(Bitmap.CompressFormat.JPEG, quality, bos)

    val outputFileName = File.createTempFile(
            getFilenameWithoutExtension(file) + "_compressed",
            ".jpg",
            applicationContext.externalCacheDir
    ).path

    val outputStream = FileOutputStream(outputFileName)
    bos.writeTo(outputStream)

    copyExif(fileName, outputFileName)

    return outputFileName
}

private fun copyExif(filePathOri: String, filePathDest: String) {
    val oldExif = ExifInterface(filePathOri)
    val newExif = ExifInterface(filePathDest)

    val attributes = listOf("FNumber",
            "ExposureTime",
            "ISOSpeedRatings",
            "GPSAltitude",
            "GPSAltitudeRef",
            "FocalLength",
            "GPSDateStamp",
            "WhiteBalance",
            "GPSProcessingMethod",
            "GPSTimeStamp",
            "DateTime",
            "Flash",
            "GPSLatitude",
            "GPSLatitudeRef",
            "GPSLongitude",
            "GPSLongitudeRef",
            "Make",
            "Model",
            "Orientation"
    )
    for (attribute in attributes) {
        setIfNotNull(oldExif, newExif, attribute);
    }

    newExif.saveAttributes()
}

private fun setIfNotNull(oldExif: ExifInterface, newExif: ExifInterface, property: String) {
    if (oldExif.getAttribute(property) != null) {
        newExif.setAttribute(property, oldExif.getAttribute(property))
    }
}

private fun getFilenameWithoutExtension(file: File): String {
    val fileName = file.name
    return if (fileName.indexOf(".") > 0) {
        fileName.substring(0, fileName.lastIndexOf("."))
    } else {
        fileName
    }
}
