package com.example.circles_app

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

private const val UPLOAD_PLATFORM = "de.janoodle.timy/upload_platform"
private const val PERMISSION = "de.janoodle.timy/permission-android"
private const val THUMBNAILS = "de.janoodle.timy/thumbnails-android"

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, UPLOAD_PLATFORM).setMethodCallHandler { call, result ->
            when (call.method) {
                "uploadFiles" -> uploadFilesTask(call, applicationContext)
            }
        }

        MethodChannel(flutterView, PERMISSION).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestPermission" -> PermissionHandler.request(call, this, result)
            }
        }

        MethodChannel(flutterView, THUMBNAILS).setMethodCallHandler { call, result ->
            when (call.method) {
                "getThumbnailBitmap" -> loadBitmap(call, this, result)
            }
        }

    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        PermissionHandler.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }
}
