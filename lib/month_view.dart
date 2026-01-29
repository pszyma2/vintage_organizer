import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthView extends StatefulWidget {
  final int initialMonth;

  const MonthView({super.key, required this.initialMonth});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialMonth - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF8),
      body: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          DateTime displayDate = DateTime(2026, index + 1);
          String monthName = DateFormat(
            'LLLL yyyy',
            'pl_PL',
          ).format(displayDate).toUpperCase();

          return Padding(
            padding: const EdgeInsets.only(top: 24, left: 4, right: 4),
            child: Column(
              children: [
                Text(
                  monthName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: Color(0xFF5D4037),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Divider(color: Color(0xFF5D4037), thickness: 1.5),
                ),
                _buildDaysOfWeek(),

                // Kalendarz - teraz całkowicie bez linii (czysty widok)
                Expanded(flex: 2, child: _buildDaysGrid(displayDate)),

                // SEKCJA NOTATNIKA - Linie od brzegu do brzegu
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 10, bottom: 8),
                        child: Text(
                          "PRIORYTETY MIESIĄCA:",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildNotebookLines(
                          14,
                        ), // Jeszcze więcej linii na notatki
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    List<String> days = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'So', 'Nd'];
    return Row(
      children: List.generate(7, (index) {
        // Niedziela (index 6) na czerwono
        Color dayColor = (index == 6)
            ? Colors.red.shade700
            : const Color(0xFF5D4037);
        return Expanded(
          child: Center(
            child: Text(
              days[index],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: dayColor,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDaysGrid(DateTime date) {
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    int firstWeekday = DateTime(date.year, date.month, 1).weekday;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio:
            1.3, // Jeszcze bardziej płaskie, by zyskać miejsce na notatnik
      ),
      itemCount: daysInMonth + (firstWeekday - 1),
      itemBuilder: (context, index) {
        if (index < firstWeekday - 1) return const SizedBox();
        int dayNumber = index - (firstWeekday - 2);

        // Obliczamy czy to niedziela (niedziela w tej siatce to zawsze index będący wielokrotnością 7 minus 1)
        bool isSunday = (index + 1) % 7 == 0;

        return Container(
          alignment: Alignment.center,
          child: Text(
            "$dayNumber",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSunday ? Colors.red.shade700 : Colors.black87,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotebookLines(int count) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      separatorBuilder: (context, index) => Divider(
        color: const Color(0xFF5D4037).withAlpha(40),
        height: 1,
        thickness: 0.8,
      ),
      itemBuilder: (context, index) => const SizedBox(height: 32),
    );
  }
}
