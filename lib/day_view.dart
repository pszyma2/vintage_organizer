import 'package:flutter/material.dart';

class DayView extends StatefulWidget {
  final DateTime initialDate;
  const DayView({super.key, required this.initialDate});

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  late PageController _pageController;
  final int _initialPage = 10000; // Duży zapas stron w obie strony

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  DateTime _getDateForPage(int page) {
    return widget.initialDate.add(Duration(days: page - _initialPage));
  }

  @override
  Widget build(BuildContext context) {
    const Color paperColor = Color(0xFFF2E2C9);
    const Color leatherColor = Color(0xFF3E2723);

    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        final date = _getDateForPage(index);
        return _buildDayContent(date, paperColor, leatherColor);
      },
    );
  }

  Widget _buildDayContent(DateTime date, Color paperColor, Color leatherColor) {
    // Tu wstawiamy cały Twój poprzedni design dnia (Nagłówek + Lista godzin)
    final monthNames = [
      "STYCZNIA",
      "LUTEGO",
      "MARCA",
      "KWIETNIA",
      "MAJA",
      "CZERWCA",
      "LIPCA",
      "SIERPNIA",
      "WRZEŚNIA",
      "PAŹDZIERNIKA",
      "LISTOPADA",
      "GRUDNIA",
    ];
    final weekDays = [
      "Poniedziałek",
      "Wtorek",
      "Środa",
      "Czwartek",
      "Piątek",
      "Sobota",
      "Niedziela",
    ];

    return Scaffold(
      backgroundColor: paperColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: paperColor,
              border: Border(bottom: BorderSide(color: leatherColor, width: 2)),
            ),
            child: Column(
              children: [
                Text(
                  weekDays[date.weekday - 1].toUpperCase(),
                  style: TextStyle(
                    color: leatherColor.withOpacity(0.7),
                    letterSpacing: 5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${date.day} ${monthNames[date.month - 1]} ${date.year}",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: leatherColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: 24,
              itemBuilder: (context, hIndex) {
                return Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFD7CCC8), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          "${hIndex.toString().padLeft(2, '0')}:00",
                          style: TextStyle(
                            color: leatherColor.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(width: 1, color: Colors.red.withOpacity(0.2)),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
