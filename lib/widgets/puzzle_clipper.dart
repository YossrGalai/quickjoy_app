import 'package:flutter/material.dart';

class PuzzleClipper extends CustomClipper<Path> {
  final int row, col, size;

  PuzzleClipper(this.row, this.col, this.size);

  @override
  Path getClip(Size s) {
    Path path = Path();
    double bump = s.width * 0.2;

    path.moveTo(0, 0);

    // TOP
    if (row == 0) {
      path.lineTo(s.width, 0);
    } else {
      path.lineTo(s.width * 0.3, 0);
      path.quadraticBezierTo(s.width * 0.5, -bump, s.width * 0.7, 0);
      path.lineTo(s.width, 0);
    }

    // RIGHT
    if (col == size - 1) {
      path.lineTo(s.width, s.height);
    } else {
      path.lineTo(s.width, s.height * 0.3);
      path.quadraticBezierTo(
          s.width + bump, s.height * 0.5, s.width, s.height * 0.7);
      path.lineTo(s.width, s.height);
    }

    // BOTTOM
    if (row == size - 1) {
      path.lineTo(0, s.height);
    } else {
      path.lineTo(s.width * 0.7, s.height);
      path.quadraticBezierTo(
          s.width * 0.5, s.height + bump, s.width * 0.3, s.height);
      path.lineTo(0, s.height);
    }

    // LEFT
    if (col == 0) {
      path.close();
    } else {
      path.lineTo(0, s.height * 0.7);
      path.quadraticBezierTo(
          -bump, s.height * 0.5, 0, s.height * 0.3);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}