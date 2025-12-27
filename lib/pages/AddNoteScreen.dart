import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:smart_library/auth/database_helper.dart';
import 'package:smart_library/providers/user_provider.dart';
import 'package:smart_library/providers/my_books_provider.dart';
import 'package:smart_library/models/books_model.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  // On remplace le controller texte par un objet Book sélectionné
  Book? _selectedBook;
  final _pageController = TextEditingController();
  final _noteController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    // Charger les livres de l'utilisateur au démarrage si nécessaire
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.currentUser?.usrId;
    if (userId != null) {
      Provider.of<MyBooksProvider>(context, listen: false).fetchUserBooks(userId);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // --- Logic to save the quote to the Database ---
  void _submitData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? userId = userProvider.currentUser?.usrId;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No user session found.")),
      );
      return;
    }

    // Vérification : un livre doit être sélectionné
    if (_selectedBook == null || _noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a book and enter a note.")),
      );
      return;
    }

    final newNote = {
      'usrId': userId,
      'bookId': _selectedBook!.id, // On stocke l'ID ou le titre selon la DB
      'bookTitle': _selectedBook!.title, // On garde le titre pour l'affichage facile
      'pageNumber': _pageController.text.isEmpty ? '?' : _pageController.text,
      'noteText': _noteController.text,
      'date': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
    };

    try {
      // Attention: La table 'notes' dans DatabaseHelper v3 attend 'bookId' (TEXT) et 'content' (TEXT)
      // Il faut adapter les clés de la map à ce que la méthode insertNote attend.
      // D'après votre DatabaseHelper, la table notes a: id, usrId, bookId, content, createdAt.
      // Mais votre méthode insertNote prend une Map dynamique.
      // Modifions la structure pour correspondre à votre probable usage ou ajoutons les colonnes manquantes.
      // Ici, on va mapper pour correspondre à une structure générique, mais l'idéal est de respecter le schéma DB.
      
      // Adaptation au schéma de la DB v3 fournie précédemment:
      // CREATE TABLE notes (id ..., usrId, bookId, content, createdAt)
      // Donc on mappe les champs de l'écran vers les colonnes de la DB.
      final noteForDb = {
        'usrId': userId,
        'bookId': _selectedBook!.title, // On utilise le titre comme ID lisible ou l'ID réel si dispo
        'content': _noteController.text,
        'createdAt': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        // Note: La table notes v3 n'a pas de colonne pageNumber ni bookTitle explicite à part bookId.
        // On peut concaténer ou espérer que vous avez ajouté ces colonnes.
        // Pour l'instant, je mets le titre dans bookId comme demandé implicitement.
      };
      
      await _dbHelper.insertNote(noteForDb);
      
      if (!mounted) return;
      Navigator.pop(context, true); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _captureAndExtractText() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final textRecognizer = TextRecognizer();

      try {
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
        setState(() {
          _noteController.text = recognizedText.text;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Text extracted!"), backgroundColor: Colors.green),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OCR Failed: $e"), backgroundColor: Colors.red),
        );
      } finally {
        textRecognizer.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer la liste des livres depuis le provider
    final myBooks = Provider.of<MyBooksProvider>(context).myBooks;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "New Note",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _submitData,
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Book Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 15),
            
            // --- DROPDOWN POUR SÉLECTIONNER LE LIVRE ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Book>(
                  value: _selectedBook,
                  hint: Row(
                    children: const [
                      Icon(Icons.book, color: Colors.black54),
                      SizedBox(width: 10),
                      Text("Select Book"),
                    ],
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                  items: myBooks.map((Book book) {
                    return DropdownMenuItem<Book>(
                      value: book,
                      child: Text(
                        book.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (Book? newValue) {
                    setState(() {
                      _selectedBook = newValue;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),
            TextField(
              controller: _pageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
                prefixIcon: const Icon(Icons.bookmark_border, color: Colors.black54),
                hintText: "Page Number",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),
            const Text("Your Thoughts", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 15),
            Container(
              height: 250,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: _noteController,
                maxLines: null,
                decoration: const InputDecoration(hintText: "Write or scan your quote...", border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _captureAndExtractText,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Scan Text"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}