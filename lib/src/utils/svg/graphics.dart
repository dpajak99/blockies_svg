import 'dart:math' show Point;

import 'package:blockies_svg/src/utils/svg/renderer.dart';
import 'package:blockies_svg/src/utils/svg/transform.dart';

class Graphics {
  final Renderer _renderer;
  Transform transform = Transform.noTransform();

  Graphics(this._renderer);

  void addPolygon(List<Point<double>> points, {bool invert = false}) {
    final Transform tf = transform;
    final List<Point<double>> transformedPoints = <Point<double>>[];
    int i = invert ? points.length - 1 : 0;
    if (!invert) {
      for (; i < points.length; i++) {
        transformedPoints.add(tf.transformPoint(points[i].x, points[i].y));
      }
    } else {
      for (; i > -1; i--) {
        transformedPoints.add(tf.transformPoint(points[i].x, points[i].y));
      }
    }
    _renderer.addPolygon(transformedPoints);
  }

  void addCircle(num xx, num yy, num s, {bool invert = false}) {
    final double x = xx.toDouble();
    final double y = yy.toDouble();
    final double size = s.toDouble();
    final Point<double> p = transform.transformPoint(x, y, size, size);
    _renderer.addCircle(p, size, counterClockwise: invert);
  }

  void addRectangle(num xx, num yy, num ww, num hh, {bool invert = false}) {
    final double x = xx.toDouble();
    final double y = yy.toDouble();
    final double w = ww.toDouble();
    final double h = hh.toDouble();
    addPolygon(<Point<double>>[Point<double>(x, y), Point<double>(x + w, y), Point<double>(x + w, y + h), Point<double>(x, y + h)], invert: invert);
  }

  void addTriangle(num xx, num yy, num ww, num hh, num r, {bool invert = false}) {
    final double x = xx.toDouble();
    final double y = yy.toDouble();
    final double w = ww.toDouble();
    final double h = hh.toDouble();
    final List<Point<double>> points = <Point<double>>[Point<double>(x + w, y), Point<double>(x + w, y + h), Point<double>(x, y + h), Point<double>(x, y)]
      ..removeAt(r.floor() % 4);
    addPolygon(points, invert: invert);
  }

  void addRhombus(num xx, num yy, num ww, num hh, {bool invert = false}) {
    final double x = xx.toDouble();
    final double y = yy.toDouble();
    final double w = ww.toDouble();
    final double h = hh.toDouble();
    addPolygon(<Point<double>>[Point<double>(x + w / 2.0, y), Point<double>(x + w, y + h / 2.0), Point<double>(x + w / 2.0, y + h), Point<double>(x, y + h / 2.0)], invert: invert);
  }
}
