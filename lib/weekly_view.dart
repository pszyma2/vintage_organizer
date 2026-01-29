import 'package:flutter/material.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "PLAN TYGODNIA",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: Color(0xFF5D4037),
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              // LEWA KOLUMNA: Pn, Wt, Śr
              Expanded(
                child: Column(
                  children: [
                    _buildDayBlock("PONIEDZIAŁEK"),
                    _buildDayBlock("WTOREK"),
                    _buildDayBlock("ŚRODA", isLast: true),
                  ],
                ),
              ),
              Container(width: 1, color: const Color(0xFF5D4037).withAlpha(40)),
              // PRAWA KOLUMNA: Cz, Pt, Weekend
              Expanded(
                child: Column(
                  children: [
                    _buildDayBlock("CZWARTEK"),
                    _buildDayBlock("PIĄTEK"),
                    Expanded(
                      child: Column(
                        children: [
                          _buildDayBlock("SOBOTA", isWeekend: true),
                          _buildDayBlock(
                            "NIEDZIELA",
                            isWeekend: true,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayBlock(
    String name, {
    bool isLast = false,
    bool isWeekend = false,
  }) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: isLast
                ? BorderSide.none
                : BorderSide(color: const Color(0xFF5D4037).withAlpha(30)),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: name == "NIEDZIELA"
                    ? Colors.red.shade700
                    : const Color(0xFF5D4037),
              ),
            ),
            // LINIE NA CAŁEJ WYSOKOŚCI
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Obliczamy ile linii zmieści się w dostępnym miejscu (co 25 pikseli)
                  int lineCount = (constraints.maxHeight / 25).floor();
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: lineCount,
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xFF5D4037).withAlpha(15),
                          ),
                        ),
                      ),
                      height: 25, // Odstęp między liniami - idealny pod rysik
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
