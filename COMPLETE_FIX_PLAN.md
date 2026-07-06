# 🎯 FLUTTER KANPUR - COMPLETE FIX PLAN
**Status:** Database Seeded ✅ | App Code Audit Complete ✅ | Ready to Fix ⚡

---

## 📊 PROJECT OVERVIEW

### Current State
- **Total Dart Files:** 141
- **Modules:** 7 (auth, blogs, community, events, home, onboarding, profile)
- **Database Tables:** 35+ (all seeded with real auth.users)
- **Real Auth Users:** 2+ (synced to public.users)

### Database Status
✅ All tables seeded with real data
✅ FK constraints intact (using real auth.users UIDs)
✅ Audit logs ready for error tracking
✅ User skills, projects, questions, answers loaded
✅ Events, contests, hackathons, badges all populated

---

## 🔴 CRITICAL GAPS TO FIX

### 1. **API & REST ENDPOINTS** ⚠️
**Missing:**
- [ ] Community API service with POST/GET endpoints
- [ ] Error handling (PostgrestException catching)
- [ ] Pagination with offset/limit
- [ ] JSON request/response models
- [ ] HTTP status code handling

**Need to Create:**
```
lib/modules/community/data/services/
  ├── community_api_service.dart (REST endpoints)
  ├── community_error_logger.dart (error logging)
  └── upload_service.dart (file uploads)
```

---

### 2. **STATE MANAGEMENT (Riverpod)** ⚠️
**Missing Providers:**
- [ ] questionsProvider - Load all questions
- [ ] questionDetailProvider.family - Single question + answers
- [ ] createQuestionProvider - Submit new question
- [ ] answersProvider.family - Load answers for question
- [ ] projectsProvider - Load all projects
- [ ] eventsProvider - Load events
- [ ] currentUserProvider - Logged-in user data
- [ ] userDeviceProvider - Device info & FCM token
- [ ] dropdownDataProvider - Categories, tags, statuses

**Pattern to Use:**
```dart
// For async data
final questionsProvider = FutureProvider.autoDispose<List<Question>>((ref) async {
  final api = ref.watch(communityApiServiceProvider);
  return api.getQuestions();
});

// For state
final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

// For mutations
final createQuestionProvider = FutureProvider.autoDispose.family<Question, CreateQuestionRequest>((ref, request) async {
  final api = ref.watch(communityApiServiceProvider);
  final result = await api.createQuestion(request);
  ref.invalidate(questionsProvider); // Refresh list
  return result;
});
```

---

### 3. **ERROR LOGGING & LOGGING** ⚠️
**Missing:**
- [ ] Error logging to `audit_logs` table
- [ ] Success logging for important actions
- [ ] API call metrics (duration, status code)
- [ ] Stack trace capture
- [ ] User action tracking

**Service to Create:**
```dart
// community_error_logger.dart
class CommunityErrorLogger {
  Future<void> logError({
    required String action,
    required String entityType,
    required String error,
    String? stackTrace,
    Map<String, dynamic>? metadata,
  });

  Future<void> logSuccess({
    required String action,
    required String entityType,
    required String entityId,
    Map<String, dynamic>? metadata,
  });

  Future<void> logApiCall({
    required String method,
    required String endpoint,
    required int statusCode,
    required int durationMs,
    String? errorMessage,
  });
}
```

---

### 4. **IMAGE LOADING & CACHING** ⚠️
**Missing:**
- [ ] `cached_network_image` integration
- [ ] Image placeholder handling
- [ ] Error state UI
- [ ] Local cache management
- [ ] Profile picture caching
- [ ] Project screenshot caching

**Need to Add to pubspec.yaml:**
```yaml
cached_network_image: ^3.2.0
```

**Usage Pattern:**
```dart
CachedNetworkImage(
  imageUrl: 'https://...',
  placeholder: (context, url) => Shimmer.fromColors(...),
  errorWidget: (context, url, error) => Icon(Icons.error),
  fadeInDuration: Duration(milliseconds: 300),
)
```

---

### 5. **FILE UPLOAD SERVICE** ⚠️
**Missing:**
- [ ] File picker integration
- [ ] Supabase Storage upload
- [ ] Progress tracking
- [ ] Error handling
- [ ] File validation (size, type)
- [ ] Retry logic

**Service to Create:**
```dart
class UploadService {
  Future<String> uploadFile({
    required File file,
    required String bucket,
    required String path,
    Function(int)? onProgress,
  });

  Future<List<String>> uploadMultiple({
    required List<File> files,
    required String bucket,
    required String path,
  });

  Future<void> deleteFile(String path);
}
```

---

### 6. **FCM & DEVICE INFO TRACKING** ⚠️
**Missing:**
- [ ] FCM token generation
- [ ] Device info collection (platform, app version)
- [ ] Save to `user_devices` table
- [ ] Update on app launch
- [ ] Handle token refresh

**Need in pubspec.yaml:**
```yaml
firebase_messaging: ^14.6.0
device_info_plus: ^9.1.0
```

---

### 7. **USER AUTH & SESSION MANAGEMENT** ⚠️
**Missing:**
- [ ] Get current user ID from `Supabase.instance.client.auth.currentUser?.id`
- [ ] Save/refresh auth token
- [ ] Session timeout handling
- [ ] Login time tracking
- [ ] Re-auth on token expiry

**Pattern:**
```dart
// In any provider/service
final userId = Supabase.instance.client.auth.currentUser?.id;
if (userId == null) {
  // User not authenticated - redirect to login
  throw AuthException('User not authenticated');
}
```

---

### 8. **PAGINATION & LAZY LOADING** ⚠️
**Missing:**
- [ ] Offset/limit implementation
- [ ] Load more button
- [ ] Infinite scroll
- [ ] Cache previous pages
- [ ] Prevent duplicate requests

**Pattern:**
```dart
final questionsPageProvider = FutureProvider.autoDispose.family<List<Question>, int>((ref, page) async {
  final api = ref.watch(communityApiServiceProvider);
  final limit = 20;
  final offset = page * limit;
  return api.getQuestions(limit: limit, offset: offset);
});
```

---

### 9. **DROPDOWN STATE MANAGEMENT** ⚠️
**Missing:**
- [ ] Category dropdown
- [ ] Tag selection (multi-select)
- [ ] Status filter dropdown
- [ ] Role selection dropdown
- [ ] Load dropdown data on init
- [ ] Handle selection state

**Pattern:**
```dart
// Load categories
final categoriesProvider = FutureProvider((ref) async {
  final api = ref.watch(communityApiServiceProvider);
  return api.getCategories();
});

// Track selected
final selectedCategoryProvider = StateProvider<String>((ref) => 'all');
```

---

### 10. **JSON MODELS & SERIALIZATION** ⚠️
**Missing:**
- [ ] Proper fromMap/toMap for all models
- [ ] null safety handling
- [ ] Type conversion
- [ ] Request DTOs (CreateQuestionRequest, etc.)
- [ ] Response DTOs

**Pattern:**
```dart
class Question {
  final String id;
  final String title;
  final String body;
  final String authorUid;
  
  Question({required this.id, required this.title, ...});
  
  factory Question.fromMap(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      authorUid: json['author_uid'] as String,
    );
  }
  
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'body': body,
    'author_uid': authorUid,
  };
}
```

---

### 11. **VALIDATION** ⚠️
**Missing:**
- [ ] Title validation (10-500 chars)
- [ ] Body validation (20-5000 chars)
- [ ] Email validation
- [ ] File size validation
- [ ] Show errors below fields in red

---

### 12. **UI SCREENS TO FIX** ⚠️
**Community Module:**
- [ ] ask_question_screen.dart - Form validation, file upload, user ID
- [ ] question_list_screen.dart - Load from provider, pagination
- [ ] question_detail_screen.dart - Load question + answers, post answer
- [ ] featured_discussions_screen.dart - Load featured items

**Other Modules:**
- [ ] All project screens - Load data from projectsProvider
- [ ] All event screens - Load data from eventsProvider
- [ ] Profile screen - Load user data, show device info, FCM status

---

## 🛠️ IMPLEMENTATION ORDER

### Phase 1: Services (2-3 hours) ⭐ START HERE
1. Create `community_api_service.dart` with REST endpoints
2. Create `community_error_logger.dart` for logging
3. Create `upload_service.dart` for file uploads
4. Add required packages (cached_network_image, firebase_messaging, device_info_plus)

### Phase 2: Models (1 hour)
5. Create all JSON models with proper fromMap/toMap
6. Create request DTOs (CreateQuestionRequest, etc.)

### Phase 3: Riverpod Providers (2 hours)
7. Create all FutureProviders for data loading
8. Create StateProviders for UI state (dropdowns, selections)
9. Create FamilyProviders for parameterized queries

### Phase 4: Services Integration (1.5 hours)
10. FCM token generation and save
11. Device info collection
12. Session management
13. Auth token handling

### Phase 5: UI Screens (3-4 hours)
14. Fix ask_question_screen.dart
15. Fix question_list_screen.dart
16. Fix question_detail_screen.dart
17. Fix all other screens

### Phase 6: Testing & Polish (1-2 hours)
18. Test all flows end-to-end
19. Verify error logging in audit_logs
20. Check image caching

---

## 📋 CHECKLIST

### Database ✅
- [x] All 35+ tables seeded
- [x] Real auth.users synced
- [x] FK constraints intact
- [x] Sample questions, answers, projects
- [x] Audit logs table ready

### API Layer
- [ ] community_api_service.dart
- [ ] Error handling with PostgrestException
- [ ] Pagination support
- [ ] Proper status codes

### State Management
- [ ] questionsProvider
- [ ] questionDetailProvider.family
- [ ] createQuestionProvider
- [ ] answersProvider.family
- [ ] Drop-down providers
- [ ] User device provider
- [ ] Category/tag providers

### Services
- [ ] Error logging service
- [ ] Upload service
- [ ] FCM token service
- [ ] Device info service
- [ ] Auth/session service

### UI
- [ ] Ask question form validation
- [ ] Question list with pagination
- [ ] Image caching
- [ ] File upload UI
- [ ] Error messages
- [ ] Loading states

---

## 🚀 NEXT STEPS

**Start with Phase 1 (Services):**
1. Create `lib/modules/community/data/services/community_api_service.dart`
2. Create `lib/modules/community/data/services/community_error_logger.dart`
3. Create `lib/modules/community/data/services/upload_service.dart`
4. Update `pubspec.yaml` with required packages

Then we'll build providers, models, and screens on top of these services.

---

## 📞 QUICK REFERENCE

### Supabase API Calls
```dart
final response = await Supabase.instance.client
  .from('questions')
  .select('*, author:users!author_uid(*)')
  .limit(20)
  .offset(0);
```

### Error Logging
```dart
try {
  await api.createQuestion(request);
} on PostgrestException catch (e) {
  await errorLogger.logError(
    action: 'create_question',
    entityType: 'question',
    error: e.message,
    stackTrace: e.toString(),
  );
  showErrorSnackBar(e.message);
}
```

### User ID
```dart
final userId = Supabase.instance.client.auth.currentUser?.id;
```

### Image Caching
```dart
CachedNetworkImage(
  imageUrl: url,
  placeholder: (_, __) => Shimmer(),
)
```

---

**Created:** 2026-07-06  
**Status:** Ready for implementation  
**Estimated Time:** 8-12 hours
