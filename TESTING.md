# Testing Guide for NuraHelp

This document outlines the testing strategy and procedures for the NuraHelp application before Play Store deployment.

## Test Structure

```
test/
├── unit/
│   ├── patient_health_controller_test.dart
│   ├── appointment_model_test.dart
│   └── vitals_filtering_test.dart
└── widget/
    ├── appointment_card_test.dart
    └── medication_tab_test.dart
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/patient_health_controller_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Run Tests in Watch Mode
```bash
flutter test --watch
```

## Test Coverage Requirements

Before deploying to Play Store:

- ✅ **Unit Tests**: All controllers and models
- ✅ **Widget Tests**: Critical UI components
- ✅ **Integration Tests**: User flows (medications, appointments)
- ✅ **Manual Testing**: Visual regression on real devices

## Test Suites

### 1. Patient Health Controller Tests (`patient_health_controller_test.dart`)

**Coverage:**
- Date management (today, previous, next)
- Date formatting
- Vitals filtering by date
- Medications filtering (Ongoing vs History)
- Test results filtering

**Key Scenarios:**
- Date navigation across months
- Medication status filtering (active period vs expired)
- Empty data handling

### 2. Appointment Model Tests (`appointment_model_test.dart`)

**Coverage:**
- Model creation with default status
- Custom status assignment
- JSON parsing
- Default status handling

**Key Scenarios:**
- Parsing appointments from API responses
- Status transitions (Not Canceled → Canceled)
- Date parsing from ISO strings

### 3. Vitals Filtering Tests (`vitals_filtering_test.dart`)

**Coverage:**
- Date-based filtering
- Multiple vitals per day
- Various vital formats (BP, HR, Temp, SpO2)
- Empty list handling

**Key Scenarios:**
- Same-day multiple readings
- Cross-month filtering
- Different unit types

### 4. Appointment Card Widget Tests (`appointment_card_test.dart`)

**Coverage:**
- Display of appointment details
- Status badges for canceled appointments
- Menu visibility based on status
- Virtual vs in-person display

**Key Scenarios:**
- Canceled appointment UI
- Virtual appointment features
- Date/time formatting

### 5. Medication Tab Tests (`medication_tab_test.dart`)

**Coverage:**
- Toggle between Ongoing/History
- Filtering logic
- Empty state messages
- Edge cases (medication ending today, starting today)

**Key Scenarios:**
- Date boundary conditions
- Future medication handling
- Empty medication list

## Manual Testing Checklist

### Appointments Screen
- [ ] Upcoming tab shows only non-canceled appointments
- [ ] Canceled tab shows only canceled appointments
- [ ] Cancel appointment button updates status
- [ ] Status badge appears after cancellation
- [ ] Menu disappears for canceled appointments
- [ ] Virtual appointment shows Join button
- [ ] In-person appointment shows location/details

### Patient Health Screen
- [ ] Date navigation works smoothly
- [ ] Ongoing medications display correctly
- [ ] History medications show past medications
- [ ] Toggle switches between tabs instantly
- [ ] Test results display and download works
- [ ] Empty states show appropriate messages
- [ ] Vitals display for selected date

### Medication Tab
- [ ] Ongoing toggle shows active medications
- [ ] History toggle shows expired medications
- [ ] Medication ending today is in Ongoing
- [ ] Medication starting today is in Ongoing
- [ ] Future medications don't appear in either tab
- [ ] Past medications appear only in History

## Pre-Deploy Checklist

### Code Quality
- [ ] Run `flutter analyze` - no errors
- [ ] Run `flutter test` - all tests pass
- [ ] Review code with `dart analyze`

### Performance
- [ ] Test on low-end device (Android)
- [ ] Test on high-end device (Android)
- [ ] Check battery consumption
- [ ] Monitor memory usage

### Functionality
- [ ] PDF download works on actual device
- [ ] PDF viewing works on actual device
- [ ] Firebase Storage URLs resolve correctly
- [ ] Date filtering works across date boundaries
- [ ] Medication status updates persist

### UI/UX
- [ ] All text is readable
- [ ] All buttons are clickable
- [ ] Animations are smooth
- [ ] No layout overflow on small screens
- [ ] Status badges display correctly

### Firebase
- [ ] Authentication works
- [ ] PDF storage URL is accessible
- [ ] PDF download completes successfully
- [ ] Error messages display appropriately

## Running Tests in CI/CD

For GitHub Actions or similar CI/CD:

```yaml
- name: Run Flutter tests
  run: flutter test

- name: Generate coverage
  run: flutter test --coverage

- name: Upload coverage
  uses: codecov/codecov-action@v3
```

## Debugging Tests

### Run specific test with verbose output
```bash
flutter test test/unit/appointment_model_test.dart -v
```

### Run single test function
```bash
flutter test test/unit/appointment_model_test.dart -k "should create appointment"
```

### Generate test report
```bash
flutter test --machine > test-report.json
```

## Performance Benchmarks

Expected performance on modern devices:
- Date navigation: < 100ms
- Medication filtering: < 50ms
- Tab switching: < 200ms
- PDF download: < 3 seconds (over 4G)

## Known Issues & Workarounds

None currently documented. Update as issues are discovered.

## Contact & Support

For test-related questions or issues:
1. Check test files for documented edge cases
2. Review test output for specific failures
3. File bug report with test case reproduction

## Version History

- **v1.0** - Initial test suite for v1.0.0 release
  - Covers appointments cancellation
  - Covers medication filtering
  - Covers health data date filtering
