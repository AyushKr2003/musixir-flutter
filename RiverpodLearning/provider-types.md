# Provider Types and Modifiers

## Provider Annotations

### 1. Basic @riverpod
```dart
@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AsyncValue<UserModel>? build() {
    return null;
  }
}
```
- Provider is automatically disposed when no longer in use
- Good for most use cases
- Helps prevent memory leaks
- Ideal for scoped features (like page-specific providers)

### 2. @Riverpod(keepAlive: true)
```dart
@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  UserModel? build() {
    return null;
  }

  void addUser(UserModel user){
    state = user;
  }
}
```
- Provider stays alive even when no one is listening
- Use for global state that needs to persist
- Common use cases:
  - User authentication state
  - App-wide configuration
  - Cached data that should persist
- Be cautious: Can lead to memory usage if overused

### When to Use Each

#### Use @riverpod (Auto-dispose) when:
- State is specific to a screen or feature
- You want automatic cleanup
- Managing temporary UI states
- Handling form data
- Making API calls specific to a feature

#### Use @Riverpod(keepAlive: true) when:
- State needs to persist throughout app lifecycle
- Managing authentication state
- Storing user preferences
- Caching data that should survive navigation
- Managing global app state

### Best Practices
1. Default to using `@riverpod` (auto-dispose)
2. Only use `keepAlive: true` when you have a specific reason
3. Document why you're using `keepAlive: true`
4. Consider using other patterns (like caching) instead of `keepAlive`

[Back to README](README.md)
