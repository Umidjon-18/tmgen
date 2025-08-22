import 'dart:io';

void generateDatasource(String name) {
  final fileName = name.toLowerCase();
  final className = name[0].toUpperCase() + name.substring(1);
  final remoteFolder = Directory('data/datasources/remote');
  if (!remoteFolder.existsSync()) {
    remoteFolder.createSync(recursive: true);
    print('📂 Created folder: data/datasources/remote');
  }
  final localFolder = Directory('data/datasources/local');
  if (!localFolder.existsSync()) {
    localFolder.createSync(recursive: true);
    print('📂 Created folder: data/datasources/local');
  }
  // Remote
  final repositoryFile = File('data/datasources/remote/${fileName}_remote_datasource.dart');
  repositoryFile.writeAsStringSync(remoteDataSourcePattern(fileName, className));
  print('✅ Created $fileName remote datasource');

  // Local
  final repositoryImplFile = File('data/datasources/local/${fileName}_local_datasource.dart');
  repositoryImplFile.writeAsStringSync(localDataSourcePattern(fileName, className));
  print('✅ Created $fileName local datasource');
}

String remoteDataSourcePattern(String fileName, String className) =>
    '''
import 'package:texnomart_v2/common/models/base_response.dart';
import 'package:texnomart_v2/common/models/result.dart';
import 'package:texnomart_v2/core/network/network_client.dart';
import 'package:texnomart_v2/core/utils/handlers/network_request_handler.dart';

abstract class ${className}RemoteDataSource {
  Future<Result> fetch();
}

class ${className}RemoteDataSourceImpl implements ${className}RemoteDataSource {
  final NetworkClient client;

  ${className}RemoteDataSourceImpl(this.client);
  @override
  Future<Result> fetch() async {
    return handleRequest(() async {
      final response = await client.gateway.get('');
      final model = BaseResponse.fromJson(response.data, (data) => data);
      if (model.success && model.data['data'] != null) {
        return Result.success(model.data['data']);
      }
      return Result.failure(model.message);
    });
  }
}
''';

String localDataSourcePattern(String fileName, String className) =>
    '''
import 'package:texnomart_v2/core/database/local_database.dart';

abstract class ${className}LocalDataSource {
  Future<void> fetch();
}

class ${className}LocalDataSourceImpl implements ${className}LocalDataSource {
  final LocalDatabase database;

  ${className}LocalDataSourceImpl(this.database);
  @override
  Future<void> fetch() async {}
}
''';
