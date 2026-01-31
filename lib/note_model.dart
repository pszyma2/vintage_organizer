import 'package:flutter/material.dart';

// To jest nasz wzór notatki - co ona musi zawierać
class Note {
  final DateTime date;
  final String title;
  final String time; // np. "08:00"
  final Color color;

  Note({
    required this.date,
    required this.title,
    required this.time,
    this.color = Colors.red,
  });
}
