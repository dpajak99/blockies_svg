import 'dart:math' show Point;

double svgValue(num value) => (value * 10 + 0.5).floor() / 10;

class SvgPath {
  String dataString = '';

  SvgPath();

  void addPolygon(List<Point<double>> points) {
    final StringBuffer ds = StringBuffer(
        'M${svgValue(points[0].x).toStringAsFixed(1)} ${svgValue(points[0].y).toStringAsFixed(1)}');
    for (int i = 0; i < points.length; i++) {
      ds.write(
          'L${svgValue(points[i].x).toStringAsFixed(1)} ${svgValue(points[i].y).toStringAsFixed(1)}');
    }
    ds.write('Z');
    dataString += ds.toString();
  }

  void addCircle(Point<double> point, double diameter,
      {bool counterClockwise = false}) {
    final int sweepFlag = counterClockwise ? 0 : 1;
    final int svgRadius = (svgValue(diameter / 2)).floor();
    final int svgDiameter = (svgValue(diameter)).floor();

    dataString +=
    'M${svgValue(point.x)} ${svgValue(point.y + diameter / 2)}a$svgRadius,$svgRadius 0 1,$sweepFlag $svgDiameter ,0a$svgRadius,$svgRadius 0 1,$sweepFlag -$svgDiameter,0';
  }
}