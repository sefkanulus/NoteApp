import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<TextEditingController> controllers = [];
  List<Widget> notes = []; //oluşacak textfield ları tutacak
  List<String> noteTexts = []; // metinlerini tutacak
  String searchText = ''; //Arama metni

  @override
  void initState() {
    super.initState(); // Üst sınıfın (State sınıfının) initState metodunu çalıştırarak gerekli başlangıç işlemlerini yapar.
    addNewNote();
  }

  void addNewNote() {
    var controller = TextEditingController();
    controllers.add(controller);
    noteTexts.add('');
    setState(() {
      notes.insert(
        0,
        createNoteWidget(controller, controllers.length - 1),
      );
      var sonElemean = notes.removeAt(notes.length-1);
      notes.insert(0, sonElemean);
    });

  }

  Widget createNoteWidget(TextEditingController controller, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 38, 36, 44),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (text) {
            noteTexts[index] = text; // Notun metnini güncelle
          },
          decoration: InputDecoration(
            hintText: "Not alın...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  void removeNoteAt(int index) {
    setState(() {
      notes.removeAt(index);
      controllers.removeAt(index);
      noteTexts.removeAt(index);

      if (notes.isEmpty) {
        addNewNote();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filtreleme
    final filteredNotes = noteTexts
        .asMap()
        .entries
        .where((entry) =>
            entry.value.toLowerCase().contains(searchText.toLowerCase()))
        .map((entry) => createNoteWidget(controllers[entry.key], entry.key))
        .toList();
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        brightness: Brightness.dark,
        inputDecorationTheme: const InputDecorationTheme(
          counterStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            // Arama kutucuğu
            Container(
              margin: const EdgeInsets.only(left: 50, right: 50, top: 10),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    searchText = value; // Arama metnini güncelle
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Notlarınızda arayın...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Color.fromARGB(255, 38, 36, 44),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                reverse: false,
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: filteredNotes[index],
                      ),
                      IconButton(
                        onPressed: () {
                          int originalIndex = noteTexts.indexOf(
                              noteTexts.firstWhere((text) => text
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase())));
                          removeNoteAt(originalIndex); // Seçili notu sil
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Sadece son metin alanı boş değilse yeni bir not ekle
                        if (controllers.isNotEmpty &&
                            controllers.last.text.isNotEmpty) {
                          addNewNote();
                        }
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                      iconSize: 45,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          notes.clear();
                          controllers.clear();
                          noteTexts.clear(); // Not metinlerini de temizle
                          addNewNote(); // İlk notu daima göster.
                        });
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



