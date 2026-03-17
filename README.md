# Flutter Custom App Package

This package provides a structured foundation for creating custom Flutter applications. It includes configurations, routing, theming, core functionalities, and utility helpers to streamline the development process.

## Package Structure

```
lib/
├── config/
│   ├── app_helper/
│   │   ├── app_extension.dart
│   │   ├── app_formats.dart
│   │   ├── app_functions.dart
│   │   ├── app_gaps.dart
│   │   └── app_padding.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── unknown_route.dart
│   └── theme/
│       ├── dark_theme.dart
│       ├── light_theme.dart
│       └── theme_manager.dart
├── core/
│   ├── network/
│   │   ├── api_provider.dart
│   │   └── app_endpoints.dart
│   └── utils/
│       ├── dialogs.dart
│       ├── logger.dart
│       ├── snack_bar_utils.dart
│       └── validator.dart
├── features/
├── app.dart
├── injection_container.dart
└── main.dart
```

## Features

- **Config**: Contains helper functions, routing configurations, and theme management.
- **Core**: Includes network-related utilities and general-purpose utility functions.
- **Features**: Houses the main application file, dependency injection setup, and the entry point of the app.
- **Flavors (Optional)**: Automatically sets up multi-environment support (`dev`, `staging`, `prod`) using `flutter_flavorizr`, configuring native Android and iOS setups with zero manual effort.

## Getting Started

### Installation

1. Install the `flutter_custom_creator` tool (if not already installed):
   ```
   dart pub global activate flutter_custom_creator
   ```

### Usage

To create a new Flutter project using this custom app structure:

1. Use the tool to create a new project:
   ```
   flutter_custom_creator example com.yourdomain
   ```
   Replace `example` with your desired project name and `com.yourdomain` with your app's domain.

2. The tool will optionally prompt you to add Flavors (multi-environment setup). If you choose `y`, it will automatically configure `dev`, `staging`, and `prod` environments along with VS Code launch configurations.

3. This will create a new Flutter project with the custom structure and files provided by this package.

4. Navigate to your project directory and run the app:
   ```
   cd example
   flutter run
   ```
   *(If you enabled Flavors, you can run specific environments like: `flutter run --flavor dev -t lib/main_dev.dart`)*

### Customizing Your App

After creating your project:

1. Modify `lib/main.dart` to customize your app's entry point.
2. Update `lib/features/app.dart` to adjust the overall app structure.
3. Use the provided config, core, and feature directories to build out your app's functionality.

## Configuration

- Modify `app_router.dart` to set up your app's navigation structure.
- Customize `dark_theme.dart` and `light_theme.dart` to match your app's design.
- Use `app_helper` files to maintain consistent styling and functionality across your app.

## Network

The `core/network` directory contains classes for API communication:

- `api_provider.dart`: Handles API requests and responses.
- `app_endpoints.dart`: Defines API endpoints used in the app.

## Utilities

The `core/utils` directory provides common utility functions:

- `dialogs.dart`: Helper methods for displaying dialogs.
- `logger.dart`: Logging utility for debugging.
- `snack_bar_utils.dart`: Functions for displaying snack bar messages.
- `validator.dart`: Input validation helpers.

## Dependency Injection

The `injection_container.dart` file sets up dependency injection for the app. Modify this file to register and manage your app's dependencies.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
