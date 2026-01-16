# YB News - Take Home Test Implementation Plan

> **IMPORTANT:** Baca file ini sebelum mulai mengerjakan.
> File ini berisi strategi, keputusan arsitektur, dan anti-exploitation measures.

---

## Quick Reference

| Item | Value |
|------|-------|
| **Deadline** | 24 jam dari assignment diterima |
| **Time Budget** | 8 jam (time-boxed) |
| **Framework** | Flutter |
| **Target** | Web + Mobile |
| **Figma** | https://bit.ly/48EKQsc |
| **Submit ke** | dwi.handayani@yb.co.id |

---

## Table of Contents

1. [Assessment Overview](#1-assessment-overview)
2. [Red Flags & Mitigasi](#2-red-flags--mitigasi)
3. [Anti-Exploitation Strategy](#3-anti-exploitation-strategy)
4. [Tech Stack Decisions](#4-tech-stack-decisions)
5. [Feature Breakdown](#5-feature-breakdown)
6. [Project Structure](#6-project-structure)
7. [Implementation Guide](#7-implementation-guide)
8. [Stub Code Templates](#8-stub-code-templates)
9. [Time Allocation](#9-time-allocation)
10. [Deliverables Checklist](#10-deliverables-checklist)

---

## 1. Assessment Overview

### Fitur Wajib (dari PDF)

1. **Login**
   - Email & password
   - First-time login → OTP required
   - OTP 8 digit alphanumeric
   - Resend OTP dengan countdown 3 menit
   - OTP expiry 3 menit
   - Single device login restriction

2. **Register**
   - Nama lengkap, email, password, confirm password
   - Validasi: email format, password 8 digit alphanumeric, password match

3. **News List**
   - Dari API publik (NewsAPI/GNews)
   - Thumbnail, judul, tanggal, sumber, excerpt

4. **News Detail**
   - Judul, gambar, tanggal, konten, link sumber

5. **Responsive Design**
   - Mobile → Tablet → Desktop

6. **Search & Filter**
   - Search by judul
   - Filter kategori (Technology, Business, Finance, Sport, Health, Entertainment)
   - Loading & error states

7. **Reconnection Handling**
   - Online/offline indicator
   - Auto reconnect
   - Preserve last page & state

### Fitur Bonus (SKIP - dokumentasi only)

- Forgot password dengan OTP
- Infinite scroll / pagination
- Bookmark (localStorage)
- Unit test
- Share ke WhatsApp/Telegram
- Animated transitions

---

## 2. Red Flags & Mitigasi

### Identified Red Flags

| Red Flag | Severity | Mitigasi |
|----------|----------|----------|
| Scope vs time tidak proporsional | High | Time-box 8 jam |
| Requirements terlalu spesifik (seperti product spec) | Medium | Stub implementations |
| SMTP integration untuk take-home | High | Demo mode only |
| Single device login untuk mock backend | High | LocalStorage simulation |
| Nama branded "YB News" | Medium | License protection |
| Figma design sudah jadi | Medium | Document sebagai assessment |

### Prinsip Pengerjaan

```
1. DEMONSTRATE skill, bukan DELIVER production app
2. STUB complex features, DOCUMENT understanding
3. PROTECT dengan LICENSE
4. TIME-BOX strictly 8 jam
```

---

## 3. Anti-Exploitation Strategy

### A. Legal Protection

**File: LICENSE**
```
PROPRIETARY LICENSE - EVALUATION USE ONLY

Copyright (c) 2024 [NAMA LENGKAP]

This software is submitted solely for the purpose of evaluating
the author's technical skills as part of a job application process
for PT Yakin Bertumbuh Sekuritas.

RESTRICTIONS:
1. This code may NOT be used, copied, modified, or distributed
   for any commercial purpose.
2. This code may NOT be incorporated into any product or service.
3. This code may NOT be shared with third parties beyond the
   evaluation committee.
4. All rights revert to the author if no employment offer is
   made within 30 days of submission.

Unauthorized use of this code constitutes copyright infringement.

Contact: [EMAIL]
```

**Header di setiap file:**
```dart
/// Copyright (c) 2024 [NAMA]. All rights reserved.
/// Evaluation use only - see LICENSE file.
```

### B. Technical Safeguards

| Protection | Implementation |
|------------|----------------|
| SMTP tidak real | Console + Snackbar, tidak integrasi service |
| Backend mock | Data tidak persist, hilang saat restart |
| Single device stub | SharedPreferences only, tidak cross-device |
| No store deployment | Debug build only |
| Environment dependent | API keys di .env, tidak committed |

### C. Intentional Incompleteness

Features yang SENGAJA tidak production-ready:
- OTP dikirim ke console/snackbar, bukan email
- Session hanya local storage
- Reconnection hanya indicator, tidak preserve state
- Tidak ada real authentication backend

---

## 4. Tech Stack Decisions

### Core

| Component | Choice | Rationale |
|-----------|--------|-----------|
| Framework | Flutter 3.x | Required by assignment |
| State Management | flutter_bloc | Scalable, testable, shows architecture skill |
| Routing | go_router | Declarative, deep linking support |
| HTTP | dio | Interceptors, better error handling |
| Local Storage | shared_preferences | Simple key-value untuk stubs |

### Supporting

| Component | Choice | Rationale |
|-----------|--------|-----------|
| News API | GNews.io | No CORS issues, works in web |
| Forms | flutter_form_builder + form_validators | Rapid development |
| Connectivity | connectivity_plus | Online/offline detection |
| Code Gen | freezed + json_serializable | Type-safe models |

### Tidak Digunakan (Intentional)

| Component | Reason |
|-----------|--------|
| Firebase Auth | Overkill untuk stub, mereka bisa pakai |
| Real SMTP service | Anti-exploitation |
| Hive/SQLite | Tidak perlu persistence untuk demo |

---

## 5. Feature Breakdown

### TIER 1: IMPLEMENT (Core Demo)

| Feature | Priority | Effort |
|---------|----------|--------|
| Project setup + architecture | P0 | 1 jam |
| Login page UI + validation | P0 | 0.5 jam |
| Register page UI + validation | P0 | 0.5 jam |
| OTP page UI + timer logic | P0 | 1 jam |
| News list page | P0 | 1 jam |
| News detail page | P0 | 0.5 jam |
| Search functionality | P1 | 0.5 jam |
| Category filter | P1 | 0.5 jam |
| Loading/error states | P1 | 0.5 jam |
| Basic responsive | P1 | Built-in |

### TIER 2: STUB (Show Understanding)

| Feature | Stub Approach | Production Note |
|---------|---------------|-----------------|
| OTP sending | Console + Snackbar | SendGrid/Mailgun |
| Auth backend | Local mock + delay | REST API + JWT |
| Single device | SharedPrefs check | Redis + WebSocket |
| Reconnection | Basic indicator | State serialization |

### TIER 3: SKIP (Document Only)

| Feature | Documentation |
|---------|---------------|
| Real SMTP | Architecture in README |
| Cross-device session | Diagram in docs |
| Full offline support | Roadmap in README |
| All bonus features | "Would implement" section |

---

## 6. Project Structure

```
yb-news/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── config/
│   │   │   ├── app_config.dart
│   │   │   ├── routes.dart
│   │   │   └── theme.dart
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   └── app_constants.dart
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   └── network_info.dart
│   │   └── utils/
│   │       ├── validators.dart
│   │       └── extensions.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── auth_local_datasource.dart  # Mock
│   │   │   │   ├── models/
│   │   │   │   │   ├── user_model.dart
│   │   │   │   │   └── otp_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── login.dart
│   │   │   │       ├── register.dart
│   │   │   │       ├── send_otp.dart
│   │   │   │       └── verify_otp.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── auth_bloc.dart
│   │   │       │   ├── auth_event.dart
│   │   │       │   └── auth_state.dart
│   │   │       ├── pages/
│   │   │       │   ├── login_page.dart
│   │   │       │   ├── register_page.dart
│   │   │       │   └── otp_page.dart
│   │   │       └── widgets/
│   │   │           └── otp_timer_widget.dart
│   │   │
│   │   └── news/
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── news_remote_datasource.dart
│   │       │   ├── models/
│   │       │   │   └── article_model.dart
│   │       │   └── repositories/
│   │       │       └── news_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── article.dart
│   │       │   ├── repositories/
│   │       │   │   └── news_repository.dart
│   │       │   └── usecases/
│   │       │       ├── get_articles.dart
│   │       │       └── search_articles.dart
│   │       └── presentation/
│   │           ├── bloc/
│   │           │   ├── news_bloc.dart
│   │           │   ├── news_event.dart
│   │           │   └── news_state.dart
│   │           ├── pages/
│   │           │   ├── news_list_page.dart
│   │           │   └── news_detail_page.dart
│   │           └── widgets/
│   │               ├── article_card.dart
│   │               ├── search_bar.dart
│   │               └── category_chips.dart
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── loading_widget.dart
│       │   ├── error_widget.dart
│       │   └── offline_banner.dart
│       └── services/
│           ├── otp_service.dart        # STUB
│           ├── session_service.dart    # STUB
│           └── connectivity_service.dart
│
├── assets/
│   └── images/
│
├── docs/
│   ├── ARCHITECTURE.md
│   ├── STUB_IMPLEMENTATIONS.md
│   └── PRODUCTION_ROADMAP.md
│
├── test/                    # Minimal/skip untuk time constraint
│
├── .env.example
├── .gitignore
├── LICENSE
├── README.md
├── PLAN.md                  # File ini
├── analysis_options.yaml
└── pubspec.yaml
```

---

## 7. Implementation Guide

### Phase 1: Setup (Jam 0-1)

```bash
# Create Flutter project
flutter create yb_news --org com.assessment
cd yb_news

# Add dependencies
# Edit pubspec.yaml (lihat section dependencies di bawah)

flutter pub get
```

**pubspec.yaml dependencies:**
```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5

  # Routing
  go_router: ^12.1.1

  # Network
  dio: ^5.4.0
  connectivity_plus: ^5.0.2

  # Storage
  shared_preferences: ^2.2.2

  # Utils
  uuid: ^4.2.1
  intl: ^0.18.1

  # UI
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
```

### Phase 2: Core Setup (dalam Phase 1)

1. Setup folder structure
2. Create theme dari Figma
3. Setup routes dengan go_router
4. Create base widgets (loading, error, offline banner)

### Phase 3: Auth Feature (Jam 1-3.5)

1. Create auth models (User, OTP)
2. Create auth repository (abstract + mock impl)
3. Create auth bloc
4. Build Login page
5. Build Register page
6. Build OTP page dengan timer

### Phase 4: News Feature (Jam 3.5-5.5)

1. Create article models
2. Create news repository dengan GNews API
3. Create news bloc
4. Build News List page
5. Build News Detail page

### Phase 5: Search & Filter (Jam 5.5-6.5)

1. Add search to news bloc
2. Build search bar widget
3. Add category filter
4. Build category chips widget

### Phase 6: Polish (Jam 6.5-7.5)

1. Add loading states (shimmer)
2. Add error handling UI
3. Add offline indicator
4. Responsive adjustments
5. Match Figma design details

### Phase 7: Documentation & Deploy (Jam 7.5-8)

1. Complete README.md
2. Add architecture docs
3. Build web version
4. Deploy to Vercel/Netlify
5. Build APK (debug)
6. Final checklist

---

## 8. Stub Code Templates

### OTP Service (STUB)

```dart
// lib/shared/services/otp_service.dart

import 'dart:math';
import 'package:flutter/foundation.dart';

class OTPService {
  static final Map<String, OTPData> _otpStore = {};

  /// Generate 8-digit alphanumeric OTP
  static String _generateOTP() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
  }

  /// STUB: Send OTP to email
  /// Production: Integrate with SendGrid/Mailgun/AWS SES
  static Future<OTPResult> sendOTP(String email) async {
    final otp = _generateOTP();
    final expiry = DateTime.now().add(const Duration(minutes: 3));

    // Store OTP
    _otpStore[email] = OTPData(otp: otp, expiry: expiry);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // DEMO: Log OTP (production would send email)
    debugPrint('═══════════════════════════════════════');
    debugPrint('📧 DEMO MODE - OTP GENERATED');
    debugPrint('📬 Email: $email');
    debugPrint('🔑 OTP: $otp');
    debugPrint('⏰ Expires: $expiry');
    debugPrint('═══════════════════════════════════════');

    return OTPResult(
      success: true,
      otp: otp, // Return for demo display
      expiry: expiry,
      isDemo: true,
    );
  }

  /// Verify OTP
  static Future<bool> verifyOTP(String email, String inputOTP) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final stored = _otpStore[email];
    if (stored == null) return false;

    // Check expiry
    if (DateTime.now().isAfter(stored.expiry)) {
      _otpStore.remove(email);
      throw OTPExpiredException();
    }

    // Check match
    if (stored.otp != inputOTP.toUpperCase()) {
      return false;
    }

    // Clear OTP after successful verification
    _otpStore.remove(email);
    return true;
  }
}

class OTPData {
  final String otp;
  final DateTime expiry;

  OTPData({required this.otp, required this.expiry});
}

class OTPResult {
  final bool success;
  final String? otp;
  final DateTime? expiry;
  final bool isDemo;

  OTPResult({
    required this.success,
    this.otp,
    this.expiry,
    this.isDemo = false,
  });
}

class OTPExpiredException implements Exception {
  final String message = 'OTP expired, please request a new one';
}
```

### Session Service (STUB)

```dart
// lib/shared/services/session_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class SessionService {
  static const _sessionKey = 'active_session';
  static const _loginHistoryKey = 'login_history';

  /// STUB: Create session (local only)
  /// Production: Server-side session with Redis, device fingerprinting
  static Future<String> createSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    final sessionToken = const Uuid().v4();
    final sessionData = jsonEncode({
      'userId': userId,
      'token': sessionToken,
      'createdAt': DateTime.now().toIso8601String(),
      'device': 'demo_device_${DateTime.now().millisecondsSinceEpoch}',
    });

    await prefs.setString(_sessionKey, sessionData);

    debugPrint('[STUB] Session created: $sessionToken');
    debugPrint('[STUB] Production: POST /api/sessions + invalidate other devices');

    return sessionToken;
  }

  /// STUB: Validate session
  static Future<bool> validateSession() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_sessionKey);

    return data != null;
  }

  /// STUB: Check if first time login
  static Future<bool> isFirstTimeLogin(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_loginHistoryKey) ?? [];

    return !history.contains(email);
  }

  /// STUB: Record login
  static Future<void> recordLogin(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_loginHistoryKey) ?? [];

    if (!history.contains(email)) {
      history.add(email);
      await prefs.setStringList(_loginHistoryKey, history);
    }
  }

  /// Clear session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
```

### Auth Mock Datasource

```dart
// lib/features/auth/data/datasources/auth_local_datasource.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthLocalDatasource {
  static const _usersKey = 'mock_users';

  /// STUB: Mock user database
  /// Production: REST API with proper authentication

  Future<Map<String, dynamic>?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final users = await _getUsers();
    final user = users[email];

    if (user == null) {
      throw UserNotFoundException();
    }

    if (user['password'] != _hashPassword(password)) {
      throw InvalidCredentialsException();
    }

    debugPrint('[MOCK] Login successful for: $email');
    return user;
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final users = await _getUsers();

    if (users.containsKey(email)) {
      throw EmailAlreadyExistsException();
    }

    users[email] = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'password': _hashPassword(password),
      'createdAt': DateTime.now().toIso8601String(),
    };

    await _saveUsers(users);
    debugPrint('[MOCK] User registered: $email');
  }

  Future<Map<String, dynamic>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_usersKey);

    if (data == null) return {};
    return Map<String, dynamic>.from(jsonDecode(data));
  }

  Future<void> _saveUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}

class UserNotFoundException implements Exception {}
class InvalidCredentialsException implements Exception {}
class EmailAlreadyExistsException implements Exception {}
```

---

## 9. Time Allocation

### Strict 8-Hour Schedule

| Time | Duration | Task | Deliverable |
|------|----------|------|-------------|
| 00:00-01:00 | 1h | Setup + Architecture | Project skeleton, routing, theme |
| 01:00-01:30 | 0.5h | Login Page | UI + validation |
| 01:30-02:00 | 0.5h | Register Page | UI + validation |
| 02:00-03:00 | 1h | OTP Page + Timer | UI + countdown logic |
| 03:00-03:30 | 0.5h | Auth Bloc + Mock | State management |
| 03:30-04:30 | 1h | News List Page | UI + API integration |
| 04:30-05:00 | 0.5h | News Detail Page | UI |
| 05:00-05:30 | 0.5h | Search Feature | Search bar + logic |
| 05:30-06:00 | 0.5h | Category Filter | Filter chips + logic |
| 06:00-06:30 | 0.5h | Loading States | Shimmer + skeletons |
| 06:30-07:00 | 0.5h | Error Handling | Error UI + retry |
| 07:00-07:30 | 0.5h | Offline Indicator | Banner + detection |
| 07:30-08:00 | 0.5h | Docs + Deploy | README, build, deploy |

### Rules

```
⏰ STRICT STOP at 8 hours
❌ No "just 30 more minutes"
📝 Document incomplete features, don't rush
✅ Quality > Quantity
```

---

## 10. Deliverables Checklist

### Before Starting

- [ ] Read Figma design thoroughly
- [ ] Get GNews API key (https://gnews.io/)
- [ ] Setup .env.example

### Code Checklist

- [ ] LICENSE file in root
- [ ] Copyright headers in all files
- [ ] .gitignore includes .env
- [ ] No hardcoded API keys
- [ ] STUB markers clearly visible in code
- [ ] Demo mode indicators in UI

### Features Checklist

- [ ] Login page with validation
- [ ] Register page with validation
- [ ] OTP page with 3-min timer
- [ ] OTP verification (demo mode)
- [ ] News list from API
- [ ] News detail page
- [ ] Search by title
- [ ] Category filter
- [ ] Loading states
- [ ] Error states
- [ ] Offline indicator
- [ ] Responsive (basic)

### Documentation Checklist

- [ ] README.md comprehensive
- [ ] docs/ARCHITECTURE.md
- [ ] docs/STUB_IMPLEMENTATIONS.md
- [ ] docs/PRODUCTION_ROADMAP.md

### Deployment Checklist

- [ ] Web build successful
- [ ] Deployed to Vercel/Netlify
- [ ] Demo link working
- [ ] APK build (debug)
- [ ] GitHub repo public/accessible

### Submission Checklist

- [ ] All links working
- [ ] Demo credentials documented
- [ ] Time spent documented
- [ ] Email prepared
- [ ] Double-check recipient: dwi.handayani@yb.co.id

---

## API Reference

### GNews API

**Base URL:** `https://gnews.io/api/v4`

**Get Top Headlines:**
```
GET /top-headlines?category={category}&lang=en&country=us&max=10&apikey={API_KEY}
```

**Search:**
```
GET /search?q={query}&lang=en&max=10&apikey={API_KEY}
```

**Categories:** general, world, nation, business, technology, entertainment, sports, science, health

**Response:**
```json
{
  "totalArticles": 100,
  "articles": [
    {
      "title": "...",
      "description": "...",
      "content": "...",
      "url": "...",
      "image": "...",
      "publishedAt": "2024-01-15T10:00:00Z",
      "source": {
        "name": "...",
        "url": "..."
      }
    }
  ]
}
```

---

## Email Template for Submission

```
Subject: YB News Take Home Test Submission - [NAMA]

Yth. Tim Rekrutmen YB Sekuritas,

Berikut submission take home test saya:

📁 Repository: [GITHUB_LINK]
🌐 Demo Web: [VERCEL/NETLIFY_LINK]
📱 APK: [Attached / Google Drive link]

═══════════════════════════════════════

DEMO CREDENTIALS
Email: demo@example.com
Password: Demo1234
OTP: Ditampilkan di snackbar (demo mode)

═══════════════════════════════════════

CATATAN PENGERJAAN

Waktu yang dialokasikan: 8 jam
Fokus utama:
1. Clean architecture dan code quality
2. Auth flow dengan OTP (demo mode)
3. News integration dan UI/UX
4. Responsive design

Beberapa fitur menggunakan stub implementation untuk
mendemonstrasikan pemahaman arsitektur (detail di README).

═══════════════════════════════════════

Saya available untuk technical discussion mengenai
keputusan arsitektur dan trade-offs yang diambil.

Terima kasih atas kesempatannya.

Best regards,
[NAMA]
[EMAIL]
[PHONE]
```

---

## Notes for Next Session

```
1. Mulai dengan membaca Figma design
2. Daftar GNews API key
3. Setup Flutter project dengan struktur di atas
4. Follow time allocation strictly
5. Commit frequently dengan pesan jelas
6. Deploy early, iterate
7. STOP at 8 hours regardless
```

---

*Last updated: [DATE]*
*Plan version: 1.0*
