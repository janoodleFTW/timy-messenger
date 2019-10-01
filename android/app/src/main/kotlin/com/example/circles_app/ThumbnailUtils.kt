package com.example.circles_app

import android.app.Activity
import android.content.Context
import android.graphics.Bitmap
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

private val executor: ExecutorService = Executors.newFixedThreadPool(1)

fun loadBitmap(call: MethodCall, activity: Activity, result: MethodChannel.Result) {
    val fileId = call.argument<String>("fileId")
    val type = call.argument<Int>("type")
    if (fileId == null || type == null) {
        result.error("INVALID_ARGUMENTS", "fileId or type must not be null", null)
        return
    }
    executor.execute {
        val byteArray = getThumbnailBitmap(context = activity, fileId = fileId.toLong(), type = type)
        Handler(Looper.getMainLooper()).post {
            result.success(byteArray)
        }
    }
}

fun getThumbnailBitmap(context: Context, fileId: Long, type: Int): ByteArray? {
    val bitmap: Bitmap = when (type) {
        0 -> {
            MediaStore.Images.Thumbnails.getThumbnail(
                    context.contentResolver, fileId,
                    MediaStore.Images.Thumbnails.MINI_KIND, null)
        }
        1 -> {
            MediaStore.Video.Thumbnails.getThumbnail(
                    context.contentResolver, fileId,
                    MediaStore.Video.Thumbnails.MINI_KIND, null)

        }
        else -> null
    } ?: return null
    val stream = ByteArrayOutputStream()
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
    bitmap.recycle()
    return stream.toByteArray()
}
