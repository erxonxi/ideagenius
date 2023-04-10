import 'dart:math';

import 'package:flutter/material.dart';

Color randomNoteColor() {
  return Colors.primaries[Random().nextInt(Colors.primaries.length)].shade400;
}
