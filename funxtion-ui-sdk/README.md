Funxtion’s Flutter UI kit is a collection of custom UI components designed to provide fitness content in your application. The UI kit has been developed keeping developers in mind and aims to reduce development efforts significantly. The UI kit depends on [Funxtion's Flutter SDK](https://github.com/Funxtion-International/funxtion-flutter-sdk), which provides an API client implementation of [Funxtion's V3 API](https://docs.funxtion.com).

Finally, check out [Funxtion's Flutter Demo app](https://github.com/Funxtion-International/funxtion-flutter-demo-app), which features the implementation of the SDK and UI kit.

## Features

Components library and content discovery page implementations for:

* Video Classes
* Audio Classes
* Training Plans
* Workouts
* Discovery & Search

## Getting started

Before you begin, ensure you have met the following requirements:

:white_check_mark: You have Android Studio, Xcode or Visual Studio Code installed on your computer

:white_check_mark: You have an Android Device or Emulator

:white_check_mark: You have an iOS Device or Emulator

:white_check_mark: You are familiar with the Funxtion Prototype (provided upon request)

## Usage

Make a local copy of the `funxtion-flutter-sdk` and `funxtion-flutter-ui-kit` repositories.

Include the Funxtion SDK and UI kit dependencies into your `pubspec.yaml` file:

```dart
dependencies:
  flutter:
    sdk: flutter
  funxtion: 
    path: ../funxtion-flutter-sdk-main/
  ui_tool_kit:
    path: ../funxtion-flutter-ui-kit-main/
```

Include the UI library in your application file, i.e. `main.dart`

```dart
import 'package:ui_tool_kit/ui_tool_kit.dart';
```

Integrate the navigation to the various screens:

**Content Discovery**

This is the recommended integration. Assign an app menu icon to this screen. The remaining screens defined below, can be accessed from the Content Discovery screen, and are *optional*.

```dart
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiToolKitSDK(
      categoryName: CategoryName.dashBoard,
      token:
          "[API_TOKEN]",
    );
  }
}
```

**Video Classes**

```dart
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiToolKitSDK(
      categoryName: CategoryName.videoClasses,
      token:
          "[API_TOKEN]",
    );
  }
}
```

**Workouts**

```dart
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiToolKitSDK(
      categoryName: CategoryName.workouts,
      token:
          "[API_TOKEN]",
    );
  }
}
```

**Training Plans**

```dart
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiToolKitSDK(
      categoryName: CategoryName.trainingPlans,
      token:
          "[API_TOKEN]",
    );
  }
}
```

**Audio Classes**

```dart
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiToolKitSDK(
      categoryName: CategoryName.audioClasses,
      token:
          "[API_TOKEN]",
    );
  }
}
```

## Advanced functionality

### Localization - change the language

To change the language, set the desired locale.

**Note**: If the specified locale does not exist, the default language will be English.

```dart
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return UiToolKitSDK(
      locale: const Locale('it'),
      categoryName: CategoryName.dashBoard,
      token:
          "[API_TOKEN]",
    ); // UiToolKitSDK
  }
}
```
### Reading and Writing Training Plan Progress

Training plan progress is stored locally.

The `readWriteTrainingPlan` function in the provided Flutter code is a callback used to manage the reading and writing of training plans with a backend server.

**Example usage:**

```dart
class Home extends StatelessWidget {
  const Home({super.key});

  final String bearerToken = 
    "[API_TOKEN]";

  @override
  Widget build(BuildContext context) {
    return UiToolKitSDK(
      readWriteTrainingPlan: (p0, p1) {
        p0.forEach((element) {
          element.trainingPlanTitle;
        });
        p1.post("https://testing", queryParameters: {});
      },
      categoryName: CategoryName.dashBoard, 
      token: bearerToken
    ); // UiToolKitSDK
  }
}
```

Here is a breakdown of its components and functionality:

**Function signature:**

```dart
readWriteTrainingPlan: (p0, p1)
```

**Parameters:**

* p0: Represents a collection of training plan elements.
* p1: Represents an object that provides methods for HTTP operations, such as post.

**Function logic:**

```dart
p0.forEach((element) {
  element.trainingPlanTitle;
});
```

Iterates through each element in p0.
Accesses the trainingPlanTitle property of each element.

```dart
p1.post("https://testing", queryParameters: {});
```

Executes a POST request to the URL https://testing.
You may extend the empty set of query parameters with additional data, i.e. the user identifier and store the training plan progress
into their server-side user profile.

### Content packages

The `contentPackageId` parameter is a crucial part of the UI kit, enabling the customization and filtering of content based on membership tiers or packages. This parameter integrates with your Member Management System (MMS) or Content Management System (CMS) to deliver targeted content to users. In the Funxtion platform content can be assigned to the corresponding content packages.

**Overview**

`contentPackageId`: A string identifier that maps to a specific membership tier or package. This ID is used to filter content entities such as training plans, workouts, video classes, and audio classes. By setting this parameter, you ensure that users receive content tailored to their membership level.

To use the `contentPackageId` parameter, include it when initializing the UI kit within your Flutter application. The parameter should be set to a valid package ID from your MMS or CMS.

**Example usage:**

```dart
class Home extends StatelessWidget {
  const Home({super.key});

  final String bearerToken =
    "[API_TOKEN]";

  @override
  Widget build(BuildContext context) {
    return UiToolKitSDK(
      contentPackageId: "premium_tier_1",
      categoryName: CategoryName.dashBoard,
      token: bearerToken
    ); // UiToolKitSDK
  }
}
```

In this example:

* `contentPackageId` is set to `premium_tier_1`, which corresponds to a specific membership package.
* The UI kit will filter the content based on this ID, ensuring that only the appropriate training plans, workouts, video classes, and audio classes are displayed to the user.

**Integration with MMS/CMS**

1. **Define Packages**: Ensure that your MMS or CMS has defined membership tiers or packages, each with a unique `contentPackageId`.
2. **Assign Content**: Link your content entities (training plans, workouts, etc.) to these package IDs within your MMS or CMS.
3. **Set contentPackageId**: When initializing the UI kit, set the `contentPackageId` to the appropriate value for the current user’s membership package.

**Notes**

* **Default Behavior**: If the `contentPackageId` is not set or is invalid, the system may default to showing general or unrestricted content. Verify this behavior based on your specific implementation.
* **Validation**: Ensure that the `contentPackageId` provided is valid and exists within your MMS or CMS to prevent any issues with content filtering.

By correctly setting the `contentPackageId`, you can effectively manage and deliver customized content to users based on their membership level, enhancing their overall experience.
