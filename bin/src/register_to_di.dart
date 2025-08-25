import 'dart:io';

Future<void> registerToDi(String parentFolder, String name) async {
  final className = name[0].toUpperCase() + name.substring(1);

  final datasourceDiFile = File('../../core/di/datasource_module.dart');
  final repositoryDiFile = File('../../core/di/repository_module.dart');
  final blocDiFile = File('../../core/di/bloc_module.dart');

  var datasourceImports = [
    "import 'package:texnomart_v2/features/$parentFolder/data/datasources/remote/${name.toLowerCase()}_remote_datasource.dart';",
    "import 'package:texnomart_v2/features/$parentFolder/data/datasources/local/${name.toLowerCase()}_local_datasource.dart';",
  ];
  var repositoryImports = [
    "import 'package:texnomart_v2/features/$parentFolder/domain/repositories/${name.toLowerCase()}_repository.dart';",
    "import 'package:texnomart_v2/features/$parentFolder/data/repositories_impl/${name.toLowerCase()}_repository_impl.dart';",
    "import 'package:texnomart_v2/features/$parentFolder/data/datasources/remote/${name.toLowerCase()}_remote_datasource.dart';",
    "import 'package:texnomart_v2/features/$parentFolder/data/datasources/local/${name.toLowerCase()}_local_datasource.dart';",
  ];
  var blocImports = [
    "import 'package:texnomart_v2/features/$parentFolder/domain/repositories/${name.toLowerCase()}_repository.dart';",
    "import 'package:texnomart_v2/features/$parentFolder/presentation/bloc/${name.toLowerCase()}/${name.toLowerCase()}_bloc.dart';",
  ];

  var datasourceDiContent = [
    "        if (!sl.isRegistered<${className}LocalDataSource>()) {",
    "      sl.registerSingleton<${className}LocalDataSource>(${className}LocalDataSourceImpl(sl<LocalDatabase>()));",
    "    }",
    "    if (!sl.isRegistered<${className}RemoteDataSource>()) {",
    "      sl.registerSingleton<${className}RemoteDataSource>(${className}RemoteDataSourceImpl(sl<NetworkClient>()));",
    "    }",
  ];
  var repositoryDiContent = [
    "    if (!sl.isRegistered<${className}Repository>()) {",
    "      sl.registerSingleton<${className}Repository>(${className}RepositoryImpl(sl<${className}RemoteDataSource>(),sl<${className}LocalDataSource>()));",
    "    }",
  ];

  var blocDiContent = [
    "    if (!sl.isRegistered<${className}Bloc>()) {",
    "      sl.registerSingleton<${className}Bloc>(${className}Bloc(sl<${className}Repository>()));",
    "    }",
  ];
  _register(file: datasourceDiFile, imports: datasourceImports, content: datasourceDiContent);
  _register(file: repositoryDiFile, imports: repositoryImports, content: repositoryDiContent);
  _register(file: blocDiFile, imports: blocImports, content: blocDiContent);
}

void _register({required File file, required Iterable<String> imports, required Iterable<String> content}) async {
  if (file.existsSync()) {
    var fileCcontent = await file.readAsString();
    final lines = fileCcontent.split('\n');
    final initIndex = lines.indexWhere((l) => l.contains('static Future<void> register(GetIt sl)'));
    if (initIndex == -1) {
      print('❌ No register(GetIt sl) found');
      return;
    }

    // Find the matching closing brace for init()
    int braceCount = 0;
    int closingIndex = -1;
    for (int i = initIndex; i < lines.length; i++) {
      final line = lines[i];
      braceCount += RegExp(r'{').allMatches(line).length;
      braceCount -= RegExp(r'}').allMatches(line).length;

      if (braceCount == 0) {
        closingIndex = i; // This } belongs to init()
        break;
      }
    }

    if (closingIndex == -1) {
      print('❌ Could not find closing } for init()');
      return;
    }
    lines.insertAll(0, imports);
    lines.insertAll(closingIndex, content);

    await file.writeAsString(lines.join('\n'));

    print('✅ Updated ${file.path} with new registrations');
  }
}
