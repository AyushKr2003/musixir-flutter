# State Management in Riverpod

## Using `.notifier` vs Direct Provider Access

### 1. Simple Providers (Without `.notifier`)
```dart
_authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
_authLocalRepository = ref.watch(authLocalRepositoryProvider);
```
- Used for providers that just return instances (like repositories)
- Created using basic `@riverpod` annotation
- No state management involved
- Returns the value directly

### 2. Notifier Providers (With `.notifier`)
```dart
_currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
```
- Used for providers that manage state
- Created using `NotifierProvider` or classes extending generated notifiers
- `.notifier` gives access to the methods that modify state
- Without `.notifier`, you get the current state value

### Example of a Notifier Provider:
```dart
@riverpod
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  UserModel? build() => null;  // initial state

  // Methods to modify state
  void setUser(UserModel user) {
    state = user;
  }
  
  void clearUser() {
    state = null;
  }
}

// Different ways to access:
ref.watch(currentUserNotifierProvider) // gets the current UserModel? state
ref.watch(currentUserNotifierProvider.notifier) // gets access to setUser() and clearUser() methods
```

## State Updates
1. **Direct State Updates**
```dart
state = newValue;  // Inside a notifier
```

2. **Async State Updates**
```dart
state = const AsyncValue.loading();
try {
  final result = await someAsyncOperation();
  state = AsyncValue.data(result);
} catch (e, st) {
  state = AsyncValue.error(e, st);
}
```

[Back to README](README.md)
