import 'dart:io';

void generateBloc(String name) {
  final fileName = name.toLowerCase();
  final className = name[0].toUpperCase() + name.substring(1);
  final folder = Directory('presentation/bloc/$fileName');
  if (!folder.existsSync()) {
    folder.createSync(recursive: true);
    print('📂 Created folder: presentation/bloc/$fileName');
  }
  // Bloc
  final blocFile = File('presentation/bloc/$fileName/${fileName}_bloc.dart');
  blocFile.writeAsStringSync(blocPattern(fileName, className));
  // Event
  final eventFile = File('presentation/bloc/$fileName/${fileName}_event.dart');
  eventFile.writeAsStringSync(eventPattern(fileName, className));
  // State
  final stateFile = File('presentation/bloc/$fileName/${fileName}_state.dart');
  stateFile.writeAsStringSync(statePattern(fileName, className));
  print('✅ Created $fileName bloc, event and state');
}

String blocPattern(String fileName, String className) =>
    '''
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:texnomart_v2/core/utils/enums/status.dart';
import '../../../domain/repositories/${fileName}_repository.dart';

part '${fileName}_event.dart';
part '${fileName}_state.dart';

class ${className}Bloc extends Bloc<${className}Event, ${className}State> {
  final ${className}Repository repository;
  ${className}Bloc(this.repository) : super(${className}State()) {
    on<Get>(_on$className);
  }

  FutureOr<void> _on$className(Get event, Emitter<${className}State> emit) async {
    emit(state.copyWith(status: Status.loading));
    final result = await repository.get();
    result.fold(
      success: (result) {},
      failure: (error) => emit(state.copyWith()),
    );
  }
}
''';

String eventPattern(String fileName, String className) =>
    '''
part of '${fileName}_bloc.dart';

@immutable
sealed class ${className}Event {}

class Get extends ${className}Event {}
''';

String statePattern(String fileName, String className) =>
    '''
part of '${fileName}_bloc.dart';
class ${className}State {
  final Status status;
  final String error;

  const ${className}State({
    this.status = Status.initial,
    this.error = '',
  });

    ${className}State copyWith({
    String? error,
    Status? status,
  }) {
    return ${className}State(
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }
}
''';
