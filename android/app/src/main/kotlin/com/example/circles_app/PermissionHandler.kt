package com.example.circles_app

import android.app.Activity
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object PermissionHandler {
    private var result: MethodChannel.Result? = null
    private const val REQUEST_CODE = 1

    fun request(call: MethodCall, activity: Activity, result: MethodChannel.Result) {
        this.result = result
        if (ActivityCompat.checkSelfPermission(activity, call.permission()) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(activity, arrayOf(call.permission()), REQUEST_CODE)
        } else {
            result.success(mapOf(call.permission() to PackageManager.PERMISSION_GRANTED))
        }
    }

    fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == REQUEST_CODE) {
            result?.success(mapOf(permissions[0] to grantResults[0]))
        }
    }
}

private fun MethodCall.permission(): String {
    return argument<String>("permissionType")!!
}
