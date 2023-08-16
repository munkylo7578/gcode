import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:gcode_execution/Core/Bitmap.dart';
import 'package:http/http.dart' as http;
import 'package:gcode_execution/Engine/GCodeGeneration/BaseGCode.dart';
import 'package:gcode_execution/Engine/GCodeGeneration/ImageProcessor/GCodeGenerator.dart';
import 'package:gcode_execution/Engine/GCodeGeneration/ImageProcessor/StrokesFromImageLinesGenerator.dart';

import 'package:gcode_execution/Engine/Interpolators/BilinearInterpolator.dart';
import 'package:gcode_execution/Engine/Interpolators/StepInterpolator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';

import 'package:gcode_execution/Engine/ImageProcessor.dart';
import 'package:gcode_execution/Engine/Interpolators/IInterpolator.dart';

class ImageProcessorModel {
  double _height = 100;
  double _width = 100;

  int _minPower = 15;
  int _maxPower = 40;
  IInterpolator? _selectedInterpolator;
  late List<IInterpolator> _interpolatorsSource;

  late double _angle = 90;

  late double _minFeed = 4000;
  late double _maxFeed = 10000;

  late bool _engraveBothDirection = true;
  late bool _useFreeZone = true;
  late double _freeZone = 10;
  late double _lineResolution = 0.2;
  late double _pointResolution = 0.2;
  late double _aspectRate = 2;
  late bool _keepAspectRatio = true;
  Duration _estimatedTime = Duration(seconds: 20);

  String? _pathToFile;
  late ObserverList<BaseGCode> _gCode;

  late Bitmap _bitmap = Bitmap();

  ImageProcessorModel(ObserverList<BaseGCode> gcode) {
    _gCode = gcode;

    _interpolatorsSource = <IInterpolator>[];
    _interpolatorsSource.add(StepInterpolator());
    _interpolatorsSource.add(BilinearInterpolator());

    selectedInterpolator = interpolatorsSource[0];
  }

  Iterable<BaseGCode> Process() sync* {
    var processor = ImageProcessor(_bitmap, width, height, lineResolution,
        pointResolution, angle, selectedInterpolator);

    var presenter = processor.createPresenter();
    var strokeGenerator = StrokesFromImageLinesGenerator(
        presenter.lines, useFreeZone, freeZone, engraveBothDirection);
    strokeGenerator.generateStrokes();

    var gcGen = GCodeGenerator(strokeGenerator.strokes, minFeed.toInt(),
        maxFeed.toInt(), maxPower, minPower);
    var gcode = gcGen.generateCode();

    yield BaseGCode("G21");
    yield BaseGCode("G90");
    yield BaseGCode("M3 S0");

    for (var str in gcode) {
      yield str;
    }

    yield BaseGCode("M5");
    yield BaseGCode("%");

    yield BaseGCode("(----ImageGenerator----)");
    yield BaseGCode(sprintf("(FileName: {0})", [_pathToFile]));
    yield BaseGCode(
        sprintf("(Width: {0} mm, Height: {1} mm)", [width, height]));
    yield BaseGCode(sprintf("(Resolution line: {0} mm, point: {1} mm)",
        [lineResolution, pointResolution]));
    yield BaseGCode(
        sprintf("(Feed max: {0} mm/min, min: {1} mm/min)", [maxFeed, minFeed]));
    yield BaseGCode(
        sprintf("(Power max: {0}, min: {1})", [maxPower, minPower]));
    yield BaseGCode(sprintf("(Angle: {0})", [angle]));
    yield BaseGCode(
        sprintf("(Idle zones: {0})", useFreeZone ? [freeZone] : [0.0]));
    yield BaseGCode(
        sprintf("(Engrave both directions: {0})", [engraveBothDirection]));
  }

  double get width {
    return _width;
  }

  set width(double value) {
    if (_width == value) {
      return;
    }
    _width = value;

    if (keepAspectRatio) {
      countHeight(value);
    }
    countEstimatedTime();
  }

  bool get keepAspectRatio => _keepAspectRatio;
  set keepAspectRatio(bool value) {
    if (_keepAspectRatio == value) return;
    _keepAspectRatio == value;
    countHeight(width);
  }

  double get height => _height;
  set height(double value) {
    if (_height == value) return;
    _height = value;
    if (keepAspectRatio) {
      countWidth(value);
      countEstimatedTime();
    }
  }

  double get aspectRate => _aspectRate;
  set aspectRate(double value) {
    if (_aspectRate == value) return;
    _aspectRate = value;
    if (keepAspectRatio) {
      countHeight(width);
    }
  }

  int get maxPower => _maxPower;
  set maxPower(int value) {
    if (_maxPower == value) {
      return;
    }
    if (value < _minPower) {
      _minPower = value;
    }
    _maxPower = value;
  }

  int get minPower => _minPower;
  set minPower(int value) {
    if (_minPower == value) {
      return;
    }
    if (value >= _maxPower) {
      _maxPower = value;
    }
    _minPower = value;
  }

  double get lineResolution => _lineResolution;
  set lineResolution(double value) {
    if (_lineResolution == value) return;
    _lineResolution = value;

    countEstimatedTime();
  }

  bool get useFreeZone => _useFreeZone;
  set useFreeZone(bool value) {
    if (_useFreeZone == value) return;
    _useFreeZone = value;
    countEstimatedTime();
  }

  double get freeZone => _freeZone;
  set freeZone(double value) {
    if (_freeZone == value) return;
    _freeZone = value;
    countEstimatedTime();
  }

  double get minFeed => _minFeed;
  set minFeed(double value) {
    if (_minFeed == value) return;
    _minFeed = value;
  }

  double get maxFeed => _maxFeed;
  set maxFeed(double value) {
    if (_maxFeed == value) return;
    _maxFeed = value;
    countEstimatedTime();
  }

  double get pointResolution => _pointResolution;
  set pointResolution(double value) {
    if (_pointResolution == value) return;
    _pointResolution = value;
  }

  double get angle => _angle;
  set angle(double value) {
    if (_angle == value) return;
    _angle = value;
  }

  bool get engraveBothDirection => _engraveBothDirection;
  List<IInterpolator> get interpolatorsSource => _interpolatorsSource;
  IInterpolator? get selectedInterpolator => _selectedInterpolator;
  set selectedInterpolator(IInterpolator? value) {
    if (_selectedInterpolator == value) return;
    _selectedInterpolator = value;
  }

  Duration get estimatedTime => _estimatedTime;
  set estimatedTime(Duration value) {
    if (_estimatedTime == value) return;
    _estimatedTime = value;
  }

  void countHeight(double width) {
    height = width / aspectRate;
  }

  void countWidth(double height) {
    width = height * aspectRate;
  }

  void countEstimatedTime() {
    double secs = ((height / lineResolution) *
            (width + (useFreeZone ? freeZone * 2 : 0))) /
        ((minFeed + maxFeed) / 2.0) *
        60.0;
    if (!secs.isInfinite && !secs.isNaN) {
      estimatedTime = Duration(seconds: secs.round());
    }
  }

  Future openImage(String path) async {
    try {
      _bitmap.image = await _bitmap.fromFile(path);
      aspectRate = _bitmap.width.toDouble() / _bitmap.height.toDouble();
    } catch (e) {
      print(e);
    }
  }

  Future<void> writeListToFile(dynamic data, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}$fileName';
    final content = data
        .join('\n'); // Convert list of strings to a single string with newlines
    await File(filePath).writeAsString(content);
    print(directory.path);
  }

  void generate() async {
    _gCode.clear();
    var list = <dynamic>[];
    if (_bitmap != null) {
      for (var gc in Process()) {
        _gCode.add(gc);
      }
    }
    _gCode.forEach((element) {
      list.add(element.comment);
    });
    print(list);
    try {
      await http.post(Uri.parse("http://10.0.2.2:3000/saveData"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"gcode": list}));
    } catch (e) {
      throw e;
    }
  }
}
