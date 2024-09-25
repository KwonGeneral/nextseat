import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:build/build.dart';
import 'package:glob/glob.dart';


Builder assetPathsBuilder(BuilderOptions options) => AssetGenerator(options);


class AssetGenerator extends Builder {
  final BuilderOptions options;

  AssetGenerator(this.options)
  {
    print('options ${options}');
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputDir = options.config['input'] as String;
    final outputDir = options.config['output'] as String;
    final outputFileName = options.config['outputFileName'] as String;
    final outputPath = '$outputDir/$outputFileName';

    final assetPaths = await buildStep.findAssets(Glob('assets/images/**'))
        .toList();
    //variableName를 저장하는 hashmap
    final maps = HashMap<String, String>();

    final buffer = StringBuffer();
    buffer.writeln('class ImageResource {');
    for (final assetId in assetPaths) {
      final assetName = assetId.path
          .split('/')
          .last;
      final variableName = assetName
          .split('.')
          .first;


      if(maps.containsKey(variableName)){
        continue;
      }
      maps[variableName] = variableName;
      buffer.writeln('  static const String $variableName = \'${inputDir}/${assetName}\';');
    }
    buffer.writeln('}');
    final outputFile = File(outputPath);
    await outputFile.create(recursive: true);
    await outputFile.writeAsString(buffer.toString());

  }
  @override
  Map<String, List<String>> get buildExtensions =>
      {
        r'$package$': ['lib/presenter/style/ImageResource.dart'],
      };
}



