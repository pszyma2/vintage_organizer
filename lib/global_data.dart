import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. KLASA NOTATKI (zostaje bez zmian, bo działa perfekcyjnie)
class DailyNote {
  final DateTime date;
  final int hour;
  final String content;
  final Color color;

  DailyNote({
    required this.date,
    required this.hour,
    required this.content,
    this.color = const Color(0xFFD32F2F),
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'hour': hour,
    'content': content,
    'color': color.value,
  };

  factory DailyNote.fromJson(Map<String, dynamic> json) => DailyNote(
    date: DateTime.parse(json['date']),
    hour: json['hour'],
    content: json['content'],
    color: Color(json['color']),
  );
}

// 2. KLASA KONTAKTU (ROZBUDOWANA O ADRES)
class ContactEntry {
  String name;
  String phone;
  String city; // NOWE
  String postCode; // NOWE (uniwersalny tekst)
  String street; // NOWE
  String info;

  ContactEntry({
    required this.name,
    required this.phone,
    this.city = "",
    this.postCode = "",
    this.street = "",
    this.info = "",
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'city': city,
    'postCode': postCode,
    'street': street,
    'info': info,
  };

  factory ContactEntry.fromJson(Map<String, dynamic> json) => ContactEntry(
    name: json['name'],
    phone: json['phone'],
    city: json['city'] ?? "",
    postCode: json['postCode'] ?? "",
    street: json['street'] ?? "",
    info: json['info'] ?? "",
  );
}

// 3. CENTRUM ZARZĄDZANIA DANYMI
class GlobalData {
  static List<DailyNote> allNotes = [];
  static List<ContactEntry> allContacts = [];

  // PANCERNY ZAPIS WSZYSTKIEGO
  static Future<void> saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();

    // Zapisujemy notatki
    String notesJson = jsonEncode(allNotes.map((n) => n.toJson()).toList());
    await prefs.setString('my_calendar_notes', notesJson);

    // Zapisujemy kontakty (teraz z adresem)
    String contactsJson = jsonEncode(
      allContacts.map((c) => c.toJson()).toList(),
    );
    await prefs.setString('my_contacts', contactsJson);

    print(
      "DANE ZAPISANE: Notatek: ${allNotes.length}, Kontaktów: ${allContacts.length}",
    );
  }

  // ODCZYT PRZY STARCIE
  static Future<void> loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();

    // Ładowanie notatek
    String? notesData = prefs.getString('my_calendar_notes');
    if (notesData != null) {
      allNotes = (jsonDecode(notesData) as List)
          .map((i) => DailyNote.fromJson(i))
          .toList();
    }

    // Ładowanie kontaktów
    String? contactsData = prefs.getString('my_contacts');
    if (contactsData != null) {
      allContacts = (jsonDecode(contactsData) as List)
          .map((i) => ContactEntry.fromJson(i))
          .toList();
    }
  }

  static List<DailyNote> getNotesForDay(DateTime date) {
    return allNotes
        .where(
          (note) =>
              note.date.year == date.year &&
              note.date.month == date.month &&
              note.date.day == date.day,
        )
        .toList();
  }
}
