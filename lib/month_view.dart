import 'package:flutter/material.dart';
import 'global_data.dart'; // IMPORTUJEMY NASZĄ BAZĘ

class MonthView extends StatefulWidget {
  final Function(DateTime) onDaySelected;
  const MonthView({super.key, required this.onDaySelected});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
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
      color: const Color(0xFFF2E2C9),
      child: PageView.builder(
        controller: _monthController,
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildDaysGrid(date),
          ),
        ),
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
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.55,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: totalSlots,
      itemBuilder: (context, index) {
        if (index < startingEmptySlots) return Container();

        final day = index - startingEmptySlots + 1;
        final currentDayDate = DateTime(date.year, date.month, day);
        bool isSunday = currentDayDate.weekday == 7;

        // POBIERAMY NOTATKI DLA TEGO DNIA Z NASZEJ BAZY
        final notesForDay = GlobalData.getNotesForDay(currentDayDate);

        return GestureDetector(
          onTap: () => widget.onDaySelected(currentDayDate),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              border: Border.all(
                color: Colors.brown.withOpacity(0.15),
                width: 0.5,
              ),
            ),
            child: CustomPaint(
              painter: LinePainter(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      "$day",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSunday
                            ? Colors.red.shade900
                            : Colors.brown.shade900,
                      ),
                    ),
                  ),
                  // WYŚWIETLAMY MAŁE PASKI DLA KAŻDEJ NOTATKI (jeśli są)
                  ...notesForDay.map(
                    (note) => _buildHandwrittenMarker(note.content, note.color),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHandwrittenMarker(String text, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 8,
          color: Colors.white,
          fontStyle: FontStyle.italic,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.withOpacity(0.08)
      ..strokeWidth = 0.5;

    double gap = size.height / 10;
    for (int i = 1; i < 10; i++) {
      canvas.drawLine(Offset(0, gap * i), Offset(size.width, gap * i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
