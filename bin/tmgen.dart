import 'dart:io';

import 'package:args/args.dart';
import 'src/bloc_gen.dart';
import 'src/repository_gen.dart';
import 'src/datasource_gen.dart';
import 'src/register_to_di.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Print this usage information.')
    ..addFlag('verbose', abbr: 'v', negatable: false, help: 'Show additional command output.')
    ..addFlag('version', negatable: false, help: 'Print the tool version.');
}

void printUsage(ArgParser argParser) {
  print('Usage: dart tmgen.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      print('tmgen version: $version');
      return;
    }
    if (results.flag('verbose')) {
      verbose = true;
    }
    if (results.rest.isEmpty) {
      print('❌ Please provide a name. Example: tmgen Profile');
      exit(1);
    }

    generateDatasource(results.rest.first);
    generateRepository(results.rest.first);
    generateBloc(results.rest.first);
    registerToDi(results.rest.first);

    // Act on the arguments provided.
    print('Positional arguments: ${results.rest}');
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
