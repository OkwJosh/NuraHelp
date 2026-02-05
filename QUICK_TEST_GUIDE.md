# Quick Start: Running Tests

## Prerequisites

Ensure dependencies are installed:
```bash
flutter pub get
```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/unit/appointment_model_test.dart
flutter test test/widget/appointment_card_test.dart
flutter test test/widget/medication_tab_test.dart
```

### Run with coverage
```bash
flutter test --coverage
```

## Expected Output

When running tests, you should see output like:
```
test/unit/appointment_model_test.dart +8/8 passed
test/widget/appointment_card_test.dart +6/6 passed  
test/widget/medication_tab_test.dart +10+10 passed
```

## Troubleshooting

If tests fail:
1. Ensure models match: `vital_model.dart`, `medication_model.dart`, `appointment_model.dart`
2. Check GetX dependency: `get: ^4.7.2`
3. Clean and rebuild: `flutter clean && flutter pub get`
4. Run analyze: `flutter analyze`

## Test Coverage Summary

- **Unit Tests**: 8 (Appointment Model)
- **Widget Tests**: 16 (Appointment Card, Medication Tab)
- **Total Test Cases**: 24+

Each test validates:
- ✅ Model creation and properties
- ✅ JSON parsing
- ✅ Status handling
- ✅ UI rendering
- ✅ User interactions

## Next Steps After Tests Pass

1. Run code analysis: `flutter analyze`
2. Build release APK: `flutter build apk --release`
3. Test on real device
4. Upload to Play Store Console

See `TESTING.md` for detailed guide.
