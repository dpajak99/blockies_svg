import 'dart:math' show Point;
import 'package:blockies_svg/src/utils/svg/svg_writer.dart';

import 'renderer.dart';
import 'svg_path.dart';

class SvgRenderer extends Renderer {
  final Map<String, SvgPath> _pathsByColor = <String, SvgPath>{};
  final SvgWriter _target;
  int size;
  SvgPath _path = SvgPath();

  SvgRenderer(this._target) : size = _target.size;

  @override
  void setBackground(String fillColor) {
    _target.setBackground(fillColor, 1.0);
  }

  @override
  void beginShape(String color) {
    final SvgPath? p = _pathsByColor[color];
    if (p != null) {
      _path = p;
    } else {
      _path = _pathsByColor[color] = SvgPath();
    }
  }

  @override
  void endShape() {}

  @override
  void addPolygon(List<Point<double>> points) {
    _path.addPolygon(points);
  }

  @override
  void addCircle(Point<double> point, double diameter, {bool counterClockwise = false}) {
    _path.addCircle(point, diameter, counterClockwise: counterClockwise);
  }

  @override
  void finish() {
    for (final String color in _pathsByColor.keys) {
      if (_pathsByColor[color] != null) {
        _target.append(color, _pathsByColor[color]!.dataString);
      }
    }
  }
}
