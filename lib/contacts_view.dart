import 'package:flutter/material.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  // Przykładowa lista kontaktów (później będzie lecieć z bazy danych)
  final List<Map<String, String>> _allContacts = [
    {"name": "Paweł Vintage", "phone": "777 888 999"},
    {"name": "Adam Kowalski", "phone": "123 456 789"},
    {"name": "Bogdan Tiramisu", "phone": "987 654 321"},
    {"name": "Cezary Flutter", "phone": "555 666 777"},
    {"name": "Dariusz S-Pen", "phone": "111 222 333"},
    {"name": "Ewa Google", "phone": "444 000 111"},
    {"name": "Gemini Mistrz", "phone": "000 000 000"},
  ];

  final List<String> _alphabet = List.generate(
    26,
    (index) => String.fromCharCode(65 + index),
  );
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    const Color paperColor = Color(0xFFF2E2C9);
    const Color leatherColor = Color(0xFF3E2723);

    return Scaffold(
      backgroundColor: paperColor,
      body: Row(
        children: [
          // GŁÓWNA LISTA KONTAKTÓW
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "ADRESOWNIK",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                      color: leatherColor,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: _allContacts.length,
                    separatorBuilder: (context, index) => Divider(
                      color: leatherColor.withValues(alpha: 0.1),
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    itemBuilder: (context, index) {
                      final contact = _allContacts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: leatherColor,
                          child: Text(
                            contact['name']![0],
                            style: const TextStyle(color: paperColor),
                          ),
                        ),
                        title: Text(
                          contact['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: leatherColor,
                          ),
                        ),
                        subtitle: Text(
                          contact['phone']!,
                          style: TextStyle(
                            color: leatherColor.withValues(alpha: 0.6),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.phone,
                          color: Colors.green,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // PASKIEM Z ALFABETEM (Nawigacja boczna)
          Container(
            width: 30,
            color: leatherColor.withValues(alpha: 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _alphabet
                  .map(
                    (letter) => Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Tu w przyszłości dodamy skok do konkretnej litery
                          print("Szukamy litery: $letter");
                        },
                        child: Center(
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: leatherColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
