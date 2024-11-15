import 'package:licenses_dart/licenses_dart.dart';

void main() {
  var license1 = License("APACHE-2.0");

  print("Name:\t\t\t${license1.name}");
  print("License ID:\t\t${license1.licenseId}");
  print("Is OSI approved:\t${license1.isOsiApproved}");
  print("Is deprecated:\t\t${license1.isDeprecatedLicenseId}");
  print("See also:\t\t${license1.seeAlso}");

  print("-" * 80);

  var license2Id = "Funky-1.2"; // This license does not exist
  try {
    License(license2Id);
    print("$license2Id: valid");
  } on UnknownLicenseException {
    print("$license2Id: unknown");
  }
}
