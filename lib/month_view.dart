import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Biblioteka do nazw miesięcy

class MonthView extends StatefulWidget {
  final int initialMonth; // Miesiąc wybrany z widoku roku

  const MonthView({super.key, required this.initialMonth});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Ustawiamy start na miesiącu wybranym przez Ciebie
    _pageController = PageController(initialPage: widget.initialMonth - 1);
  }

  @override
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
                ),
              ),
              const Divider(color: Colors.brown),
              _buildDaysOfWeek(),

              // Siatka dni - teraz z większymi "okami"
              Expanded(child: _buildDaysGrid(displayDate)),

              // NOWA SEKCJA NA DOLE
              Container(
                height: 160,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.brown.withAlpha(50)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "PRIORYTETY MIESIĄCA:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _simpleLine("1."),
                    _simpleLine("2."),
                    _simpleLine("3."),
                    _simpleLine("4."),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildDaysOfWeek() {
  List<String> days = ["PN", "WT", "ŚR", "CZ", "PT", "SO", "ND"];
  return Row(
    children: days
        .map(
          (d) => Expanded(
            child: Center(
              child: Text(
                d,
                style: const TextStyle(
                  fontSize: 10,
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
    physics:
        const NeverScrollableScrollPhysics(), // Blokujemy przewijanie siatki, by użyć Column
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 7,
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      childAspectRatio: 0.55, // WYDŁUŻAMY OKIENKA - teraz będą "wysokie"
    ),
    itemCount: daysInMonth + (firstWeekday - 1),
    itemBuilder: (context, index) {
      if (index < firstWeekday - 1) return const SizedBox();

      int dayNumber = index - (firstWeekday - 2);
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.brown.withOpacity(0.15)),
          color: Colors.white.withAlpha(40),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            "$dayNumber",
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      );
    },
  );
}

Widget _simpleLine(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.brown)),
        const SizedBox(width: 8),
        const Expanded(child: Divider(color: Colors.brown, thickness: 0.5)),
      ],
    ),
  );
}
