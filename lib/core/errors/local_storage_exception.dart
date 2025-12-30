class LocalStorageException implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const LocalStorageException(this.message, {this.cause, this.stackTrace});

  @override
  String toString() => 'LocalStorageException: $message';
}
