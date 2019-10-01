package com.example.circles_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.work.*
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.CollectionReference
import com.google.firebase.firestore.DocumentReference
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.storage.FirebaseStorage
import com.google.firebase.storage.StorageReference
import io.flutter.plugin.common.MethodCall
import kotlinx.coroutines.coroutineScope
import java.io.File
import java.util.*
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine


const val CHANNEL_ID = "timy.uploads"
const val TAG = "UploadPlatform"

/**
 * Launches an upload media task.
 *
 * Reads the *groupId*, *channelId* and *filePaths* from Flutter's [MethodCall]
 * and then launches a background task [UploadWorker] that:
 *
 * 1. Displays a 'progress bar' notification indicating that files are being uploaded.
 * 2. Creates an empty message on Firestore with the status 'uploading'.
 * 3. Uploads images one by one.
 * 4. Updates the message with the remote urls for the images.
 * 5. Hides the notification.
 *
 * @param call Contains the argument data passed from Flutter.
 * @param applicationContext Necessary to display notifications and read translations.
 */
fun uploadFilesTask(call: MethodCall, applicationContext: Context) {
    // Load arguments from the Flutter platform call
    val groupId = call.argument<String>("groupId")
    val channelId = call.argument<String>("channelId")
    val paths = call.argument<List<String>>("filePaths")!!

    Log.d("UploadPlatform", "groupId: $groupId")
    Log.d("UploadPlatform", "channelId: $channelId")
    Log.d("UploadPlatform", "filePaths: $paths")

    // Create and launch the background job
    val uploadWorkRequest = OneTimeWorkRequestBuilder<UploadWorker>()
            .setInputData(Data.Builder()
                    .putString("groupId", groupId)
                    .putString("channelId", channelId)
                    .putStringArray("filePaths", paths.toTypedArray())
                    .build())
            .build()
    WorkManager.getInstance(applicationContext).enqueue(uploadWorkRequest)
}

/**
 * Upload worker that performs the upload task in the background.
 *
 * This upload process runs in a Kotlin coroutine background thread.
 * Coroutines: https://kotlinlang.org/docs/reference/coroutines/basics.html
 *
 * WorkManager takes care of continuing the task even when the system may destroy/recreate the
 * app while it is in the background.
 *
 * @param appContext Required application [Context] to launch the task
 * @param workerParams Worker parameters that include *groupId*, *channelId* and *filePaths*
 */
class UploadWorker(appContext: Context, workerParams: WorkerParameters)
    : CoroutineWorker(appContext, workerParams) {

    // Background task that runs in a coroutine worker (thread)
    override suspend fun doWork(): Result = coroutineScope {
        var groupId: String? = null
        var channelId: String? = null
        var messageId: String? = null

        try {
            Log.d(TAG, "Started background upload task")
            createNotificationChannel(applicationContext)

            // Load passed arguments to worker
            groupId = inputData.getString("groupId")!!
            channelId = inputData.getString("channelId")!!
            val paths = inputData.getStringArray("filePaths")!!

            // Show the initial notification displaying 'Uploading files' and 'Uploading 1 of x'
            // This notification cannot be dismissed
            showNotificationUpload(applicationContext, id, 0, paths.size)

            // Create an empty Media message with the status 'uploading'
            messageId = createMediaMessage(groupId, channelId, paths)

            // Upload images, one by one, and return the remote url for each of them in a list
            val urls = uploadImages(
                    groupId = groupId,
                    channelId = channelId,
                    messageId = messageId,
                    paths = paths,
                    taskId = id,
                    applicationContext = applicationContext)

            // Get the aspect ratio for the first picture, necessary to display correctly single images
            val aspectRatio: String = getAspectRatioFromFirstPicture(paths)

            // Add all uploaded urls to the Media message
            addMediaToMessage(
                    groupId = groupId,
                    channelId = channelId,
                    messageId = messageId,
                    urls = urls,
                    aspectRatio = aspectRatio)

            Log.d(TAG, "Finished background upload task")
            Result.success()
        } catch (e: Exception) {
            Log.e(TAG, "Upload task finished with error: $e")
            // In case of error, mark the media message with the error status
            markMessageWithError(groupId, channelId, messageId)
            Result.failure()
        } finally {
            // Whatever the final result was:
            // Hide the upload progress notification
            hideNotification(applicationContext, id)
        }
    }
}

/**
 * Creates an empty media message with status UPLOADING
 *
 * Creates a message in Firestore to temporally store the upload status.
 *
 * The message will have the following fields:
 *
 * - 'author' is set to the current user.
 * - 'type' is set to MEDIA (to differentiate from USER or SYSTEM messages)
 * - 'timestamp' is set to current time, but will be updated after upload.
 * - 'media' contains the current local paths (to be used to retry uploads if it fails)
 * - 'body' contains a hardcoded text for reference, it won't be displayed on the app
 *
 * @param groupId Group to create the message
 * @param channelId Channel to create the message
 * @param paths Paths to the local files
 * @return the message id
 */
private suspend fun createMediaMessage(groupId: String, channelId: String, paths: Array<String>): String {
    val uid = getUserUid()
    val firestore = FirebaseFirestore.getInstance()
    // A suspendCoroutine wraps any callback into a synchronous coroutine
    val docRef = suspendCoroutine<DocumentReference> { cont ->
        firestore.getMessageCollection(groupId, channelId)
                .add(hashMapOf(
                        "author" to uid,
                        "type" to "MEDIA",
                        "media_status" to "UPLOADING",
                        "timestamp" to Date().time.toString(),
                        // Store the local paths while upload, in case we need to retry
                        "media" to paths.toList(),
                        "body" to "[media message uploading]"
                ))
                .addOnSuccessListener { documentReference ->
                    Log.d(TAG, "DocumentSnapshot written with ID: ${documentReference.id}")
                    cont.resume(documentReference)
                }
                .addOnFailureListener { e ->
                    Log.w(TAG, "Error adding document", e)
                    throw e
                }
    }
    return docRef.id
}

/**
 * Mark the message as failed (error)
 *
 * Changes the 'media_status' field to ERROR.
 * Use when something goes wrong during the upload process.
 * If any parameter is null, the function does not do anything.
 *
 * @param groupId Group that contains the message
 * @param channelId Channel that contains the message
 * @param messageId The message reference id
 */
private suspend fun markMessageWithError(groupId: String?, channelId: String?, messageId: String?) {
    if (groupId == null || channelId == null || messageId == null) return
    val firestore = FirebaseFirestore.getInstance()
    suspendCoroutine<Boolean> { cont ->
        firestore.getMessageCollection(groupId, channelId)
                .document(messageId)
                .update(hashMapOf<String, Any>(
                        "media_status" to "ERROR"
                ))
                .addOnCompleteListener {
                    cont.resume(true)
                }
                .addOnFailureListener { e ->
                    Log.e(TAG, "Error marking document with error: ", e)
                }
    }
}

/**
 * Extension function to the messages collection of a group and channel
 */
private fun FirebaseFirestore.getMessageCollection(groupId: String, channelId: String): CollectionReference {
    return collection("groups")
            .document(groupId)
            .collection("channels")
            .document(channelId)
            .collection("messages")
}

/**
 * User ID from Firebase Auth (which is the same in our Firestore database)
 */
private fun getUserUid(): String {
    val firebaseAuth = FirebaseAuth.getInstance()
    val uid = firebaseAuth.currentUser!!.uid
    return uid
}

/**
 * Aspect ratio from the first picture in the list of paths.
 *
 * The aspect ratio is used when we need to display single images (so the paths size is 1)
 */
private fun getAspectRatioFromFirstPicture(paths: Array<out String>): String {
    return getAspectRatio(paths.first()).toString()
}

/**
 * Updates the message with the list of uploaded media URLs
 *
 * Updates the following fields:
 *
 * - 'media' is set to the list of urls
 * - 'media_status' to DONE
 * - 'media_aspect_ratio' to the calculated aspect ratio for the first picture
 * - 'timestamp' to the time of this update
 * - 'body' changed to a different message for debug purposes
 *
 */
private suspend fun addMediaToMessage(groupId: String, channelId: String, messageId: String, urls: List<String>, aspectRatio: String) {
    val firestore = FirebaseFirestore.getInstance()
    suspendCoroutine<Boolean> { cont ->
        firestore.getMessageCollection(groupId, channelId)
                .document(messageId)
                .update(hashMapOf(
                        "media" to urls,
                        "media_status" to "DONE",
                        "media_aspect_ratio" to aspectRatio,
                        "timestamp" to Date().time.toString(),
                        "body" to "[media message done]"
                ))
                .addOnCompleteListener {
                    cont.resume(true)
                }
                .addOnFailureListener { e ->
                    Log.w(TAG, "Error adding document", e)
                    throw e
                }
    }
}

/**
 * Performs the resize and upload image process
 *
 * The upload process performs the following steps for every image:
 *
 * 1. Resizes the picture
 * 2. Creates a storage reference pointing /channel/message with the following structure:
 *
 * "/groups/{groupId}/channels/{channelId}/messages/{messageId}/{filename}"
 *
 * NOTE: This is a Storage file reference not a Firestore Document.
 *
 * 3. Uploads the resized file to that storage reference.
 * 4. Obtains the public URL of the file.
 * 5. Updates the displayed progress notification.
 *
 * @param paths list of local files to upload
 * @param groupId Group Id to create the storage reference
 * @param channelId Channel Id , to create the storage reference
 * @param messageId Message Id , to create the storage reference
 * @param taskId Used to identify the notification displayed
 * @param applicationContext Necessary to modify the notification
 * @return the resulting URLs
 */
private suspend fun uploadImages(paths: Array<String>, groupId: String, channelId: String, messageId: String, taskId: UUID, applicationContext: Context): List<String> {
    val storage = FirebaseStorage.getInstance()
    val urls = mutableListOf<String>()
    for (path in paths) {
        val resized = resizeImage(path, applicationContext)
        val file = File(resized)
        val storageRef = storage.reference
        // Store images in a path equal to the message in Firestore, for easier reference
        val fileRef = storageRef.child("/groups/$groupId/channels/$channelId/messages/$messageId/${file.name}")
        val uri = Uri.fromFile(file)
        when (val result = fileRef.putFileK(uri)) {
            is UploadResult.Error -> {
                Log.e(TAG, "Error: " + result.exception.toString())
                throw result.exception
            }
            is UploadResult.Success -> {
                urls.add(result.url)
                // Update the notification process bar
                showNotificationUpload(applicationContext, taskId, urls.size, paths.size)
                Log.d(TAG, "Success! " + result.url)
            }
        }
    }
    return urls
}

/**
 * Helper extension function to handle the upload process
 *
 * First will perform the upload with [StorageReference.putFile]
 * then will obtain the URL with [StorageReference.getDownloadUrl]
 *
 * Both actions are asynchronous and both can fail.
 *
 * @return [UploadResult] containing the url if success or the exception if failed
 */
suspend fun StorageReference.putFileK(uri: Uri): UploadResult =
        suspendCoroutine { cont ->
            putFile(uri)
                    .addOnFailureListener { cont.resume(UploadResult.Error(it)) }
                    .addOnSuccessListener {
                        downloadUrl
                                .addOnFailureListener {
                                    cont.resume(UploadResult.Error(it))
                                }
                                .addOnSuccessListener { uri ->
                                    cont.resume(UploadResult.Success(uri.toString()))
                                }
                    }
        }

/**
 * sealed class to handle the two different cases after an upload
 *
 * [Error] holds the exception in case of error
 * [Success] holds the URL in case of success
 */
sealed class UploadResult {
    data class Error(val exception: Exception) : UploadResult()
    data class Success(val url: String) : UploadResult()
}

/**
 * Display or updates a notification with a progress indicator
 *
 * Each notification displayed has a unique ID based on the current upload process.
 *
 * The notification has the following properties:
 *
 * - Title is localized
 * - Content text is localized and contains the current task number vs. total (e.g. 1 of 10)
 * - App icon used as the notification icon
 * - Sound is set to null to make the notification silent
 * - Only alert once is to update the notification silently too
 * - Ongoing makes the notification not dismissible
 * - Shows a built-in progress indicator
 *
 * TODO: Create a proper notification icon: https://github.com/janoodleFTW/flutter-app/issues/269
 *
 * @param applicationContext Context required for translations and to obtain the [NotificationManager]
 * @param taskId WorkManager unique task ID used to identify the notification
 * @param currentTaskCount current task count, first should be 0
 * @param totalTaskCount total task count
 */
private fun showNotificationUpload(applicationContext: Context, taskId: UUID, currentTaskCount: Int, totalTaskCount: Int) {
    // Show a notification while we upload files
    val notificationManager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    val b = NotificationCompat.Builder(applicationContext, CHANNEL_ID)
            .setWhen(System.currentTimeMillis())
            .setContentTitle(applicationContext.getString(R.string.upload_notification_title))
            .setContentText(applicationContext.getString(R.string.upload_notification_text, currentTaskCount + 1, totalTaskCount))
            .setSmallIcon(R.mipmap.ic_launcher)
            .setSound(null)
            .setOnlyAlertOnce(true)
            .setOngoing(true)
            .setProgress(totalTaskCount, currentTaskCount, false)
    notificationManager.notify(taskId.hashCode(), b.build())
}

/**
 * Creates a Notification Channel if it does not exist
 *
 * From Android 8.0, apps need to display notifications inside Channels.
 * This method creates a Notification Channel for Uploads.
 * Sets this Channel sound to null to make these notifications silent.
 *
 * @param applicationContext necessary app context
 */
private fun createNotificationChannel(applicationContext: Context) {
    val notificationManager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val importance = NotificationManager.IMPORTANCE_LOW
        val channel = NotificationChannel(CHANNEL_ID, "Uploads", importance)
        channel.setSound(null, null)
        notificationManager.createNotificationChannel(channel)
    }
}

/**
 * Hides a notification
 *
 * Use this when we don't need to show the notification anymore (at the end of the upload process)
 *
 * @param applicationContext necessary app context
 * @param id current task Id to identify the notification
 */
private fun hideNotification(applicationContext: Context, id: UUID) {
    val notificationManager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    notificationManager.cancel(id.hashCode())
}

