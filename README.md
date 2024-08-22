# VHome app

This app requires server from another repo to run - [vhome-server](https://github.com/WiktorOgrodnik/vhome-server)

## Required .env file

To compile this application an .env file is required. It must contain the server address for the release target. An example .env file:

```
APIURL="your.server.address"
```

Nevertheless, for the debug target the address is `127.0.0.1:8080`. This can be changes in the `packages/vhome_web_api/lib/src/api/url.dart`.

## How to run in debug mode

You will need flutter toolchain installed - instruction [here](https://docs.flutter.dev/get-started/install/linux/desktop).

1. Run the application

```
flutter run
```

## How to compile for Android

1. Build the application

```
flutter build apk --release
```

2. Install on mobile device

## How to compile for external screen

1. Using target device compile the app with

```
flutter build linux --release --target lib/main_display.dart
```

2. Kiosk mode can be enabled using [snapp_installer](https://github.com/Snapp-X/snapp_installer) project. More details in the project repository.

## How to generate json to object functions

Part of the `vhome_web_api` library code was generated. After changing the model files you should type the command in the `packages/vhome_web_api` directory:

```
dart run build_runner build
```
