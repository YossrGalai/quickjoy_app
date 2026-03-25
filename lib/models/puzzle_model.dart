import 'dart:math';

class PieceModel {
  int top, right, bottom, left;

  PieceModel(
      {required this.top,
      required this.right,
      required this.bottom,
      required this.left});
}

List<PieceModel> generatePuzzle(int size) {
  List<PieceModel> pieces = List.generate(
      size * size,
      (_) => PieceModel(top: 0, right: 0, bottom: 0, left: 0));

  Random rand = Random();

  for (int r = 0; r < size; r++) {
    for (int c = 0; c < size; c++) {
      int i = r * size + c;

      pieces[i].top =
          (r == 0) ? 0 : -pieces[(r - 1) * size + c].bottom;

      pieces[i].left =
          (c == 0) ? 0 : -pieces[r * size + (c - 1)].right;

      pieces[i].right =
          (c == size - 1) ? 0 : (rand.nextBool() ? 1 : -1);

      pieces[i].bottom =
          (r == size - 1) ? 0 : (rand.nextBool() ? 1 : -1);
    }
  }

  return pieces;
}