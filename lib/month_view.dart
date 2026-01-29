import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthView extends StatefulWidget {
  final int initialMonth; // Przywracamy parametr, który wywalał błąd

  const MonthView({super.key, required this.initialMonth});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Ustawiamy start na miesiącu wybranym w widoku roku
    _pageController = PageController(initialPage: widget.initialMonth - 1);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        DateTime displayDate = DateTime(2026, index + 1);
        String monthName = DateFormat(
          'MMMM yyyy',
          'pl_PL',
        ).format(displayDate).toUpperCase();

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                monthName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.brown,
                ),
              ),
              const Divider(color: Colors.brown, thickness: 1),
              _buildDaysOfWeek(),

              // Siatka dni - powiększona pod S24 Ultra
              Expanded(child: _buildDaysGrid(displayDate)),

              // Sekcja priorytetów na dole
              Container(
                height: 180,
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.brown.withAlpha(60)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "PRIORYTETY MIESIĄCA:",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _priorityLine("1."),
                    _priorityLine("2."),
                    _priorityLine("3."),
                    _priorityLine("4."),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDaysOfWeek() {
    List<String> days = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'So', 'Nd'];
    return Row(
      children: days
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDaysGrid(DateTime date) {
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    int firstWeekday = DateTime(date.year, date.month, 1).weekday;

    return GridView.builder(
      padding: const EdgeInsets.only(top: 10),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 0.6,
      ),
      itemCount: daysInMonth + (firstWeekday - 1),
      itemBuilder: (context, index) {
        if (index < firstWeekday - 1) return const SizedBox();
        int dayNumber = index - (firstWeekday - 2);

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.brown.withAlpha(40)),
            color: Colors.white.withAlpha(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "$dayNumber",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _priorityLine(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.brown),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Divider(color: Colors.brown, thickness: 0.5)),
        ],
      ),
    );
  }
}
