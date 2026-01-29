import 'package:flutter/material.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "BRULION",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[900],
              letterSpacing: 4,
            ),
          ),
          const Divider(thickness: 2),
          const Expanded(
            child: Center(
              child: Text("Tutaj będzie Twój atrament Waterman i S-Pen"),
            ),
          ),
        ],
      ),
    );
  }
}
