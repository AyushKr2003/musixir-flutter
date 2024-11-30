class AppFailure {
  final String message;

  AppFailure([this.message = "Sorry something unexpected occurred"]);

  @override
  String toString() => 'AppFailure(message: $message)';
}
