class ExpectException implements Exception {
  final String message;

  ExpectException(this.message);

  @override
  String toString() {
    return 'ExpectException{message: $message}';
  }
}
