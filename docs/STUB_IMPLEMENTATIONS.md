# Stub Implementations

This document details features that are intentionally implemented as stubs/demos for this assessment.

---

## 1. OTP Email Delivery

### Current (Stub)

```dart
static Future<OTPResult> sendOTP(String email) async {
  final otp = _generateOTP();  // Full implementation

  // STUB: Display instead of send
  debugPrint('📧 DEMO MODE - OTP: $otp');

  return OTPResult(otp: otp, isDemo: true);
}
```

**What works:**
- OTP generation (8-char alphanumeric)
- 3-minute expiry logic
- Resend cooldown timer
- Validation

**What's stubbed:**
- Actual email delivery (shown in UI instead)

### Production Implementation

```dart
class SendGridEmailService implements EmailService {
  final String apiKey;
  final String templateId;

  @override
  Future<void> sendOTP(String email, String otp) async {
    final response = await http.post(
      Uri.parse('https://api.sendgrid.com/v3/mail/send'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'personalizations': [{'to': [{'email': email}]}],
        'template_id': templateId,
        'dynamic_template_data': {
          'otp': otp,
          'expiry_minutes': 3,
        },
      }),
    );

    if (response.statusCode != 202) {
      throw EmailDeliveryException();
    }
  }
}
```

---

## 2. Authentication Backend

### Current (Stub)

```dart
class AuthLocalDatasource {
  static final Map<String, UserData> _users = {};

  Future<UserData?> login(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 800)); // Simulate network
    return _users[email];
  }
}
```

**What works:**
- User registration flow
- Login validation
- Password hashing (SHA256)
- First-time login detection

**What's stubbed:**
- Data persistence (in-memory, lost on restart)
- Real API calls

### Production Implementation

```dart
class AuthRemoteDatasource {
  final Dio dio;

  Future<AuthResponse> login(String email, String password) async {
    final response = await dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    return AuthResponse.fromJson(response.data);
  }

  Future<void> register(RegisterRequest request) async {
    await dio.post('/auth/register', data: request.toJson());
  }
}

// With JWT handling
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenStorage.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

---

## 3. Single Device Login

### Current (Stub)

```dart
class SessionService {
  static Future<String> createSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = Uuid().v4();

    await prefs.setString('session', token);
    // Only validates locally

    return token;
  }
}
```

**What works:**
- Session token generation
- Local session storage
- Session validation (local only)

**What's stubbed:**
- Cross-device invalidation
- Real-time session checks

### Production Implementation

```dart
class SessionService {
  final RedisClient redis;
  final WebSocketService ws;

  Future<String> createSession(String userId, String deviceId) async {
    // Invalidate other sessions
    final existingSessions = await redis.keys('session:$userId:*');
    for (final key in existingSessions) {
      final oldDeviceId = key.split(':').last;

      // Notify other device
      await ws.send(oldDeviceId, {'type': 'SESSION_INVALIDATED'});

      // Remove session
      await redis.del(key);
    }

    // Create new session
    final token = Uuid().v4();
    await redis.setex(
      'session:$userId:$deviceId',
      Duration(days: 7).inSeconds,
      jsonEncode({'token': token, 'createdAt': DateTime.now()}),
    );

    return token;
  }

  Future<bool> validateSession(String userId, String token) async {
    final sessions = await redis.keys('session:$userId:*');
    for (final key in sessions) {
      final data = jsonDecode(await redis.get(key));
      if (data['token'] == token) return true;
    }
    return false;
  }
}
```

---

## 4. Reconnection State Preservation

### Current (Stub)

```dart
class ConnectivityService {
  Stream<bool> get onlineStatus {
    return Connectivity().onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }
}

// UI shows banner only
if (!isOnline) OfflineBanner();
```

**What works:**
- Online/offline detection
- Visual indicator

**What's stubbed:**
- State serialization
- Automatic state restoration
- Request queue

### Production Implementation

```dart
class StatePreservationService {
  final Box<dynamic> stateBox; // Hive

  Future<void> saveState(AppState state) async {
    await stateBox.put('app_state', {
      'currentRoute': state.currentRoute,
      'newsFilters': state.newsFilters.toJson(),
      'searchQuery': state.searchQuery,
      'scrollPositions': state.scrollPositions,
      'formData': state.formData,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<AppState?> restoreState() async {
    final data = stateBox.get('app_state');
    if (data == null) return null;

    final timestamp = DateTime.parse(data['timestamp']);
    if (DateTime.now().difference(timestamp) > Duration(hours: 24)) {
      await stateBox.delete('app_state');
      return null;
    }

    return AppState.fromJson(data);
  }
}

class RequestQueueService {
  final Queue<PendingRequest> _queue = Queue();

  void enqueue(PendingRequest request) {
    _queue.add(request);
    _persistQueue();
  }

  Future<void> processQueue() async {
    while (_queue.isNotEmpty) {
      final request = _queue.first;
      try {
        await request.execute();
        _queue.removeFirst();
        _persistQueue();
      } catch (e) {
        if (!_isNetworkError(e)) {
          _queue.removeFirst(); // Don't retry non-network errors
        }
        break;
      }
    }
  }
}
```

---

## Summary Table

| Feature | Stub Level | Production Effort |
|---------|------------|-------------------|
| OTP Generation | Full | - |
| OTP Delivery | Demo (snackbar) | 2-4 hours |
| Auth Logic | Full | - |
| Auth Backend | Mock (local) | 4-8 hours |
| Single Device | Local only | 4-6 hours |
| Reconnection | Indicator only | 6-10 hours |

---

## Why Stubs?

1. **Time Constraint** - 8-hour budget for full assessment
2. **Evaluation Focus** - Demonstrating architecture > full implementation
3. **Anti-exploitation** - Not providing production-ready code for free
4. **Documentation** - Showing understanding through docs instead
