import 'dart:math' show Point;

class Transform {
  final double _x;
  final double _y;
  final double _size;
  final double _rotation;

  Transform(this._x, this._y, this._size, this._rotation);

  Point<double> transformPoint(double x, double y,
      [double width = 0.0, double height = 0.0]) {
    final double right = _x + _size;
    final double bottom = _y + _size;

    return _rotation == 1
        ? Point<double>(right - y - height, _y + x)
        : _rotation == 2
        ? Point<double>(right - x - width, bottom - y - height)
        : _rotation == 3
        ? Point<double>(_x + y, bottom - x - width)
        : Point<double>(_x + x, _y + y);
  }

  Transform.noTransform()
      : _x = 0,
        _y = 0,
        _size = 0,
        _rotation = 0;
}