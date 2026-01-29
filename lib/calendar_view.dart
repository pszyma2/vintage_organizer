import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  // Dodajemy "callback" - funkcję, która powie main.dart, że kliknięto miesiąc
  final Function(int) onMonthSelected;

  const CalendarView({super.key, required this.onMonthSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> months = [
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          const Text(
            "PLAN ROKU 2026",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
            ),
          ),
          const SizedBox(height: 10),

          // Siatka miesięcy - dociągnięta, by lepiej wypełniać górę
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.58,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onMonthSelected(index + 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.brown.withOpacity(0.1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          months[index],
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Colors.brown,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // WYPEŁNIENIE DOŁU - Sekcja na notatki/cele roczne
          // WYPEŁNIENIE DOŁU - Sekcja na notatki/cele roczne
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 15, bottom: 5),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.brown.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "KLUCZOWE CELE / NOTATKI:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tutaj wstawiamy 5 linii
                  _buildLine("1."),
                  _buildLine("2."),
                  _buildLine("3."),
                  _buildLine("4."),
                  _buildLine("5."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.brown,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Divider(
                color: Colors.brown,
                thickness: 0.8,
              ), // Nieco grubsza linia
            ),
          ],
        ),
        const SizedBox(
          height: 18,
        ), // TO JEST TA PRZERWA - zwiększyłem ją, żeby było rzadziej
      ],
    );
  }
}
