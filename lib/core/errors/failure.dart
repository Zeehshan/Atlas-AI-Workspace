import 'package:faiapp/core/errors/app_exception.dart';

class Failure {
  const Failure({required this.title, required this.message});

  final String title;
  final String message;

  factory Failure.fromException(AppException exception) {
    if (exception.isUnauthorized) {
      return const Failure(
        title: 'Session expired',
        message: 'Please sign in again to continue.',
      );
    }

    if (exception.isNetworkError) {
      return const Failure(
        title: 'Connection issue',
        message: 'Check your network connection and try again.',
      );
    }

    return Failure(title: 'Something went wrong', message: exception.message);
  }
}
