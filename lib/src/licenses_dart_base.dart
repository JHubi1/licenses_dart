import 'dart:io';
import 'dart:isolate';
import 'dart:convert';

/// Exception thrown when a license is not found.
class UnknownLicenseException implements Exception {}

/// The main license class. Use this to get information about a license.
///
/// The class parses the object attributes described in the official SPDX
/// license repo's documentation. Other fields that may be available for
/// specific licenses are not supported.
///
/// (https://github.com/spdx/license-list-data/blob/main/accessingLicenses.md#license-detail-json-file-format)
class License {
  Map<String, dynamic>? _json;

  /// Creates a new license object.
  ///
  /// [licenseId] is the SPDX license identifier, not case sensitive. The
  /// license must be a valid one, see https://spdx.org/licenses
  ///
  /// If the license is not found, an [UnknownLicenseException] is thrown.
  License(String licenseId) {
    final path = Isolate.resolvePackageUriSync(Uri.parse(
        "package:licenses_dart/src/licenses/${licenseId.toLowerCase()}.json"));
    var file = File(path!.toFilePath());
    if (file.existsSync()) {
      _json = jsonDecode(file.readAsStringSync());
    } else {
      throw UnknownLicenseException();
    }
  }

  /// Whether the license is deprecated.
  bool get isDeprecatedLicenseId => _json!["isDeprecatedLicenseId"] as bool;

  /// Name of the license.
  String get name => _json!["name"] as String;

  /// The SPDX license identifier.
  String get licenseId => _json!["licenseId"] as String;

  /// Full license text, including the standard license header.
  String get licenseText => _json!["licenseText"] as String;

  /// Only the standard license header.
  String get standardLicenseHeader => _json!["standardLicenseHeader"] as String;

  /// Whether the license is OSI approved.
  bool get isOsiApproved => _json!["isOsiApproved"] as bool;

  /// Cross references to other copies of this license.
  List<Uri> get seeAlso =>
      (_json!["seeAlso"] as List).map((e) => Uri.parse(e as String)).toList();

  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toMap() {
    return {
      "isDeprecatedLicenseId": isDeprecatedLicenseId,
      "name": name,
      "licenseId": licenseId,
      "licenseText": licenseText,
      "standardLicenseHeader": standardLicenseHeader,
      "isOsiApproved": isOsiApproved,
      "seeAlso": seeAlso.map((e) => e.toString()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is License && other.licenseId == licenseId;
  }

  @override
  int get hashCode => licenseId.hashCode;
}
