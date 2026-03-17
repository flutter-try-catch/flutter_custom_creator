# test_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Flavors (Multi-Environment Setup)

This project uses [flutter_flavorizr](https://pub.dev/packages/flutter_flavorizr) to manage multiple app flavors (environments). Each flavor generates a **separate app** with its own app ID, name, and icon, so all flavors can be installed on the same device simultaneously.

### What flutter_flavorizr Does

`flutter_flavorizr` automatically configures native Android and iOS settings for each flavor:
- **Android**: Creates separate `productFlavors` in `build.gradle` with unique `applicationId` for each flavor
- **iOS**: Creates separate build configurations and schemes in Xcode with unique `bundleId` for each flavor
- **No manual Xcode configuration needed** — everything is generated automatically

### Available Flavors

| Flavor   | App Name             | Android App ID             | iOS Bundle ID              |
|----------|----------------------|----------------------------|----------------------------|
| dev      | Test App Dev     | `com.example.test_app.dev`     | `com.example.test_app.dev`     |
| staging  | Test App Staging | `com.example.test_app.staging` | `com.example.test_app.staging` |
| prod     | Test App         | `com.example.test_app`         | `com.example.test_app`         |

### Running with a Specific Flavor

**From the command line:**

```bash
# Run dev flavor
flutter run --flavor dev -t lib/main_dev.dart

# Run staging flavor
flutter run --flavor staging -t lib/main_staging.dart

# Run production flavor
flutter run --flavor prod -t lib/main_prod.dart
```

**From VS Code:**

Use the pre-configured launch configurations in `.vscode/launch.json`:
1. Open the Run & Debug panel (Ctrl+Shift+D / Cmd+Shift+D)
2. Select one of: **Flutter Dev**, **Flutter Staging**, or **Flutter Production**
3. Press F5 to run

### Building with a Specific Flavor

```bash
# Build APK for a specific flavor
flutter build apk --flavor dev -t lib/main_dev.dart
flutter build apk --flavor staging -t lib/main_staging.dart
flutter build apk --flavor prod -t lib/main_prod.dart

# Build iOS for a specific flavor
flutter build ios --flavor dev -t lib/main_dev.dart
flutter build ios --flavor staging -t lib/main_staging.dart
flutter build ios --flavor prod -t lib/main_prod.dart

# Build App Bundle (Android) for a specific flavor
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

### Using FlavorConfig in Code

`FlavorConfig` is a singleton that provides flavor-specific information anywhere in your app:

```dart
import 'config/flavor/flavor_config.dart';

// Check current flavor
if (FlavorConfig.instance.isDev) {
  print('Running in development mode');
}

// Get current API base URL
String apiUrl = FlavorConfig.instance.apiBaseUrl;

// Get current app name
String appName = FlavorConfig.instance.appName;

// Check flavor using enum
switch (FlavorConfig.currentFlavor) {
  case Flavor.dev:
    // Development-specific logic
    break;
  case Flavor.staging:
    // Staging-specific logic
    break;
  case Flavor.prod:
    // Production-specific logic
    break;
}
```

### Configuring API Endpoints Per Flavor

Each flavor has its own API base URL configured in its entry point file (`main_dev.dart`, `main_staging.dart`, `main_prod.dart`):

```dart
// In main_dev.dart
FlavorConfig.initialize(
  flavor: Flavor.dev,
  appName: 'Test App Dev',
  apiBaseUrl: 'https://dev-api.example.com/',
);

// In main_staging.dart
FlavorConfig.initialize(
  flavor: Flavor.staging,
  appName: 'Test App Staging',
  apiBaseUrl: 'https://staging-api.example.com/',
);

// In main_prod.dart
FlavorConfig.initialize(
  flavor: Flavor.prod,
  appName: 'Test App',
  apiBaseUrl: 'https://api.example.com/',
);
```

The `AppEndpoints` class automatically uses the current flavor's base URL:

```dart
import 'core/network/app_endpoints.dart';

// This will use the API URL based on the current flavor
String postsUrl = AppEndpoints.getPosts;
```

### Adding a New Flavor

Follow these steps to add a new flavor (e.g., `qa`):

1. **Update `pubspec.yaml`** — add the new flavor under the `flavorizr.flavors` section:

```yaml
flavorizr:
  flavors:
    qa:
      app:
        name: "Test App QA"
      android:
        applicationId: "com.example.test_app.qa"
      ios:
        bundleId: "com.example.test_app.qa"
```

2. **Run flutter_flavorizr** to generate native configs:

```bash
flutter pub run flutter_flavorizr
```

3. **Add the flavor to the `Flavor` enum** in `lib/config/flavor/flavor_config.dart`:

```dart
enum Flavor { dev, staging, prod, qa }
```

4. **Create a new entry point** `lib/main_qa.dart`:

```dart
import 'package:flutter/material.dart';
import 'app.dart';
import 'injection_container.dart';
import 'config/flavor/flavor_config.dart';
import 'config/theme/theme_manager.dart';
import 'config/auth/auth_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.initialize(
    flavor: Flavor.qa,
    appName: 'Test App QA',
    apiBaseUrl: 'https://qa-api.example.com/',
  );

  themeManager = await ThemeManager.loadTheme();
  authManager = await AuthManager.loadUser();

  Future.wait([
    ServiceLocator().setup(),
  ]).then((value) {
    runApp(App());
  });
}
```

5. **Add a VS Code launch configuration** in `.vscode/launch.json`:

```json
{
  "name": "Flutter QA",
  "request": "launch",
  "type": "dart",
  "program": "lib/main_qa.dart",
  "args": ["--flavor", "qa"]
}
```

6. **Run the new flavor:**

```bash
flutter run --flavor qa -t lib/main_qa.dart
```

