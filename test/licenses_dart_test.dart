import 'package:licenses_dart/licenses_dart.dart';
import 'package:test/test.dart';

void main() {
  group("Values", () {
    final license = License("Apache-2.0");

    test("Is deprecated", () {
      expect(license.isDeprecatedLicenseId, isFalse);
    });
    test("Name", () {
      expect(license.name, "Apache License 2.0");
    });
    test("License ID", () {
      expect(license.licenseId, "Apache-2.0");
    });
    test("License text", () {
      expect(license.licenseText, isNotEmpty);
    });
    test("Standard license header", () {
      expect(license.standardLicenseHeader, isNotEmpty);
    });
    test("Is OSI approved", () {
      expect(license.isOsiApproved, isTrue);
    });
    test("See also", () {
      expect(license.seeAlso, isA<List<Uri>>());
    });
  });
  group("Operations", () {
    final license = License("Apache-2.0");

    test("Equal", () {
      expect((license == License("Apache-2.0")), isTrue);
    });
    test("Not equal", () {
      expect((license == License("MIT")), isFalse);
    });

    test("To string", () {
      expect(license.toString(), equals("Apache License 2.0"));
    });
    test("To map", () {
      expect(license.toMap(), isA<Map<String, dynamic>>());
    });
  });
}
