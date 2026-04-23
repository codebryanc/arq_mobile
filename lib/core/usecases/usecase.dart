import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';

abstract class UseCase<Output, Params> {
  Future<Either<Failure, Output>> call(Params params);
}

class NoParams {
  const NoParams();
}

class OnlineParams {
  const OnlineParams({required this.isOnline});
  final bool isOnline;
}
