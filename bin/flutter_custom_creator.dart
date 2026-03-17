import 'dart:io';
import 'package:flutter_custom_creator/flutter_custom_creator.dart';

void main(List<String> arguments) async {
  if (arguments.length != 2) {
    print('Usage: flutter_custom_creator <project_name> <organization>');
    return;
  }

  var projectName = arguments[0];
  var organization = arguments[1];

  await createCustomProject(projectName, organization);

  // Ask if the user wants to add flavors
  stdout.write('\nDo you want to add Flavors to the project? (y/n): ');
  String? answer = stdin.readLineSync();

  if (answer?.toLowerCase() == 'y' || answer?.toLowerCase() == 'yes') {
    await setupFlavors(projectName, organization);
  }
}
