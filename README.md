# licenses_dart

![Pub Version](https://img.shields.io/pub/v/licenses_dart) ![Pub Points](https://img.shields.io/pub/points/licenses_dart)

A Dart package for loading and parsing all available SPDX licenses.

This package implements information and content for any [SPDX license](https://spdx.org/licenses) available. It works offline and can be implemented in any system.

## Updates

> Last updated: 2024-11-08 21:03 UTC

The package does not fetch the licenses automatically during runtime. Whenever a new license is published, a new version of this package has to be published as well. Don't worry, this isn't a complicated task, it doesn't even take a minute to regenerate all files.

I try to update the package by myself (you just have to add the latest version to the pubspec), but if I'd ever miss a release, please open [a new enhancement request](https://github.com/JHubi1/licenses_dart/issues/new?assignees=&labels=enhancement&projects=&template=feature.yaml) to make me aware. Thank you.

## Usage

Using this package is pretty straight forward. Create a new `License` object, and that's it. Now you can read all the properties. A list with all available licenses can be found here: [https://spdx.org/licenses](https://spdx.org/licenses)

```dart
var license = License("APACHE-2.0");
print("Name: ${license.name}");
```

The constructor throws a `UnknownLicenseException` if the license is unknown. This can be use to validate licenses.

```dart
var licenseId = "Funky-1.2"; // This license does not exist
try {
    License(licenseId);
    print("License $licenseId valid");
} on UnknownLicenseException {
    print("License $licenseId unknown");
}
```
