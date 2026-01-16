# Architecture Decisions

## Overview

This project follows Clean Architecture principles to demonstrate understanding of scalable, maintainable code structure.

---

## Layer Structure

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│    (BLoC, Pages, Widgets)               │
├─────────────────────────────────────────┤
│             Domain Layer                │
│    (Entities, Use Cases, Contracts)     │
├─────────────────────────────────────────┤
│              Data Layer                 │
│    (Models, Repositories, DataSources)  │
└─────────────────────────────────────────┘
```

### Dependency Rule

Dependencies point inward. Domain layer has no external dependencies.

---

## ADR-001: State Management - flutter_bloc

### Context

Need to manage complex state for auth flow (login, OTP, session) and news (list, search, filter).

### Decision

Use `flutter_bloc` instead of alternatives (Provider, Riverpod, GetX).

### Rationale

| Criteria | flutter_bloc | Provider | Riverpod | GetX |
|----------|--------------|----------|----------|------|
| Testability | Excellent | Good | Excellent | Poor |
| Scalability | Excellent | Medium | Excellent | Medium |
| Boilerplate | Medium | Low | Medium | Low |
| Learning curve | Medium | Low | Medium | Low |
| Separation of concerns | Excellent | Medium | Good | Poor |

### Consequences

- More boilerplate but clearer state transitions
- Easier to test and debug
- Better for demonstrating architectural understanding

---

## ADR-002: Routing - go_router

### Context

Need navigation with:
- Deep linking support
- Route guards (auth protection)
- Declarative approach

### Decision

Use `go_router` for routing.

### Rationale

- Official Flutter team package
- Declarative routing matches BLoC pattern
- Built-in redirect for auth guards
- Web URL support

### Implementation

```dart
final router = GoRouter(
  routes: [...],
  redirect: (context, state) {
    final isLoggedIn = authBloc.state.isAuthenticated;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');

    if (!isLoggedIn && !isAuthRoute) return '/auth/login';
    if (isLoggedIn && isAuthRoute) return '/';
    return null;
  },
);
```

---

## ADR-003: News API - GNews.io

### Context

Need public news API for fetching articles.

### Options Considered

1. **NewsAPI.org** - Popular, good documentation
2. **GNews.io** - Simpler, no CORS issues
3. **NYTimes API** - Limited, US-focused

### Decision

Use GNews.io

### Rationale

**NewsAPI CORS Issue:**
```
NewsAPI blocks requests from browser in production.
Only works in development mode.
Would require backend proxy for production.
```

**GNews Advantages:**
- Works directly from browser/app
- Simple API, sufficient for demo
- Free tier adequate for assessment

### Trade-offs

- Less articles than NewsAPI
- Fewer filtering options
- Acceptable for demo purposes

---

## ADR-004: Mock Backend Strategy

### Context

Backend is not provided. Need to demonstrate auth flow without real server.

### Decision

Use local mock with SharedPreferences + in-memory state.

### Implementation Strategy

```
┌─────────────────────────────────┐
│         Repository              │
│    (Abstract Contract)          │
├─────────────────────────────────┤
│    MockRepositoryImpl           │  ← Current
│    (SharedPreferences)          │
├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┤
│    RealRepositoryImpl           │  ← Production
│    (REST API + JWT)             │
└─────────────────────────────────┘
```

### Rationale

- Shows understanding of dependency injection
- Easy to swap implementations
- Demonstrates clean architecture benefit

---

## ADR-005: OTP Demo Mode

### Context

Real SMTP integration requires:
- External service setup (SendGrid/Mailgun)
- API keys and configuration
- Email templates
- Delivery verification

This is excessive for a take-home assessment.

### Decision

Implement OTP logic fully, but stub the delivery mechanism.

### Implementation

```dart
// Full OTP logic implemented:
// - Generate 8-char alphanumeric
// - 3-minute expiry
// - Validation
// - Resend cooldown

// Delivery is stubbed:
// - OTP shown in snackbar/console
// - Clearly marked as DEMO MODE
```

### Production Path

```dart
// Would integrate with:
abstract class EmailService {
  Future<void> sendOTP(String email, String otp);
}

class SendGridEmailService implements EmailService {
  @override
  Future<void> sendOTP(String email, String otp) async {
    // SendGrid API integration
  }
}
```

---

## Folder Structure Rationale

```
lib/
├── core/                 # App-wide, feature-agnostic
│   ├── config/           # Routes, theme, app config
│   ├── constants/        # API endpoints, app constants
│   ├── errors/           # Custom exceptions, failures
│   ├── network/          # Dio client, interceptors
│   └── utils/            # Validators, extensions
│
├── features/             # Feature modules
│   ├── auth/             # Self-contained auth feature
│   │   ├── data/         # Implementation details
│   │   ├── domain/       # Business logic contracts
│   │   └── presentation/ # UI layer
│   │
│   └── news/             # Self-contained news feature
│       └── ...
│
└── shared/               # Cross-feature shared code
    ├── widgets/          # Reusable UI components
    └── services/         # Shared services (OTP, session)
```

### Benefits

1. **Modularity** - Features are self-contained
2. **Scalability** - Easy to add new features
3. **Testability** - Clear boundaries for testing
4. **Maintainability** - Changes isolated to modules
