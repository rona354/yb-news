# Production Roadmap

If this project were to be developed into a production application, the following enhancements would be implemented.

---

## Phase 1: Core Infrastructure

### 1.1 Backend API

```
Endpoints needed:
POST   /auth/register
POST   /auth/login
POST   /auth/otp/send
POST   /auth/otp/verify
POST   /auth/logout
GET    /auth/session/validate
DELETE /auth/sessions (invalidate other devices)

GET    /news
GET    /news/:id
GET    /news/search?q=
GET    /news/categories
```

**Tech Stack:**
- Node.js + Express / NestJS
- PostgreSQL for users
- Redis for sessions & OTP
- JWT for authentication

### 1.2 Real SMTP Integration

**Options:**
1. **SendGrid** - Best deliverability, templates
2. **Mailgun** - Good API, cheaper
3. **AWS SES** - Cheapest at scale

**Implementation:**
- Email templates for OTP
- Delivery tracking
- Bounce handling
- Rate limiting

### 1.3 Session Management

**Architecture:**
```
┌─────────┐     ┌─────────┐     ┌─────────┐
│ Device  │────▶│   API   │────▶│  Redis  │
│    A    │     │ Server  │     │Sessions │
└─────────┘     └────┬────┘     └─────────┘
                     │
                     ▼
              ┌─────────────┐
              │  WebSocket  │
              │   Server    │
              └──────┬──────┘
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
    ┌─────────┐           ┌─────────┐
    │ Device  │           │ Device  │
    │    B    │           │    C    │
    └─────────┘           └─────────┘

On login from Device A:
1. Create session in Redis
2. Find other sessions for user
3. Send WebSocket "SESSION_INVALIDATED" to other devices
4. Delete other sessions from Redis
```

---

## Phase 2: Enhanced Features

### 2.1 Offline Support

**Data Layer:**
```dart
class NewsRepository {
  final NewsRemoteDataSource remote;
  final NewsLocalDataSource local;  // Hive
  final NetworkInfo networkInfo;

  Future<List<Article>> getArticles() async {
    if (await networkInfo.isConnected) {
      final articles = await remote.getArticles();
      await local.cacheArticles(articles);
      return articles;
    } else {
      return local.getCachedArticles();
    }
  }
}
```

**State Preservation:**
- Serialize navigation stack
- Persist form inputs
- Save scroll positions
- Queue failed requests

### 2.2 Pagination

```dart
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  static const _pageSize = 20;

  Future<void> _onLoadMore(LoadMore event, Emitter emit) async {
    if (state.hasReachedMax) return;

    final articles = await repository.getArticles(
      page: state.currentPage + 1,
      pageSize: _pageSize,
    );

    emit(state.copyWith(
      articles: [...state.articles, ...articles],
      currentPage: state.currentPage + 1,
      hasReachedMax: articles.length < _pageSize,
    ));
  }
}
```

### 2.3 Bookmarks

```dart
class BookmarkService {
  final Box<Article> bookmarkBox;

  Future<void> toggle(Article article) async {
    if (bookmarkBox.containsKey(article.id)) {
      await bookmarkBox.delete(article.id);
    } else {
      await bookmarkBox.put(article.id, article);
    }
  }

  List<Article> getAll() => bookmarkBox.values.toList();

  bool isBookmarked(String id) => bookmarkBox.containsKey(id);
}
```

### 2.4 Share Feature

```dart
import 'package:share_plus/share_plus.dart';

void shareArticle(Article article) {
  final text = '${article.title}\n\nRead more: ${article.url}';

  Share.share(
    text,
    subject: article.title,
  );
}

// WhatsApp specific
void shareToWhatsApp(Article article) {
  final url = 'whatsapp://send?text=${Uri.encodeComponent(text)}';
  launchUrl(Uri.parse(url));
}
```

---

## Phase 3: Quality & Polish

### 3.1 Testing

**Unit Tests:**
```dart
void main() {
  group('OTPService', () {
    test('generates 8-character alphanumeric OTP', () {
      final otp = OTPService.generateOTP();
      expect(otp.length, 8);
      expect(otp, matches(RegExp(r'^[A-Z0-9]+$')));
    });

    test('OTP expires after 3 minutes', () async {
      final result = await OTPService.sendOTP('test@example.com');

      // Fast-forward time
      clock.advance(Duration(minutes: 4));

      expect(
        () => OTPService.verifyOTP('test@example.com', result.otp),
        throwsA(isA<OTPExpiredException>()),
      );
    });
  });
}
```

**Widget Tests:**
```dart
testWidgets('Login page validates email format', (tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginPage()));

  await tester.enterText(find.byKey(Key('email_field')), 'invalid');
  await tester.tap(find.byKey(Key('login_button')));
  await tester.pump();

  expect(find.text('Invalid email format'), findsOneWidget);
});
```

**Integration Tests:**
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full login flow', (tester) async {
    await tester.pumpWidget(MyApp());

    // Register
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();
    // ... fill form

    // Login
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    // ... fill form

    // Verify OTP
    // ... enter OTP

    // Should be on home page
    expect(find.text('Top Headlines'), findsOneWidget);
  });
}
```

### 3.2 Animations

```dart
// Page transitions
GoRouter(
  routes: [...],
  observers: [HeroController()],
);

// Custom transition
CustomTransitionPage(
  child: page,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  },
);
```

### 3.3 Error Monitoring

```dart
// Sentry integration
Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://...@sentry.io/...';
      options.tracesSampleRate = 0.2;
    },
    appRunner: () => runApp(MyApp()),
  );
}

// Error boundary
class ErrorBoundary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.error != null) {
          Sentry.captureException(state.error);
        }
      },
      child: child,
    );
  }
}
```

---

## Estimated Effort

| Phase | Features | Effort |
|-------|----------|--------|
| Phase 1 | Backend, SMTP, Sessions | 2-3 weeks |
| Phase 2 | Offline, Pagination, Bookmarks, Share | 1-2 weeks |
| Phase 3 | Testing, Animations, Monitoring | 1-2 weeks |
| **Total** | Production-ready | **4-7 weeks** |

---

## Infrastructure Requirements

**Development:**
- CI/CD pipeline (GitHub Actions / GitLab CI)
- Code review process
- Staging environment

**Production:**
- Cloud hosting (AWS / GCP / Azure)
- CDN for assets
- Database backups
- Monitoring & alerting
- Log aggregation

**Security:**
- HTTPS everywhere
- Rate limiting
- Input sanitization
- Security headers
- Regular dependency updates
