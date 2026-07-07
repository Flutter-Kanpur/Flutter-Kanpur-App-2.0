# 🛣️ ROUTING GUIDE - Flutter Kanpur Mobile App

**Status:** Complete ✅ | All routes use RouteNames constants  
**Last Updated:** 2026-07-06

---

## ✅ ROUTING ARCHITECTURE

### **Rule #1: ALWAYS use RouteNames, NEVER hardcode paths**
```dart
// ✅ CORRECT
context.push(RouteNames.communityAskQuestion);

// ❌ WRONG
context.push('/community/ask-question');
```

### **Rule #2: All routes defined in ONE place**
```
lib/app/router/
├── route_names.dart          ← ALL route constants
├── app_router.dart           ← ALL route registrations
└── navigation_helper.dart    ← Navigation utilities
```

---

## 🗺️ ROUTE MAP

### **Auth Routes** (No navigation shell)
```dart
RouteNames.splash           → SplashScreen
RouteNames.authLanding      → AuthLandingScreen
RouteNames.authOptions      → AuthOptionsScreen
RouteNames.signIn           → SignInScreen
RouteNames.signUp           → SignUpScreen
```

### **Bottom Navigation Routes** (With shell)
```dart
RouteNames.home             → HomeScreen
RouteNames.community        → CommunityScreen
RouteNames.events           → EventsScreen
RouteNames.blogs            → BlogsScreen
RouteNames.profile          → MyProfileScreen
```

### **Community Sub-Routes** (Nested under /community)
```dart
RouteNames.communityDiscussionsSegment
  → CommunityDiscussionsScreen

RouteNames.communityQuestionsSegment
  → QuestionListScreen

RouteNames.communityQuestionDetailSegment  (dynamic: :id)
  → QuestionDetailScreen(questionId)

RouteNames.communityAskQuestionSegment
  → AskQuestionScreen

RouteNames.communityMembersSegment
  → CommunityMembersScreen

RouteNames.communityProjectsSegment
  → CommunityProjectsScreen
```

---

## 🚀 NAVIGATION PATTERNS

### **Pattern 1: Simple Navigation**
```dart
// Using go_router context.push()
context.push(RouteNames.communityAskQuestion);

// Or use NavigationHelper
NavigationHelper.goToAskQuestion(context);
```

### **Pattern 2: Dynamic Route (with ID parameter)**
```dart
// Define in route_names.dart:
// static const communityQuestion = '/community/question/:id';

// Navigate with ID:
context.push(
  RouteNames.communityQuestion.replaceFirst(':id', questionId)
);

// Receive in screen:
class QuestionDetailScreen extends StatefulWidget {
  final String questionId;
  QuestionDetailScreen({required this.questionId});
}
```

### **Pattern 3: Navigation with Extra Data**
```dart
// Pass extra data
context.push(
  RouteNames.communityQuestion.replaceFirst(':id', id),
  extra: {'scrollTo': 'answers'},
);

// Receive
final extra = state.extra as Map<String, dynamic>?;
final scrollTo = extra?['scrollTo'];
```

### **Pattern 4: Replace Route (no back)**
```dart
context.go(RouteNames.home);  // ← Clears navigation stack
```

### **Pattern 5: Pop to Previous**
```dart
context.pop();  // ← Go back
```

---

## 📋 COMMON NAVIGATION TASKS

### **Task 1: Navigate to Ask Question**
```dart
// From any screen:
context.push(RouteNames.communityAskQuestion);

// After success in AskQuestionScreen:
context.pop();  // Go back to questions list
```

### **Task 2: View Question Details**
```dart
// From QuestionListScreen:
context.push(
  RouteNames.communityQuestion.replaceFirst(':id', question.id),
);

// Receives in QuestionDetailScreen:
final questionId = state.pathParameters['id']!;
return QuestionDetailScreen(questionId: questionId);
```

### **Task 3: Navigate to Profile**
```dart
context.push(RouteNames.profile);
```

### **Task 4: Go Home and Clear Stack**
```dart
context.go(RouteNames.home);
```

---

## 🎯 ADDING NEW ROUTES (Step-by-Step)

### **Step 1: Add constant to route_names.dart**
```dart
class RouteNames {
  static const myNewRoute = '/my/new/route';
  static const myNewRouteSegment = 'new-route';
}
```

### **Step 2: Import screen in app_router.dart**
```dart
import 'package:flutter_knp_mobile_app_v2/modules/my/presentation/screens/my_screen.dart';
```

### **Step 3: Register route in GoRouter**
```dart
GoRoute(
  path: RouteNames.myNewRouteSegment,
  builder: (context, state) => const MyScreen(),
),
```

### **Step 4: Use in navigation**
```dart
context.push(RouteNames.myNewRoute);
```

---

## 🔗 ROUTE STRUCTURE

```
GoRouter (appRouter)
├── StatefulShellRoute (Bottom Navigation)
│   ├── Branch: Home
│   │   └── HomeScreen
│   ├── Branch: Community
│   │   ├── CommunityScreen (parent)
│   │   ├── ├── DiscussionsScreen
│   │   ├── ├── QuestionsScreen ← NEW
│   │   ├── ├── QuestionDetailScreen ← NEW (dynamic)
│   │   ├── ├── AskQuestionScreen
│   │   ├── ├── MembersScreen
│   │   ├── ├── ProjectsScreen
│   │   └── └── ...
│   ├── Branch: Events
│   │   └── EventsScreen
│   ├── Branch: Blogs
│   │   └── BlogsScreen
│   └── Branch: Profile
│       └── MyProfileScreen
├── SplashScreen (top-level)
├── AuthLandingScreen (top-level)
├── AuthOptionsScreen (top-level)
├── SignInScreen (top-level)
├── SignUpScreen (top-level)
└── ... other top-level routes
```

---

## ⚙️ QUERY PARAMETERS (Advanced)

### **Pass query params**
```dart
context.push('${RouteNames.communityQuestions}?sort=newest&filter=open');
```

### **Receive query params**
```dart
final sort = state.uri.queryParameters['sort'] ?? 'newest';
final filter = state.uri.queryParameters['filter'] ?? 'open';
```

---

## 🚨 ROUTING BEST PRACTICES

### ✅ DO:
- Use `RouteNames.` constants for ALL navigation
- Keep route definitions in `route_names.dart`
- Use dynamic routes (`:id`) for detail screens
- Pop after successful form submissions
- Use `context.go()` to reset navigation stack
- Update `navigation_helper.dart` for common flows

### ❌ DON'T:
- Hardcode route paths (`'/community/questions'`)
- Define routes in multiple places
- Use magic strings for route names
- Forget to add RouteNames constants
- Mix navigation patterns in same feature

---

## 📊 ROUTING DIAGRAM

```
User opens app
    ↓
SplashScreen (RouteNames.splash)
    ↓
    ├─→ AuthLandingScreen (if not logged in)
    │   ├─→ SignInScreen
    │   └─→ SignUpScreen
    │
    └─→ HomeScreen (if logged in)
        ↓
        Bottom Nav Shell
        ├─→ Home Tab
        ├─→ Community Tab
        │   ├─→ Discussions (CommunityDiscussionsScreen)
        │   ├─→ Questions (QuestionListScreen) ← NEW
        │   │   ├─→ Ask Question (AskQuestionScreen)
        │   │   └─→ Question Detail (QuestionDetailScreen) ← NEW
        │   ├─→ Members
        │   └─→ Projects
        ├─→ Events Tab
        ├─→ Blogs Tab
        └─→ Profile Tab
```

---

## 🔄 NAVIGATION FLOW EXAMPLE

```dart
// User navigates: Home → Community → Questions → Ask Question → Detail

// 1. Home to Community
context.push(RouteNames.community);

// 2. Community to Questions
context.push(RouteNames.communityQuestions);

// 3. Questions to Ask
context.push(RouteNames.communityAskQuestion);

// 4. Ask Question (submit)
await api.createQuestion(request);
context.pop();  // Back to Questions

// 5. Questions to Detail
context.push(
  RouteNames.communityQuestion.replaceFirst(':id', questionId)
);

// 6. Detail back to Questions
context.pop();
```

---

## 🎯 NEW ROUTES SUMMARY (This Session)

| Screen | Route | Type | Path |
|--------|-------|------|------|
| QuestionListScreen | `communityQuestions` | Static | `/community/questions` |
| QuestionDetailScreen | `communityQuestion` | Dynamic | `/community/question/:id` |
| AskQuestionScreen | `communityAskQuestion` | Static | `/community/ask-question` |

---

## ✅ VERIFICATION CHECKLIST

- [x] All routes use `RouteNames` constants
- [x] No hardcoded paths in navigation
- [x] Dynamic routes with `:id` parameters
- [x] Routes registered in `app_router.dart`
- [x] Imports added for all screens
- [x] Navigation helper updated
- [x] Screens use `context.push()` / `context.pop()`
- [x] Error screens handle back navigation

---

**Next Developer:** When adding a new screen, ALWAYS follow the 4-step process above. Every route must have a RouteNames constant!

---

**Created:** 2026-07-06  
**Updated:** 2026-07-06  
**Responsibility:** App Architecture Team
