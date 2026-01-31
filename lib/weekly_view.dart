import 'package:flutter/material.dart';

class WeeklyView extends StatefulWidget {
  final Function(DateTime) onDaySelected;
  final DateTime referenceDate;

  const WeeklyView({
    super.key,
    required this.onDaySelected,
    required this.referenceDate,
  });

  @override
  State<WeeklyView> createState() => _WeeklyViewState();
}

class _WeeklyViewState extends State<WeeklyView> {
  late PageController _weekController;
  final int _initialPage = 1000; // Środek, żeby można było cofać lata

  @override
  void initState() {
    super.initState();
    _weekController = PageController(initialPage: _initialPage);
  }

  // Ta magia oblicza datę dla konkretnej strony (przeskok o 7 dni)
  DateTime _getStartDateForPage(int page) {
    int offset = (page - _initialPage) * 7;
    return widget.referenceDate.add(
      Duration(days: offset - (widget.referenceDate.weekday - 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _weekController,
      itemBuilder: (context, index) {
        final monday = _getStartDateForPage(index);
        return _buildWeekPage(monday);
      },
    );
  }

  Widget _buildWeekPage(DateTime monday) {
    final sunday = monday.add(const Duration(days: 6));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            // Dodaliśmy rok na końcu:
            "TYDZIEN ${monday.day}.${monday.month.toString().padLeft(2, '0')} - ${sunday.day}.${sunday.month.toString().padLeft(2, '0')}.${monday.year}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing:
                  2, // Trochę zmniejszyłem, żeby rok się ładnie zmieścił
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
                    _buildDayBlock("PONIEDZIAŁEK", monday),
                    _buildDayBlock(
                      "WTOREK",
                      monday.add(const Duration(days: 1)),
                    ),
                    _buildDayBlock(
                      "ŚRODA",
                      monday.add(const Duration(days: 2)),
                      isLast: true,
                    ),
                  ],
                ),
              ),
              Container(width: 1, color: const Color(0xFF5D4037).withAlpha(40)),
              // PRAWA KOLUMNA: Cz, Pt, Weekend
              Expanded(
                child: Column(
                  children: [
                    _buildDayBlock(
                      "CZWARTEK",
                      monday.add(const Duration(days: 3)),
                    ),
                    _buildDayBlock(
                      "PIĄTEK",
                      monday.add(const Duration(days: 4)),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          _buildDayBlock(
                            "SOBOTA",
                            monday.add(const Duration(days: 5)),
                            isWeekend: true,
                          ),
                          _buildDayBlock(
                            "NIEDZIELA",
                            monday.add(const Duration(days: 6)),
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
    String name,
    DateTime date, {
    bool isLast = false,
    bool isWeekend = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onDaySelected(date),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
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
                "$name ${date.day}.${date.month}",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: name == "NIEDZIELA"
                      ? Colors.red.shade700
                      : const Color(0xFF5D4037),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
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
                        height: 25,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
