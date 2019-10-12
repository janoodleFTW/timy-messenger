# Timy Android

## Setting up Firebase

Create a project on the Firebase console [here](https://console.firebase.google.com/)

- To add Firebase to your app, click on the android icon or click the gear icon to go to project
settings to find the android icon.

- Register your application by filing up the form with the package name (applicationId) 
and the app nickname if you like.
> Find Your package name which is generally the applicationId in your app-level build.gradle file

- Don't just download the `google-service.json` just yet, click next throughout and also skip the
step where you need to verify the configuration.

- Go back to project settings, here we need to generate a second configuration file. The reason for
this is that the first file we generated is for a release build. Now we need to create one for a
debug build. These applications are differentiated by the application id to which while debugging,
a suffix `.debug` is appended to the applicationId.

- Under your apps, add another app to the project. Click the android icon again on the dialog that
pops up. Register your app with the package name with `.debug` at the end.

- Download the `google-service.json` file that is generated for you. Find it and move it inside
the folder `android/app/` of the project. The firebase sdk is already added to the project.

- Open and view the contents of the file, check that there are 2 entries of `client_info` with the
2 package names, one for debug and one for release.

- On the fourth step of registration, run the app to verify the configuration via the Firebase
console.

## Distribution

To build this application for distribution, 
provide a file `key.jks` containing the signing keys, 
and the `key.properties` with the following content:

```
storePassword=.....
keyPassword=.....
keyAlias=key
storeFile=../key.jks
```

Where you set the `storePassword` and the `keyPassword`. You can also change the alias.

You will need to uncomment the section `signingConfigs` in the `app/build.gradle`.

And change the `signingConfig signingConfigs.debug` to `signingConfig signingConfigs.release`.

You can also provide this files from your CI instead of including this in the project.
