import 'dart:io';
import 'package:yaml_edit/yaml_edit.dart';

/// Adds the `flutter_flavorizr` dev dependency and configures the `flavorizr`
/// section in the generated project's `pubspec.yaml` with three flavors:
/// dev, staging, and prod.
///
/// Then runs `flutter pub run flutter_flavorizr` to auto-generate all
/// native Android and iOS flavor configurations.
Future<void> setupFlavorizr({
  required String appName,
  required String organization,
}) async {
  // Add flutter_flavorizr as a dev dependency
  var addResult = await Process.run(
    'flutter',
    ['pub', 'add', 'flutter_flavorizr', '--dev'],
    runInShell: true,
  );
  print(addResult.stdout);

  // Convert project name to display name (e.g., "my_app" -> "My App")
  String displayName = appName
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');

  // Build the application ID base from the organization
  // organization is like "com.example" and appName is like "my_app"
  // Result: "com.example.my_app"
  String appIdBase = '$organization.$appName';

  // Read and update pubspec.yaml with flavorizr config
  var pubspecFile = File('pubspec.yaml');
  var content = pubspecFile.readAsStringSync();
  var yamlEditor = YamlEditor(content);

  yamlEditor.update(['flavorizr'], {
    'flavors': {
      'dev': {
        'app': {
          'name': '$displayName Dev',
        },
        'android': {
          'applicationId': '$appIdBase.dev',
        },
        'ios': {
          'bundleId': '$appIdBase.dev',
        },
      },
      'staging': {
        'app': {
          'name': '$displayName Staging',
        },
        'android': {
          'applicationId': '$appIdBase.staging',
        },
        'ios': {
          'bundleId': '$appIdBase.staging',
        },
      },
      'prod': {
        'app': {
          'name': displayName,
        },
        'android': {
          'applicationId': appIdBase,
        },
        'ios': {
          'bundleId': appIdBase,
        },
      },
    },
  });

  pubspecFile.writeAsStringSync(yamlEditor.toString());
  print('Added flavorizr configuration to pubspec.yaml');

  // Run flutter_flavorizr with -f flag and -p to only run native config
  // processors. We skip flutter:flavors, flutter:app, flutter:pages,
  // flutter:main to avoid overwriting our custom Dart files.
  print('Running flutter_flavorizr to generate native configurations...');
  var flavorizrProcess = await Process.start(
    'dart',
    [
      'run',
      'flutter_flavorizr',
      '-f',
      '-p',
      'assets:download,'
          'assets:extract,'
          'android:androidManifest,'
          'android:flavorizrGradle,'
          'android:buildGradle,'
          'android:dummyAssets,'
          'android:icons,'
          'ios:podfile,'
          'ios:xcconfig,'
          'ios:buildTargets,'
          'ios:schema,'
          'ios:dummyAssets,'
          'ios:icons,'
          'ios:plist,'
          'ios:launchScreen,'
          'assets:clean',
    ],
    runInShell: true,
  );

  // Forward stdout and stderr to the console
  flavorizrProcess.stdout.listen((data) {
    stdout.add(data);
  });
  flavorizrProcess.stderr.listen((data) {
    stderr.add(data);
  });

  var exitCode = await flavorizrProcess.exitCode;

  if (exitCode != 0) {
    print('Warning: flutter_flavorizr encountered issues.');
    print(
      'You may need to run "dart run flutter_flavorizr -f" manually '
      'after resolving any issues.',
    );
  } else {
    print('Native flavor configurations generated successfully!');
  }
}
