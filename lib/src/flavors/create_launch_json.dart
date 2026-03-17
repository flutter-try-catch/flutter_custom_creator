import 'dart:io';

/// Creates `.vscode/launch.json` with three debug configurations:
/// - Dev: runs `main_dev.dart` with `--flavor dev`
/// - Staging: runs `main_staging.dart` with `--flavor staging`
/// - Prod: runs `main_prod.dart` with `--flavor prod`
Future<void> createLaunchJson() async {
  Directory('.vscode').createSync(recursive: true);

  File('.vscode/launch.json').writeAsStringSync('''{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter Dev",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_dev.dart",
      "args": [
        "--flavor",
        "dev"
      ]
    },
    {
      "name": "Flutter Staging",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_staging.dart",
      "args": [
        "--flavor",
        "staging"
      ]
    },
    {
      "name": "Flutter Production",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_prod.dart",
      "args": [
        "--flavor",
        "prod"
      ]
    }
  ]
}
''');

  print('Created .vscode/launch.json');
}
