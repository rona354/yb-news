# YB News

> Flutter news application for PT Yakin Bertumbuh Sekuritas Front End Developer assessment.

## Submission Info

| Item | Value |
|------|-------|
| **Author** | Royan Fauzan |
| **Email** | royan.fauzan@gmail.com |
| **Date** | 2026-01-15 |
| **Time Invested** | 8 hours (time-boxed) |

---

## Demo

- **Web:** https://rona354.github.io/yb-news/
- **Repository:** https://github.com/rona354/yb-news
- **APK:** Available in `/build/app/outputs/flutter-apk/` after build

### Quick Start Demo

1. **Register** a new account with any valid email
2. **Login** with your credentials
3. **OTP** will appear in a green snackbar (demo mode - no email sent)
4. Enter the 8-character OTP to access news

### Test Credentials (if already registered)

```
Email: demo@example.com
Password: Demo1234
OTP: Displayed in snackbar (DEMO MODE)
```

### Demo Flow

```
Register → Login → OTP (shown in snackbar) → News List → News Detail
                                              ↓
                                    Search & Filter categories
```

---

## Implementation Status

### Fully Implemented

- [x] Login page with email/password validation
- [x] Register page with all validations
- [x] OTP verification page with 3-minute timer
- [x] Resend OTP countdown (MM:SS format)
- [x] OTP expiry handling with clear error message
- [x] **Single device login restriction** (new login invalidates previous sessions)
- [x] News list from NewsData.io API
- [x] News detail page
- [x] Search by title
- [x] Category filter
- [x] Loading states (shimmer)
- [x] Error handling with retry
- [x] Offline indicator with auto-reconnect
- [x] Responsive design (Mobile/Tablet/Desktop)
- [x] Bookmarks (localStorage)

### Stub Implementation (Demo Mode)

| Feature | Current Implementation | Production Approach |
|---------|------------------------|---------------------|
| OTP Sending | Console + Snackbar display | SendGrid/Mailgun/AWS SES |
| Authentication | Local mock with SecureStorage | REST API + JWT |
| Single Device | **Implemented** - Active session tracking per user | Redis session store + WebSocket |
| Reconnection | Auto-refresh on reconnect | Full state serialization with Hive |

### Documented Only (Time Constraint)

- Real SMTP email integration
- Full offline state preservation
- Bonus features (forgot password, pagination, tests, share, animations)

---

## Tech Stack

| Component | Choice | Rationale |
|-----------|--------|-----------|
| Framework | Flutter 3.x | Assignment requirement |
| State Management | flutter_bloc | Scalable, testable |
| Routing | go_router | Declarative routing |
| HTTP Client | dio | Better error handling |
| News API | NewsData.io | CORS support on free tier |

---

## Architecture

This project follows **Clean Architecture** principles:

```
lib/
├── core/           # App-wide utilities, config, theme
├── features/       # Feature modules (auth, news)
│   └── feature/
│       ├── data/           # Data sources, models, repository impl
│       ├── domain/         # Entities, repository contracts, use cases
│       └── presentation/   # BLoC, pages, widgets
└── shared/         # Shared widgets and services
```

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed decisions.

---

## How to Run

### Prerequisites

- Flutter 3.x
- Dart 3.x
- NewsData.io API key (https://newsdata.io/)

### Setup

```bash
# Clone repository
git clone https://github.com/rona354/yb-news.git
cd yb-news

# Copy environment file
cp .env.example .env
# Edit .env and add your NEWS_API_KEY

# Get dependencies
flutter pub get
```

### Run

```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

### Build

```bash
# Web
flutter build web

# Android APK
flutter build apk --debug
```

---

## If Given More Time

### 1. Real SMTP Integration

```dart
// Would integrate with SendGrid
class EmailService {
  Future<void> sendOTP(String email, String otp) async {
    await sendgrid.send(
      to: email,
      template: 'otp_template',
      data: {'otp': otp, 'expiry': '3 minutes'},
    );
  }
}
```

### 2. Proper Session Management

- Redis for session storage
- Device fingerprinting
- WebSocket for real-time session invalidation
- Refresh token rotation

### 3. Full Offline Support

- Hive for local data persistence
- Request queue for offline actions
- Background sync when online
- State serialization/deserialization

### 4. Bonus Features

- Forgot password with OTP
- Infinite scroll pagination
- Bookmark with local storage
- Share to WhatsApp/Telegram
- Unit & widget tests
- Page transition animations

---

## Project Structure

```
yb-news/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   ├── features/
│   │   ├── auth/
│   │   └── news/
│   └── shared/
├── docs/
│   ├── ARCHITECTURE.md
│   ├── STUB_IMPLEMENTATIONS.md
│   └── PRODUCTION_ROADMAP.md
├── LICENSE
└── README.md
```

---

## License

**Proprietary - Evaluation Use Only**

See [LICENSE](LICENSE) file. This code is submitted solely for evaluation purposes and may not be used for any commercial purpose.

---

## Contact

For questions about this submission:

- **Email:** royan.fauzan@gmail.com

---

*Built with Flutter*
