import 'package:blockies_svg/src/blockies.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // All outputs are compared with outputs from JS blockies library
  test('test createRandSeed()', () {
    expect(
        Blockies.createRandSeed('0x999767E4B0e7D455E921a4bD27Be50341cdeA5fe'),
        [-6173707601, 4319541941, 4213947214, 3695525512]);
    expect(
        Blockies.createRandSeed('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
        [-18079906789, -9075364727, -4604185989, -10563091169]);
    expect(
        Blockies.createRandSeed('婀׬с蒳oצ𦗟ԵʃϽIbЅ񟦫򼟪÷全;󤅄񐟙󱾒Ǫᔪݲŵҭrޯ􊾅>񿲯𭗞'),
        [-1161510373, -3070486659, -198066547, 4032791216]);
    expect(Blockies.createRandSeed(''), [0, 0, 0, 0]);
    expect(Blockies.createRandSeed('    '), [32, 32, 32, 32]);
  });

  test('test rand()', () {
    const seed = '0x999767E4B0e7D455E921a4bD27Be50341cdeA5fe';
    final blockies = Blockies(seed: seed);

    blockies.randSeed = Blockies.createRandSeed(seed);

    expect(
        blockies.randSeed, [-6173707601, 4319541941, 4213947214, 3695525512]);

    blockies.rand();
    expect(blockies.randSeed, [4319541941, 4213947214, 3695525512, 1772002917]);

    blockies.rand();
    expect(blockies.randSeed, [4213947214, 3695525512, 1772002917, 546005681]);

    blockies.rand();
    blockies.rand();
    blockies.rand();
    blockies.rand();
    expect(blockies.randSeed, [2044484645, 1939381480, 292047176, 1787641662]);
  });
}