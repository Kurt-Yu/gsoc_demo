import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/physical_file_system.dart';

void main(List<String> args) async {
  FileSystemEntity entity = Directory.current;
  if (args.isNotEmpty) {
    String arg = args.first;
    entity = FileSystemEntity.isDirectorySync(arg) ? Directory(arg) : File(arg);
  }

  var issueCount = 0;
  final collection = AnalysisContextCollection(
      includedPaths: [entity.absolute.path],
      resourceProvider: PhysicalResourceProvider.INSTANCE);

  // Often one context is returned, but depending on the project structure we
  // can see multiple contexts.
  for (final context in collection.contexts) {
    print("----------------------------------------------");
    print('Analyzing ${context.contextRoot.root.path} ...');
    print("----------------------------------------------");

    for (final filePath in context.contextRoot.analyzedFiles()) {
      var session = context.currentSession;
      var result = await session.getResolvedUnit(filePath);

      if (result is ResolvedUnitResult) {
        CompilationUnit unit = result.unit;

        for (CompilationUnitMember unitMember in unit.declarations) {
          if (unitMember is ClassDeclaration) {
            print(unitMember.name.name);
          }
          if (unitMember is FunctionDeclaration) {
            print(unitMember.name.name);
          }
        }
      }
    }
  }

  print('$issueCount issues found.');
}
