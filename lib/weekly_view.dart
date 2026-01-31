import 'package:flutter/material.dart';
import 'global_data.dart';

class WeeklyView extends StatelessWidget {
  final DateTime referenceDate;
  final Function(DateTime) onDaySelected;

  const WeeklyView({
    super.key,
    required this.referenceDate,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    DateTime monday = referenceDate.subtract(
      Duration(days: referenceDate.weekday - 1),
    );

    return Container(
      color: const Color(0xFFF2E2C9),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            "TYDZIEŃ ${monday.day}.${monday.month} - ${monday.add(const Duration(days: 6)).day}.${monday.add(const Duration(days: 6)).month}.${monday.year}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E2723),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Row(
              children: [
                // LEWA KOLUMNA: 3 RÓWNE CZĘŚCI (PON, WT, ŚR)
                Expanded(
                  child: Column(
                    children: [
                      _buildDayCell(monday.add(const Duration(days: 0))),
                      _buildDayCell(monday.add(const Duration(days: 1))),
                      _buildDayCell(monday.add(const Duration(days: 2))),
                    ],
                  ),
                ),

                // LINIA ŚRODKOWA
                Container(width: 1, color: Colors.brown.withOpacity(0.15)),

                // PRAWA KOLUMNA: 3 RÓWNE CZĘŚCI (CZW, PT, WEEKEND)
                Expanded(
                  child: Column(
                    children: [
                      _buildDayCell(monday.add(const Duration(days: 3))),
                      _buildDayCell(monday.add(const Duration(days: 4))),
                      // SZÓSTY KAWAŁEK: SOBOTA I NIEDZIELA RAZEM
                      Expanded(
                        child: Column(
                          children: [
                            _buildWeekendHalf(
                              monday.add(const Duration(days: 5)),
                            ),
                            Container(
                              height: 1,
                              color: Colors.brown.withOpacity(0.1),
                            ),
                            _buildWeekendHalf(
                              monday.add(const Duration(days: 6)),
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
      ),
    );
  }

  // GŁÓWNY BOKS DNIA (PON-PT)
  Widget _buildDayCell(DateTime date) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onDaySelected(date),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.brown.withOpacity(0.15),
                width: 1,
              ),
            ),
          ),
          child: _buildDayContent(date),
        ),
      ),
    );
  }

  // POŁÓWKA DLA SOBOTY I NIEDZIELI
  Widget _buildWeekendHalf(DateTime date, {bool isLast = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onDaySelected(date),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: isLast
                  ? BorderSide.none
                  : BorderSide(
                      color: Colors.brown.withOpacity(0.1),
                      width: 0.5,
                    ),
            ),
          ),
          child: _buildDayContent(date, isSmall: true),
        ),
      ),
    );
  }

  // WSPÓLNY RYSUNEK LINII I TEKSTU
  Widget _buildDayContent(DateTime date, {bool isSmall = false}) {
    final notes = GlobalData.getNotesForDay(date);
    bool isSunday = date.weekday == 7;

    return Stack(
      children: [
        // Liniatura
        Column(
          children: List.generate(
            isSmall ? 2 : 4,
            (index) => Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.brown.withOpacity(0.04),
                      width: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Tekst
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${_getWeekdayName(date.weekday)} ${date.day}.${date.month}"
                    .toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isSunday ? Colors.red.shade900 : Colors.brown.shade700,
                ),
              ),
              const SizedBox(height: 2),
              ...notes
                  .take(isSmall ? 1 : 2)
                  .map(
                    (n) => Text(
                      "• ${n.content}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  String _getWeekdayName(int day) {
    const names = [
      "Poniedziałek",
      "Wtorek",
      "Środa",
      "Czwartek",
      "Piątek",
      "Sobota",
      "Niedziela",
    ];
    return names[day - 1];
  }
}
