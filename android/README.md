# Timy Android

## Firebase

The Firebase configuration file `google-services.json` need to be provided and located inside the `android/src/main` folder.

If you want to have different configs for release and debug, 
provide two different files in the `android/src/release` and `android/src/debug` folders.

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
