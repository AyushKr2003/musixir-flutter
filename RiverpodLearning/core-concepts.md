# Core Riverpod Concepts

## Provider Creation and Code Generation
```dart
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AsyncValue<UserModel>? build() {
    // initialization code
  }
}
```
- `@riverpod` annotation generates a provider
- Generated code goes into `.g.dart` files
- Provider names follow the pattern: `[className]Provider`

## AsyncValue States
```dart
AsyncValue<UserModel>? state;

// Different states:
state = const AsyncValue.loading();    // Loading state
state = AsyncValue.data(userData);     // Success state with data
state = AsyncValue.error(error, stackTrace);  // Error state
```

## Consumer Widgets
```dart
// StatefulWidget version
class SignupPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

// State class
class _SignupPageState extends ConsumerState<SignupPage> {
  // ref is available throughout the widget lifecycle
}
```

## Provider Access Methods

### ref.watch()
```dart
final isLoading = ref.watch(authViewModelProvider)?.isLoading;
```
- Used to watch provider state changes
- Rebuilds widget when provider updates
- Best for UI that needs to react to state changes

### ref.listen()
```dart
ref.listen(
  authViewModelProvider,
  (previous, next) {
    next?.when(
      data: (data) => handleSuccess(data),
      error: (error, stack) => handleError(error),
      loading: () => handleLoading(),
    );
  },
);
```
- Used for side effects (navigation, toasts, etc.)
- Doesn't cause rebuilds
- Provides both previous and next state

### ref.read()
```dart
ref.read(authViewModelProvider.notifier).signUpUser(
  name: name,
  email: email,
  password: password,
);
```
- Used for one-time actions
- Doesn't create subscription
- Best for triggering actions/methods

[Back to README](README.md)
