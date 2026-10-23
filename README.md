# IT 110 Semester Project – Activity 9

This repository contains the Flutter Web semester project originally initialized in **Activity 8** and extended for **Activity 9: Reusable Screens, Widgets, and Asynchronous UI States**.

## Current implementation

The Activity 9 update adds a reusable Report Form workflow while keeping the existing Home and Login screens from Activity 8.

Implemented features include:

- Home screen navigation to the Report Form
- `report_form_screen.dart` under `lib/screens/`
- Reusable `AppButton` and `AppTextField` widgets
- Report title, category, location, and description fields
- Field-level form validation
- Simulated asynchronous UI responses:
  - Loading
  - Success
  - Empty
  - Error
- Duplicate-submission prevention while a request is loading
- Retry and correction actions for simulated errors

## Project structure

```text
lib/
├── main.dart
├── app.dart
├── screens/
│   ├── home_screen.dart
│   ├── login_screen.dart
│   └── report_form_screen.dart
├── widgets/
│   ├── app_button.dart
│   └── app_text_field.dart
├── services/
├── models/
├── routes/
└── constants/
```

## Technology stack

- Flutter Web / Dart
- Google Chrome for local testing
- Git and GitHub for version control
- REST API integration – planned for a later activity
- PostgreSQL integration – planned for a later activity

## Run locally

Make sure Flutter and Google Chrome are installed, then run:

```bash
flutter pub get
flutter run -d chrome
```

## Reproducing the Activity 9 UI states

**Loading:** Fill in valid report information and select **Submit Report**. The form temporarily disables submission while the simulated request is pending.

**Success:** Submit valid report information without enabling the simulated failure option. The Success response appears after the simulated delay.

**Empty:** Before creating a successful report, select **Check Report Records**. The app displays an Empty response when no simulated report records are available.

**Error:** Enable **Simulate failure for Error state**, complete the form with valid information, and select **Submit Report**. The app displays an Error response with Retry and correction options.

## Git checkpoints

- **Activity 8:** Initial Flutter Web project, source-code organization, Home/Login baseline, and first GitHub checkpoint.
- **Activity 9:** Report Form, reusable widgets, form validation, and Loading/Success/Empty/Error UI states.

## Notes

The asynchronous responses in Activity 9 are intentionally simulated with Flutter-side logic. No real REST API or PostgreSQL database connection is implemented yet. These simulated operations should be replaced with real backend requests and persisted data when backend integration is introduced in a later activity.