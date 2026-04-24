import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/category/domain/entities/category.dart';

/// BEGIN: OPEN/CLOSED PRINCIPLE (SOLID) ///
///
/// We use an abstract class here to follow the Open/Closed Principle:
/// the contract is closed for modification but open for extension,
/// allowing new implementations (remote, local, mock) without changing the interface.
///
/// END: OPEN/CLOSED PRINCIPLE ///
abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories({
    required bool isOnline,
  });
}
