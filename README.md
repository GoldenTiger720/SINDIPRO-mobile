# SINDIPRO Mobile App

A modern mobile application for condominium management built with Flutter. This app provides role-based access for caretakers and managers to handle operational tasks efficiently.

## Features

### For Caretakers 👨‍🔧
- **Equipment Maintenance**: Record maintenance activities with photos
- **Consumption Readings**: Take meter readings (water, gas, electricity) with camera
- **Calendar Access**: View appointments and schedules
- **Contact Directory**: Access emergency and service contacts
- **Problem Reporting**: Report issues with photo documentation
- **Materials Management**: Create and send materials lists via email
- **Building-Specific Access**: Limited to assigned condominium

### For Managers 👔
- **Multi-Building Access**: Manage multiple condominiums
- **Financial Oversight**: Track maintenance budgets and expenses
- **Budget Monitoring**: Monitor monthly and yearly spending
- **Installment Tracking**: Handle purchases in installments
- **Comprehensive Reports**: Generate detailed analytics
- **All Caretaker Features**: Complete operational access

### Core Functionality
- **Role-Based Authentication**: Secure login with JWT tokens
- **Photo Documentation**: Camera integration for evidence/receipts
- **Email Integration**: Send reports and materials lists
- **Offline-First**: Works with intermittent connectivity
- **Multi-Language Support**: Portuguese and English
- **Modern UI**: Material Design 3 with dark mode support

## Technical Stack

- **Framework**: Flutter 3.32.8
- **Language**: Dart 3.8.1
- **State Management**: Provider
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences
- **Camera**: image_picker & camera
- **Charts**: fl_chart
- **Calendar**: table_calendar
- **Email**: url_launcher & mailer

## Installation

### Prerequisites
- Flutter SDK 3.32.8 or higher
- Dart 3.8.1 or higher
- Android Studio / VS Code
- Android/iOS device or emulator

### Setup
```bash
# Navigate to mobile app directory
cd sindipro_mobile

# Install dependencies
flutter pub get

# Generate model files (if needed)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart            # User and authentication models
│   ├── equipment.dart       # Equipment and maintenance models
│   ├── consumption.dart     # Consumption reading models
│   └── financial.dart       # Budget and expense models
├── providers/               # State management
│   └── auth_provider.dart   # Authentication provider
├── services/                # API and external services
│   ├── auth_service.dart    # Authentication API
│   └── api_service.dart     # Main API service
├── screens/                 # UI screens
│   ├── login_screen.dart    # Login interface
│   ├── home_screen.dart     # Main dashboard
│   ├── equipment_screen.dart # Equipment management
│   ├── consumption_screen.dart # Reading management
│   ├── financial_screen.dart # Budget tracking
│   ├── calendar_screen.dart # Appointments
│   └── contacts_screen.dart # Phone directory
└── widgets/                 # Reusable components
```

## User Roles

### Caretaker
- **Access**: Single assigned condominium
- **Permissions**: 
  - Record maintenance activities
  - Take consumption readings
  - View schedules and contacts
  - Report problems
  - Create material lists

### Manager
- **Access**: All condominiums
- **Permissions**:
  - All caretaker permissions
  - Budget management
  - Financial tracking
  - Multi-building overview
  - Comprehensive reporting

## API Integration

The app integrates with the SINDIPRO backend API:
- **Base URL**: `https://sindipro-backend.onrender.com`
- **Authentication**: JWT tokens with refresh
- **Endpoints**:
  - `/api/auth/login/` - User authentication
  - `/api/equipment/` - Equipment management
  - `/api/consumption/readings/` - Consumption data
  - `/api/financial/maintenance-budget/` - Budget tracking

## Demo Credentials

### Manager Access
- **Email**: `manager@sindipro.com`
- **Password**: `password`

### Caretaker Access
- **Email**: `caretaker@sindipro.com`
- **Password**: `password`

## Key Features Implementation

### Financial Budget Tracking
The app implements sophisticated budget management as requested:
- **Monthly Budget**: R$ 6,000 example limit
- **Yearly Budget**: R$ 72,000 total
- **Installment Support**: Track purchases paid in installments
- **Real-time Balance**: See remaining budget after expenses
- **Visual Charts**: Pie charts and progress indicators

### Photo Documentation
- Camera integration for maintenance records
- Receipt capture for expenses
- Meter reading photos
- Problem documentation

### Email Functionality
- Materials lists sent via email
- Maintenance reports
- Problem notifications

### Role-Based Security
- JWT token authentication
- Automatic token refresh
- Role-based UI rendering
- Building access restrictions

## Development Notes

### State Management
Uses Provider pattern for:
- Authentication state
- User session management
- Loading states
- Error handling

### Data Persistence
- JWT tokens in SharedPreferences
- Offline capability preparation
- Local data caching

### UI/UX Design
- Material Design 3
- Responsive layouts
- Accessibility support
- Intuitive navigation
- Photo-first documentation

## Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Future Enhancements

- [ ] Push notifications for maintenance reminders
- [ ] Offline data synchronization
- [ ] PDF report generation
- [ ] Barcode scanning for equipment
- [ ] Voice notes for maintenance logs
- [ ] Multi-language expansion
- [ ] Biometric authentication

## Support

For technical support or feature requests, please contact the development team or create an issue in the project repository.

## License

© 2025 SINDIPRO. All rights reserved.
