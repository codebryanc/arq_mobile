sealed class Either<L, R> {
  const Either();

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => switch (this) {
        Left<L, R>(:final value) => onLeft(value),
        Right<L, R>(:final value) => onRight(value),
      };
}

final class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;
}

final class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;
}
