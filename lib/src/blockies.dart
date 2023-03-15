import 'dart:developer';

import 'package:blockies_svg/src/utils/color_utils.dart';
import 'package:blockies_svg/src/utils/svg/graphics.dart';
import 'package:blockies_svg/src/utils/svg/svg_renderer.dart';
import 'package:blockies_svg/src/utils/svg/svg_writer.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';

class Blockies {
  @visibleForTesting
  final int blockieSize;

  @visibleForTesting
  late List<int> randSeed;
  
  @visibleForTesting
  late Color color;
  
  @visibleForTesting
  late Color backgroundColor;

  @visibleForTesting
  late Color spotColor;

  @visibleForTesting
  late List<int> imageData;

  Blockies({required String seed, this.blockieSize = 8}) {
    randSeed = createRandSeed(seed.toLowerCase());
    color = createColor();
    backgroundColor = createColor();
    spotColor = createColor();
    imageData = createImageData();
  }

  String toSvg({required int size}) {
    double scale = size / blockieSize;

    final SvgWriter writer = SvgWriter(size.abs());
    final SvgRenderer renderer = SvgRenderer(writer);
    Graphics graphics = Graphics(renderer);
    renderer.setBackground(ColorUtils.colorToHex(backgroundColor));

    for (int i = 0; i < imageData.length; i++) {
      if (imageData[i] != 0) {
        final int row = (i / blockieSize).floor();
        final int col = i % blockieSize;

        Color tileColor = imageData[i] == 1 ? color : spotColor;
        renderer.beginShape(ColorUtils.colorToHex(tileColor));
        graphics.addRectangle(col * scale, row * scale, scale, scale);
        renderer.endShape();
      }
    }

    renderer.finish();
    String svg = writer.convertToString();

    return svg;
  }

  @visibleForTesting
  static List<int> createRandSeed(String seed) {
    List<int> randSeed = List<int>.filled(4, 0);

    for (int i = 0; i < seed.length; i++) {
      // Note: JS << treats arguments as 32bit numbers with result being 32bit as well
      randSeed[i % 4] = Int32(randSeed[i % 4] << 5).toInt() - randSeed[i % 4] + seed.codeUnitAt(i);
    }
    return randSeed;
  }

  @visibleForTesting
  double rand() {
    // based on Java's String.hashCode(), expanded to 4 32bit values
    final Int32 t = Int32(randSeed[0] ^ Int32(randSeed[0] << 11).toInt());
    final Int32 third = Int32(randSeed[3]);

    randSeed[0] = randSeed[1];
    randSeed[1] = randSeed[2];
    randSeed[2] = randSeed[3];
    randSeed[3] = ((third ^ (third >> 19)) ^ t ^ (t >> 8)).toInt();

    return Int32(randSeed[3] >>> 0).toInt() / ((1 << 31) >>> 0);
  }

  @visibleForTesting
  Color createColor() {
    // hue is the whole color spectrum
    final double h = (rand() * 360).floorToDouble();

    // saturation goes from 40 to 100, it avoids greyish colors
    final double s = (rand() * 60) + 40;

    // lightness can be anything from 0 to 100, but probabilities are a bell curve around 50%
    final double l = (rand() + rand() + rand() + rand()) * 25;

    return HSLColor.fromAHSL(1, h, s / 100, l / 100).toColor();
  }

  @visibleForTesting
  List<int> createImageData() {
    int width = blockieSize;
    int height = blockieSize;

    int dataWidth = (width / 2).ceil();
    int mirrorWidth = width - dataWidth;

    List<int> data = List<int>.empty(growable: true);
    for (int y = 0; y < height; y++) {
      List<int> row = List<int>.filled(dataWidth, 0, growable: true);
      for (int x = 0; x < dataWidth; x++) {
        row[x] = (rand() * 2.3).floor();
      }

      List<int> r = row.sublist(0, mirrorWidth).reversed.toList();
      row.addAll(r);
      for (int i = 0; i < row.length; i++) {
        data.add(row[i]);
      }
    }
    return data;
  }
}
