abstract class Failure {
  const Failure();
}

class ServerFailure extends Failure {
  final String message;
  final int? statusCode;
  const ServerFailure(this.message, {this.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class CacheFailure extends Failure {
  final String message;
  const CacheFailure(this.message);
}
