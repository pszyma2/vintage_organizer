import 'package:flutter/material.dart';
import 'calendar_view.dart';
import 'notes_view.dart';
import 'month_view.dart';
import 'weekly_view.dart'; // Upewnij się, że ten plik istnieje w folderze lib
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('pl_PL', null).then((_) {
    runApp(const VintageOrganizerApp());
  });
}

class VintageOrganizerApp extends StatelessWidget {
  const VintageOrganizerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Serif'),
      home: const MainOrganizerScreen(),
    );
  }
}

class MainOrganizerScreen extends StatefulWidget {
  const MainOrganizerScreen({super.key});
  @override
  State<MainOrganizerScreen> createState() => _MainOrganizerScreenState();
}

class _MainOrganizerScreenState extends State<MainOrganizerScreen> {
  bool _isOpened = false;
  int _activeTabIndex = 0; // 0: Rok, 1: Miesiąc, 2: Tydzień, 4: Notatki
  int _selectedMonth = 1;

  final Color _paperColor = const Color(0xFFF2E2C9);
  final Color _leatherColor = const Color(0xFF3E2723);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0B),
      body: SafeArea(child: _isOpened ? _buildInterior() : _buildCover()),
    );
  }

  Widget _buildInterior() {
    return Row(
      children: [
        // OBSZAR ROBOCZY (KARTKA)
        Expanded(
          child: Container(
            // Zmieniamy margin z 10 na 0 lub zostawiamy tylko minimalny góra/dół
            margin: const EdgeInsets.only(left: 0, top: 0, bottom: 0),
            decoration: BoxDecoration(
              color: _paperColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 10,
                  offset: Offset(-2, 0),
                ),
              ],
            ),
            child: _buildMainContent(),
          ),
        ),

        // PASEK ZAKŁADEK
        Container(
          width: 34,
          margin: const EdgeInsets.only(
            top: 0,
            bottom: 0,
            right: 0,
          ), // Usuwamy boczny margines
          child: Column(
            children: [
              _buildPhysicalTab("ROK", 0),
              // ... reszta bez zmian
              _buildPhysicalTab("MIES", 1),
              _buildPhysicalTab("TYDZ", 2),
              _buildPhysicalTab("DZIEŃ", 3),
              _buildPhysicalTab("NOTY", 4),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _isOpened = false),
                icon: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhysicalTab(String label, int index) {
    bool isActive = _activeTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: Container(
        width: 34,
        height: 75,
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: isActive ? _paperColor : Colors.brown[800],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: RotatedBox(
          quarterTurns: 1,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.brown[900] : Colors.white70,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 9,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    // Poprawiony switch - brak błędów z returnami i klamrami
    switch (_activeTabIndex) {
      case 0:
        return CalendarView(
          onMonthSelected: (monthNumber) {
            setState(() {
              _selectedMonth = monthNumber;
              _activeTabIndex = 1;
            });
          },
        );
      case 1:
        return MonthView(initialMonth: _selectedMonth);
      case 2:
        return const WeeklyView(); // Twoja nowa rozkładówka tygodniowa
      case 4:
        return const NotesView();
      default:
        return Center(
          child: Text(
            "WIDOK: $_activeTabIndex",
            style: const TextStyle(color: Colors.brown, fontSize: 16),
          ),
        );
    }
  }

  Widget _buildCover() {
    return GestureDetector(
      onTap: () => setState(() => _isOpened = true),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.88,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: _leatherColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 25)],
            border: Border.all(color: Colors.brown[900]!, width: 2),
          ),
          child: Center(
            child: Text(
              "VINTAGE ORGANIZER",
              style: TextStyle(
                color: Colors.brown[200],
                fontSize: 24,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
