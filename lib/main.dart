import 'package:flutter/material.dart';
import 'calendar_view.dart';
import 'notes_view.dart';
import 'month_view.dart';
import 'weekly_view.dart';
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
  int _activeTabIndex = 0;

  // Te dwie zmienne trzymają informację, co wybraliśmy w widoku roku
  int _selectedMonth = 1;
  int _selectedYear = 2026;

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
        // Ta część (PAPIER) ma PageView w środku
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: _paperColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              // To blokuje "wypływanie" kartki poza zaokrąglone rogi
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: _buildMainContent(),
            ),
          ),
        ),

        // Ta część (ZAKŁADKI) jest NIERUCHOMA
        Container(
          width: 34,
          color: const Color(
            0xFF1A0F0B,
          ), // Kolor tła, żeby nie było widać czarnych dziur
          child: Column(
            children: [
              _buildPhysicalTab("ROK", 0),
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
    switch (_activeTabIndex) {
      case 0:
        // Poprawione: teraz przyjmuje miesiąc I rok z CalendarView
        return CalendarView(
          onMonthSelected: (monthNumber, yearNumber) {
            setState(() {
              _selectedMonth = monthNumber;
              _selectedYear = yearNumber;
              _activeTabIndex = 1;
            });
          },
        );
      case 1:
        return MonthView(initialMonth: _selectedMonth);
      case 2:
        return const WeeklyView();
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
