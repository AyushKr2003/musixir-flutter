import 'package:client/core/model/user_model.dart';
import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// This generates the code for our Riverpod provider
// The generated code will be in auth_viewmodel.g.dart
part 'auth_viewmodel.g.dart';

// @riverpod annotation marks this class as a Riverpod provider
// This will generate a provider named authViewModelProvider
@riverpod
class AuthViewModel extends _$AuthViewModel {
  // Repository instance that will be initialized using another provider
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  // build() is the initializer for this provider
  // It's called when the provider is first used
  // Returns AsyncValue<UserModel>? which can be:
  // - AsyncData: Contains the successful data
  // - AsyncError: Contains error information
  // - AsyncLoading: Indicates loading state
  @override
  AsyncValue<UserModel>? build() {
    // ref.watch() subscribes to another provider (authRemoteRepositoryProvider)
    // When authRemoteRepositoryProvider changes, this build method will re-run
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  // Method to handle user signup
  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    // Update the provider's state to loading
    // AsyncValue.loading() is a Riverpod state that indicates loading status
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.signUp(
      name: name,
      email: email,
      password: password,
    );

    // Pattern matching to handle Either response
    // Updates the provider's state based on success/failure
    final val = switch (res) {
      // On error: Update state with AsyncValue.error
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      // On success: Update state with AsyncValue.data
      Right(value: final r) => state = AsyncValue.data(r),
    };
  }

  // Method to handle user login
  Future<void> logInUser({
    required String email,
    required String password,
  }) async {
    // Set provider state to loading
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    // Handle the response and update provider state accordingly
    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _loginSuccess(r),
    };
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    try {
      final token = _authLocalRepository.getToken();
      if (token == null) {
        return null;
      }

      state = const AsyncValue.loading();
      final res = await _authRemoteRepository.getUserData(token);

      state = switch (res) {
        Left(value: final l) => AsyncValue.error(l.message, StackTrace.current),
        Right(value: final r) => _getUserData(r),
      };

      return switch (res) {
        Left(value: final l) => null,
        Right(value: final r) => r,
      };
    } catch (e) {
      // If server is down or any other error, clear token and return null
      _authLocalRepository.clearToken();
      state = null;
      return null;
    }
  }

  AsyncValue<UserModel> _getUserData(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
