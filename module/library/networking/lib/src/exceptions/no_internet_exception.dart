class NoInternetException implements Exception {
  const NoInternetException();

  String? get message => 'No Internet Connection';

  StackTrace? get stackTrace => null;

  @override
  String toString() => 'NoInternetException';
}
