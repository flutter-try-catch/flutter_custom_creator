import 'dart:io';
import 'package:flutter_custom_creator/src/config/auth_manager.dart';
import 'package:flutter_custom_creator/src/core/create_app_networks.dart';
import 'package:flutter_custom_creator/src/core/create_app_utils.dart';
import 'package:flutter_custom_creator/src/app/create_injection_container.dart';
import 'package:flutter_custom_creator/src/config/create_router.dart';
import 'package:flutter_custom_creator/src/config/create_theme_file.dart';
import 'package:flutter_custom_creator/src/flavors/create_flavor_config.dart';
import 'package:flutter_custom_creator/src/flavors/create_flavor_main_files.dart';
import 'package:flutter_custom_creator/src/flavors/create_flavorizr_config.dart';
import 'package:flutter_custom_creator/src/flavors/create_launch_json.dart';
import 'package:flutter_custom_creator/src/flavors/update_endpoints.dart';
import 'package:flutter_custom_creator/src/flavors/create_flavor_readme.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'src/app/create_app_file.dart';
import 'src/app/create_main_file.dart';
import 'src/config/create_app_helper.dart';

/// Creates a new Flutter project with the given [projectName] and [organization].
///
/// The project is created with the following customizations:
///
/// * The project is created with the given [projectName] and [organization].
/// * The project has the following dependencies added to its pubspec.yaml:
///   * `flutter_launcher_icons`
///   * `flutter_svg`
///   * `get`
///   * `gap`
///   * `intl`
/// * The project has the following directories created:
///   * `assets/images/`
///   * `assets/fonts/`
/// * The project has the following assets added to its pubspec.yaml:
///   * `assets/images/`
///   * `assets/fonts/`
/// * The project has the following files created:
///   * `lib/app/app.dart`
///   * `lib/app/injection_container.dart`
///   * `lib/app/main.dart`
///   * `lib/config/app_helper/app_constants.dart`
///   * `lib/config/app_helper/app_extension.dart`
///   * `lib/config/app_helper/app_formats.dart`
///   * `lib/config/app_helper/app_functions.dart`
///   * `lib/config/app_helper/app_gaps.dart`
///   * `lib/config/app_helper/app_padding.dart`
///   * `lib/config/router/app_router.dart`
///   * `lib/config/theme/dark_theme.dart`
///   * `lib/config/theme/light_theme.dart`
///   * `lib/config/theme/theme_manager.dart`
///   * `lib/core/network/api_provider.dart`
///   * `lib/core/network/app_endpoints.dart`
///   * `lib/core/utils/app_utils.dart`
/// * The project has the following files modified:
///   * `lib/main.dart`
Future<void> createCustomProject(
    String projectName, String organization) async {
  // Run flutter create
  await Process.run('flutter', ['create', '--org', organization, projectName],
      runInShell: true);

  // Change to the new project directory
  Directory.current = Directory(projectName);

  // Add dependencies
  await addDependencies();

  // Create custom directories
  await creatDirectorys();

  // Modify pubspec.yaml to add assets
  await addAssets();

  // Create custom files
  await createCustomFiles(appName: projectName);

  print('yor project "$projectName" created successfully! 🎉');
}

/// Sets up flavor support for the generated project.
///
/// This function should be called after [createCustomProject] while the
/// current working directory is still inside the generated project.
///
/// It performs the following:
/// 1. Creates the FlavorConfig singleton class
/// 2. Creates flavor-specific entry points (main_dev, main_staging, main_prod)
/// 3. Configures flutter_flavorizr and runs it to generate native configs
/// 4. Updates app_endpoints.dart to use FlavorConfig
/// 5. Creates VS Code launch.json with flavor debug configurations
/// 6. Appends flavors documentation to README.md
Future<void> setupFlavors(String projectName, String organization) async {
  print('\nSetting up flavors...');

  await createFlavorConfig();
  await createFlavorMainFiles(appName: projectName);
  await setupFlavorizr(appName: projectName, organization: organization);
  await updateEndpointsForFlavors();
  await createLaunchJson();
  await createFlavorReadme(appName: projectName);

  print('\nFlavors setup completed successfully! 🎉');
}

/// Adds the following dependencies to the project's pubspec.yaml:
/// dio, clean_architecture_with_state_management, shared_preferences, intl,
/// gap, and get_it.
///
/// The function is asynchronous and returns a [Future<void>].
///
/// The function is idempotent; it can be safely called multiple times.
///
/// The function does not throw any errors; it prints a success message to the
/// console when it is completed.
Future<void> addDependencies() async {
  var result = await Process.run(
      'flutter',
      [
        'pub',
        'add',
        'dio',
        'clean_architecture_with_state_management',
        'shared_preferences',
        'intl',
        'gap',
        'get_it',
      ],
      runInShell: true);
  print(result.stdout);
}

/// Creates the following custom files in the project directory:
///
/// * `lib/main.dart` with a basic material app that uses the
///   [themeManager] and the [AppRouter].
/// * `lib/app.dart` with a [StatefulWidget] that uses the
///   [ServiceLocator].
/// * `lib/injection_container.dart` with a [ServiceLocator] that registers
///   [Dio] and [ApiProvider] with [GetIt].
/// * `lib/config/theme/light_theme.dart` and `dark_theme.dart` with the
///   light and dark themes for the app.
/// * `lib/config/app_helper/app_helper.dart` with the
///   [AppFormats], [AppPadding], [AppGaps] and [AppFunctions] classes.
/// * `lib/config/router/app_router.dart` with the
///   [AppRouter] class.
/// * `lib/core/utils/app_utils.dart` with the
///   [Logger], [SnackBarUtils], [AppDialogs] classes.
/// * `lib/core/network/app_networks.dart` with the
///   [ApiProvider] class.
///
/// The function is asynchronous and returns a [Future<void>].
///
/// The function is idempotent; it can be safely called multiple times.
///
/// The function does not throw any errors; it prints a success message to the
/// console when it is completed.
Future<void> createCustomFiles({required String appName}) async {
  // Create main.dart with theme
  await createMainFile();

  // Create app.dart
  await createAppFile();

  // Create injection_container.dart
  await createInjectionContainer();

  // Create theme file
  await createThemeFiles();

  // Create AuthManager files
  await createAuthManager();

  // Create app_helper.dart
  await createAppHelper(appName: appName);

  // Create router.dart
  await createRouter();

  // Create app_utils.dart
  await createAppUtils();

  // Create app_networks.dart
  await createAppNetwork();
}

/// Adds the following assets to the pubspec.yaml:
///
/// * `assets/images/`
/// * `assets/fonts/`
///
/// This is a convenience function to simplify the process of adding assets
/// to a Flutter project.
Future<void> addAssets() async {
  Directory('assets').createSync(recursive: true);
  Directory('assets/images').createSync(recursive: true);
  Directory('assets/fonts').createSync(recursive: true);
  Directory('assets/icons').createSync(recursive: true);
  Directory('assets/jsons').createSync(recursive: true);
  Directory('assets/logo').createSync(recursive: true);
  Directory('assets/translations').createSync(recursive: true);

  var pubspecFile = File('pubspec.yaml');
  var content = pubspecFile.readAsStringSync();
  var yamlEditor = YamlEditor(content);

  yamlEditor.update([
    'flutter',
    'assets'
  ], [
    'assets/images/',
    'assets/fonts/',
    'assets/icons/',
    'assets/jsons/',
    'assets/logo/',
    'assets/translations/',
  ]);

  pubspecFile.writeAsStringSync(yamlEditor.toString());
}

/// Creates the following directories:
///
/// * `lib/config`
/// * `lib/core`
/// * `lib/features`
///
/// This is a convenience function to simplify the process of creating
/// these directories in a Flutter project.
Future<void> creatDirectorys() async {
//Create directories
  Directory('lib/config').createSync(recursive: true);
  Directory('lib/core').createSync(recursive: true);
  Directory('lib/features').createSync(recursive: true);
}
