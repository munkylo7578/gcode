import 'dart:collection';

import 'package:gcode_execution/Engine/GCodeGeneration/ImageProcessor/FreeMotionStroke.dart';
import 'package:gcode_execution/Engine/GCodeGeneration/ImageProcessor/IdleStroke.dart';
import 'package:gcode_execution/Engine/GCodeGeneration/ImageProcessor/Stroke.dart';
import 'package:gcode_execution/Engine/Geometry/ImageLine.dart';
import 'package:gcode_execution/Engine/Pixel.dart';

class StrokesFromImageLinesGenerator {
  double SAME_INTENSITY = 0.1;
  late List<ImageLine> _lines;
  late List<FreeMotionStroke> strokes;
  late double _idleDistance;
  late bool _doubleDirections;
  double get idleDistance => _idleDistance;
  late bool _useIdleZones;

  StrokesFromImageLinesGenerator(List<ImageLine> lines, bool useIdleZones,
      double idleDistance, bool doubleDirections) {
    _lines = lines;
    strokes = <FreeMotionStroke>[];

    _idleDistance = idleDistance;

    _doubleDirections = doubleDirections;

    _useIdleZones = useIdleZones;
  }

  void generateStrokes() {
    bool isReversed = false;
    for (var line in _lines) {
      if (line.pixels.length == 1 || line.pixels.isEmpty) {
        // Skip this iteration and move to the next item
        continue;
      }
      LinkedList<FreeMotionStroke> lineStrokes = LinkedList<FreeMotionStroke>();
      Pixel? firstDarkPixel;
      Pixel? strokeBegining;

      List<double?> strokeIntensities = <double>[];

      for (var curPixel in line.pixels) {
        if (strokeBegining == null) {
          if (curPixel?.intensity != 1) {
            strokeBegining = curPixel;
            if (firstDarkPixel == null) firstDarkPixel = strokeBegining;
            strokeIntensities.clear();
          }
        } else if (curPixel != null &&
            (strokeBegining.intensity - curPixel.intensity).abs() >
                SAME_INTENSITY) {
          addStroke(
              lineStrokes,
              isReversed,
              strokeBegining,
              curPixel,
              1 -
                  strokeIntensities.reduce((a, b) => a! + b!)! /
                      strokeIntensities.length);
          strokeBegining = curPixel;

          strokeIntensities.clear();
        }

        strokeIntensities.add(curPixel?.intensity);
      }
      if (strokeBegining == null) //Выходим, так как строка вся белая
        continue;

      Pixel? lastPixel = line.pixels[line.pixels.length - 1];

      if (strokeBegining.intensity == 1) {
        lastPixel = strokeBegining;
      } else if (lastPixel != strokeBegining) {
        addStroke(
            lineStrokes,
            isReversed,
            strokeBegining,
            lastPixel,
            1 -
                strokeIntensities.reduce((a, b) => a! + b!)! /
                    strokeIntensities.length);
      }
      if (isReversed) {
        if (_useIdleZones) {
          lineStrokes.addFirst(IdleStroke(lastPixel));
          lineStrokes.add(IdleStroke(firstDarkPixel! +
              (firstDarkPixel - lastPixel!)
                  .normalize()
                  .multiplyByScalar(_idleDistance)));
          lineStrokes.addFirst(FreeMotionStroke(lastPixel +
              (lastPixel - firstDarkPixel)
                  .normalize()
                  .multiplyByScalar(_idleDistance)));
        } else
          lineStrokes.addFirst(FreeMotionStroke(lastPixel));
      } else {
        if (_useIdleZones) {
          lineStrokes.addFirst(IdleStroke(firstDarkPixel!));
          lineStrokes.add(IdleStroke(lastPixel! +
              (lastPixel - firstDarkPixel)
                  .normalize()
                  .multiplyByScalar(_idleDistance)));
          lineStrokes.addFirst(FreeMotionStroke(firstDarkPixel +
              (firstDarkPixel - lastPixel)
                  .normalize()
                  .multiplyByScalar(_idleDistance)));
        } else
          lineStrokes.addFirst(FreeMotionStroke(firstDarkPixel!));
      }

      strokes.addAll(lineStrokes);

      if (_doubleDirections) isReversed = !isReversed;
    }
  }

  void addStroke(LinkedList<FreeMotionStroke> line, bool isReversed,
      Pixel strokeBegining, Pixel? strokeEnd, double intensity) {
    if (isReversed)
      line.addFirst(Stroke(strokeBegining, intensity));
    else
      line.add(Stroke(strokeEnd, intensity));
  }
}
