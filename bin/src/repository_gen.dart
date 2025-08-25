import 'dart:io';

void generateRepository(String name) {
  final fileName = name.toLowerCase();
  final className = name[0].toUpperCase() + name.substring(1);
  final repositoryFolder = Directory('domain/repositories');
  if (!repositoryFolder.existsSync()) {
    repositoryFolder.createSync(recursive: true);
    print('📂 Created folder: domain/repositories');
  }
  final repositoryImplFolder = Directory('data/repositories_impl');
  if (!repositoryImplFolder.existsSync()) {
    repositoryImplFolder.createSync(recursive: true);
    print('📂 Created folder: data/repositories_impl');
  }
  // Repository
  final repositoryFile = File('domain/repositories/${fileName}_repository.dart');
  repositoryFile.writeAsStringSync(repositoryPattern(fileName, className));
  print('✅ Created $fileName repository');

  // RepositoryImpl
  final repositoryImplFile = File('data/repositories_impl/${fileName}_repository_impl.dart');
  repositoryImplFile.writeAsStringSync(repositoryImplPattern(fileName, className));
  print('✅ Created $fileName repository impl');
}

String repositoryPattern(String fileName, String className) =>
    '''
import 'package:texnomart_v2/common/models/result.dart';

abstract class ${className}Repository {
  Future<Result> get();
}
''';

String repositoryImplPattern(String fileName, String className) =>
    '''
import 'package:texnomart_v2/common/models/result.dart';
import '../datasources/remote/${fileName}_remote_datasource.dart';
import '../datasources/local/${fileName}_local_datasource.dart';
import '../../domain/repositories/${fileName}_repository.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource ${fileName}RemoteDataSource;
  final ${className}LocalDataSource ${fileName}LocalDataSource;

  ${className}RepositoryImpl(this.${fileName}RemoteDataSource, this.${fileName}LocalDataSource);
  @override
  Future<Result> get() async {
    final result = await ${fileName}RemoteDataSource.fetch();
    if (result.isSuccess) {
      return Result.success(result.data);
    } else {
      return Result.failure(result.error);
    }
  }
}

''';
