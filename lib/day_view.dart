import 'package:flutter/material.dart';
import 'global_data.dart'; // NASZ WSPÓLNY ZESZYT

class DayView extends StatefulWidget {
  final DateTime initialDate;
  const DayView({super.key, required this.initialDate});

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  late PageController _pageController;
  final int _initialPage = 10000;

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
          // NAGŁÓWEK DNIA
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: paperColor,
              border: Border(
                bottom: BorderSide(color: leatherColor, width: 1.5),
              ),
            ),
            child: Column(
              children: [
                Text(
                  weekDays[date.weekday - 1].toUpperCase(),
                  style: TextStyle(
                    color: leatherColor.withOpacity(0.6),
                    letterSpacing: 4,
                    fontSize: 10,
                  ),
                ),
                Text(
                  "${date.day} ${monthNames[date.month - 1]} ${date.year}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: leatherColor,
                  ),
                ),
              ],
            ),
          ),

          // LISTA GODZIN (NASZE SPACJE)
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 24,
              itemBuilder: (context, hIndex) {
                // Szukamy czy mamy notatkę na tę konkretną godzinę
                final notes = GlobalData.getNotesForDay(date);
                final noteAtThisHour = notes
                    .where((n) => n.hour == hIndex)
                    .firstOrNull;

                return GestureDetector(
                  onTap: () => _showNoteDialog(
                    context,
                    date,
                    hIndex,
                    noteAtThisHour?.content ?? "",
                  ),
                  child: Container(
                    height: 55,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFD7CCC8),
                          width: 0.8,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            "${hIndex.toString().padLeft(2, '0')}:00",
                            style: TextStyle(
                              color: leatherColor.withOpacity(0.4),
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Colors.red.withOpacity(0.15),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            child: Text(
                              noteAtThisHour?.content ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontStyle: FontStyle.italic,
                                fontFamily:
                                    'Parisienne', // Jeśli masz ten font, będzie WOW
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // OKIENKO DO WPISYWANIA
  void _showNoteDialog(
    BuildContext context,
    DateTime date,
    int hour,
    String currentText,
  ) {
    TextEditingController controller = TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF2E2C9),
        title: Text(
          "Godzina $hour:00",
          style: const TextStyle(color: Color(0xFF3E2723)),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Wpisz coś ważnego..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Anuluj", style: TextStyle(color: Colors.brown)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E2723),
            ),
            onPressed: () async {
              // 1. Dodaj 'async' tutaj
              setState(() {
                // Usuwamy starą notatkę
                GlobalData.allNotes.removeWhere(
                  (n) =>
                      n.date.year == date.year &&
                      n.date.month == date.month &&
                      n.date.day == date.day &&
                      n.hour == hour,
                );
                // Dodajemy nową
                if (controller.text.isNotEmpty) {
                  GlobalData.allNotes.add(
                    DailyNote(date: date, hour: hour, content: controller.text),
                  );
                }
              });

              // 2. KLUCZOWY MOMENT - ZAPIS NA DYSK
              await GlobalData.saveToDisk();

              if (mounted) Navigator.pop(context);
            },
            child: const Text("Zapisz", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
