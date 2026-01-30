import 'package:flutter/material.dart';

class MonthView extends StatefulWidget {
  final Function(DateTime) onDaySelected;
  const MonthView({super.key, required this.onDaySelected});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  // Naprawione przewijanie: 1200 to styczeń 2026. Możesz cofać o 100 lat!
  final int _initialPage = 1200;
  late PageController _monthController;

  @override
  void initState() {
    super.initState();
    _monthController = PageController(initialPage: _initialPage);
  }

  DateTime _getDateFromIndex(int index) {
    return DateTime(2026, 1 + (index - _initialPage));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2E2C9), // Nasz papier Vintage
      child: PageView.builder(
        controller: _monthController,
        // Tu docelowo wjedzie nasz "Page Turn", teraz jest płynne Clamping
        physics: const ClampingScrollPhysics(parent: PageScrollPhysics()),
        itemBuilder: (context, index) {
          final monthDate = _getDateFromIndex(index);
          return _buildMonthPage(monthDate);
        },
      ),
    );
  }

  Widget _buildMonthPage(DateTime date) {
    final monthNames = [
      "STYCZEŃ",
      "LUTY",
      "MARZEC",
      "KWIECIEŃ",
      "MAJ",
      "CZERWIEC",
      "LIPIEC",
      "SIERPIEŃ",
      "WRZESIEŃ",
      "PAŹDZIERNIK",
      "LISTOPAD",
      "GRUDZIEŃ",
    ];

    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "${monthNames[date.month - 1]} ${date.year}",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            color: Color(0xFF5D4037),
          ),
        ),
        const SizedBox(height: 15),
        _buildWeekdayHeader(),
        Expanded(child: _buildDaysGrid(date)),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    const days = ["Pon", "Wt", "Śr", "Czw", "Pt", "Sob", "Nie"];
    return Row(
      children: days
          .map(
            (d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: d == "Nie"
                        ? Colors.red.shade900
                        : Colors.brown.shade700,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDaysGrid(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    final startingEmptySlots = firstDay.weekday - 1;
    final totalSlots = startingEmptySlots + lastDay.day;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.6, // Wyższe kratki na notatki
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: totalSlots,
      itemBuilder: (context, index) {
        if (index < startingEmptySlots) {
          return Container(); // Puste pole przed początkiem miesiąca
        }

        final day = index - startingEmptySlots + 1;
        final currentDayDate = DateTime(date.year, date.month, day);
        bool isSunday = currentDayDate.weekday == 7;

        return GestureDetector(
          onTap: () => widget.onDaySelected(currentDayDate),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              border: Border.all(
                color: Colors.brown.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    "$day",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSunday ? Colors.red.shade900 : Colors.black87,
                    ),
                  ),
                ),
                // PRZYKŁADOWE PASKI ZADAŃ (Tak jak w Google Calendar)
                if (day == 10)
                  _buildTaskBar("Lekarz 14:00", Colors.blue.shade100),
                if (day == 15)
                  _buildTaskBar("Praca 08:00", Colors.green.shade100),
                if (day == 15) _buildTaskBar("Zakupy", Colors.orange.shade100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskBar(String text, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 1, left: 1, right: 1),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 7, color: Colors.black87),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
