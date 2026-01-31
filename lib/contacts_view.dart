import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'global_data.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  // OSTATNIA I NAJLEPSZA WERSJA MAP
  Future<void> _openMap(ContactEntry c) async {
    // Budujemy czytelny tekst adresu
    final String fullAddress = "${c.street}, ${c.postCode} ${c.city}";

    // Format 'geo:0,0?q=' to uniwersalny sygnał dla Androida: "Otwórz mapę i znajdź to"
    final Uri uri = Uri.parse("geo:0,0?q=${Uri.encodeComponent(fullAddress)}");

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        // Jeśli geo: nie zadziała (rzadko na Samsungu), próbujemy standardowego linku
        final Uri webUri = Uri.parse(
          "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(fullAddress)}",
        );
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Błąd otwierania mapy: $e");
    }
  }

  Future<void> _makeCall(String phone) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _showContactDialog({ContactEntry? contact, int? index}) {
    TextEditingController nameCtrl = TextEditingController(
      text: contact?.name ?? "",
    );
    TextEditingController phoneCtrl = TextEditingController(
      text: contact?.phone ?? "",
    );
    TextEditingController cityCtrl = TextEditingController(
      text: contact?.city ?? "",
    );
    TextEditingController postCtrl = TextEditingController(
      text: contact?.postCode ?? "",
    );
    TextEditingController streetCtrl = TextEditingController(
      text: contact?.street ?? "",
    );
    TextEditingController infoCtrl = TextEditingController(
      text: contact?.info ?? "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF2E2C9),
        title: Text(contact == null ? "Nowy wpis" : "Edytuj kontakt"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Imię i Nazwisko"),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: "Telefon"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: streetCtrl,
                decoration: const InputDecoration(labelText: "Ulica i nr domu"),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: postCtrl,
                      decoration: const InputDecoration(
                        labelText: "Kod pocztowy",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: cityCtrl,
                      decoration: const InputDecoration(labelText: "Miasto"),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: infoCtrl,
                decoration: const InputDecoration(labelText: "Uwagi"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Anuluj"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E2723),
            ),
            onPressed: () async {
              setState(() {
                final newEntry = ContactEntry(
                  name: nameCtrl.text,
                  phone: phoneCtrl.text,
                  street: streetCtrl.text,
                  postCode: postCtrl.text,
                  city: cityCtrl.text,
                  info: infoCtrl.text,
                );

                if (index == null) {
                  GlobalData.allContacts.add(newEntry);
                } else {
                  GlobalData.allContacts[index] = newEntry;
                }
              });
              await GlobalData.saveToDisk();
              Navigator.pop(context);
            },
            child: const Text("Zapisz", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E2C9),
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            "ADRESOWNIK",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E2723),
              letterSpacing: 4,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: GlobalData.allContacts.length,
              itemBuilder: (context, index) {
                final c = GlobalData.allContacts[index];
                return Card(
                  color: Colors.white.withOpacity(0.5),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      c.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(c.phone),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            if (c.street.isNotEmpty || c.city.isNotEmpty)
                              ListTile(
                                leading: const Icon(
                                  Icons.map,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  "${c.street}\n${c.postCode} ${c.city}",
                                ),
                                onTap: () => _openMap(c),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                  ),
                                  onPressed: () => _makeCall(c.phone),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () => _showContactDialog(
                                    contact: c,
                                    index: index,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    setState(
                                      () => GlobalData.allContacts.removeAt(
                                        index,
                                      ),
                                    );
                                    await GlobalData.saveToDisk();
                                  },
                                ),
                              ],
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3E2723),
        onPressed: () => _showContactDialog(),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}
