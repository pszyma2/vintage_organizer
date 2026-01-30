import 'package:flutter/material.dart';

class CalendarView extends StatefulWidget {
  final Function(int, int) onMonthSelected;
  const CalendarView({super.key, required this.onMonthSelected});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late PageController _yearController;
  final int _initialYear = 2026;

  @override
  void initState() {
    super.initState();
    _yearController = PageController(initialPage: _initialYear);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2E2C9),
      child: PageView.builder(
        controller: _yearController,
        physics: const ClampingScrollPhysics(parent: PageScrollPhysics()),
        itemBuilder: (context, index) => _buildYearPage(index),
      ),
    );
  }

  Widget _buildYearPage(int year) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Center(
          child: Text(
            "PLAN ROKU $year",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 6,
              color: Color(0xFF5D4037),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // KALENDARZ
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemCount: 12,
            itemBuilder: (context, index) => _buildMiniMonth(year, index + 1),
          ),
        ),

        const SizedBox(height: 20),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            "PRIORYTETY ROKU:",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
          ),
        ),

        const SizedBox(height: 5),
        // LINIE
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) => Container(
              height: 35,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.brown.withOpacity(0.15),
                    width: 0.8,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniMonth(int year, int month) {
    final List<String> monthNames = [
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

    return GestureDetector(
      onTap: () => widget.onMonthSelected(month, year),
      child: Column(
        children: [
          Text(
            monthNames[month - 1],
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 2),
          _buildWeekdayRow(),
          Expanded(child: _buildDaysGrid(year, month)),
        ],
      ),
    );
  }

  Widget _buildWeekdayRow() {
    const days = ["P", "W", "Ś", "C", "P", "S", "N"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map(
            (d) => Text(
              d,
              style: TextStyle(
                fontSize: 7,
                color: d == "N" ? Colors.red.shade900 : Colors.brown.shade700,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDaysGrid(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final startingEmptySlots = firstDay.weekday - 1;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: startingEmptySlots + daysInMonth,
      itemBuilder: (context, index) {
        if (index < startingEmptySlots) return const SizedBox();
        int dayNum = index - startingEmptySlots + 1;
        bool isSunday = (index + 1) % 7 == 0;
        return Center(
          child: Text(
            "$dayNum",
            style: TextStyle(
              fontSize: 8,
              color: isSunday ? Colors.red.shade900 : Colors.black87,
            ),
          ),
        );
      },
    );
  }
} // KONIEC KLASY
