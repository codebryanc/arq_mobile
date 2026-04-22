import 'package:arq_mobile/core/errors/exceptions.dart';
import 'package:arq_mobile/core/errors/failures.dart';
import 'package:arq_mobile/core/utils/either.dart';
import 'package:arq_mobile/features/category/data/datasources/category_remote_datasource.dart';
import 'package:arq_mobile/features/category/domain/entities/category.dart';
import 'package:arq_mobile/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl({required this.remoteDataSource});

  final CategoryRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on NetworkException {
      return Left(const NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    }
  }
}
