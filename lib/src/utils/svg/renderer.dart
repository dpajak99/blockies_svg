import 'dart:math' show Point;

abstract class Renderer {
  void setBackground(String fillColor);
  void beginShape(String color);
  void endShape();
  void addPolygon(List<Point<double>> points);
  void addCircle(Point<double> point, double diameter, {bool counterClockwise});
  void finish();
}