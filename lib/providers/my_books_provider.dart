import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:smart_library/auth/database_helper.dart';
import 'package:smart_library/models/books_model.dart';

import 'favorites_provider.dart';

class MyBooksProvider with ChangeNotifier {
  List<Book> _myBooks = [];
  List<String> _bookStates = []; // Parallel list for status
  
  bool _isLoading = false;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Book> get myBooks => _myBooks;
  List<String> get bookStates => _bookStates;
  bool get isLoading => _isLoading;

  // --- PAGE COUNTER LOGIC ---
  int _pagesCount = 0;
  int get pagesCount => _pagesCount;

  // 1. MEMORY ONLY: Use this when entering the screen
  void loadPagesCounter(int count) {
    _pagesCount = count;
    notifyListeners();
  }

  // 2. DATABASE & MEMORY: Use this when clicking "Save"
  Future<void> savePageToDatabase(String bookId, int userId, int page) async {
    _pagesCount = page;

    final index = _myBooks.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      final oldBook = _myBooks[index];
      final newBook = oldBook.copyWith(pages: page);
      _myBooks[index] = newBook;
    }
    
    notifyListeners(); 

    try {
      await _dbHelper.updatePageProgress(bookId, userId, page);
    } catch (e) {
      debugPrint("Error saving page: $e");
    }
  }

  // --- BOOK LIST LOGIC ---

  Future<void> fetchUserBooks(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _myBooks = await _dbHelper.getUserBooks(userId);
      // Load states in order. Default to 'Not Read'
      _bookStates = _myBooks.map((book) => (book.status == null || book.status.isEmpty) ? 'Not Read' : book.status).toList();
    } catch (e) {
      debugPrint("Error fetching books: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBook(Book book, int userId) async {
    try {
      await _dbHelper.insertUserBook(book, userId);
      _myBooks.add(book);
      _bookStates.add('Not Read'); 
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding book: $e");
      rethrow;
    }
  }

  Future<void> updateState(int index, String bookId, int userId, String newStatus) async {
    if (index < 0 || index >= _bookStates.length) return;

    _bookStates[index] = newStatus;
    
    // Si l'utilisateur marque le livre comme fini ("Finished")
    if (newStatus == 'Finished') {
      // On cherche le livre dans la liste mémoire
      final bookIndex = _myBooks.indexWhere((b) => b.id == bookId);
      if (bookIndex != -1) {
        final book = _myBooks[bookIndex];
        // On vérifie si on connait le nombre total de pages (totalPages > 0)
        // et si la progression actuelle est inférieure au total.
        if (book.totalPages > 0 && book.pages < book.totalPages) {
          // On simule une progression jusqu'à la fin
          // Cela va ajouter la différence dans 'daily_reading_log' via updatePageProgress
          debugPrint("Auto-completing book: updating pages from ${book.pages} to ${book.totalPages}");
          
          // Mise à jour mémoire
          _myBooks[bookIndex] = book.copyWith(pages: book.totalPages);
          
          // Mise à jour DB (cela déclenchera le log des pages "lues" aujourd'hui)
          await _dbHelper.updatePageProgress(bookId, userId, book.totalPages);
        }
      }
    }

    notifyListeners();

    await _dbHelper.updateBookState(bookId, userId, newStatus);
    await _dbHelper.updateReadingHistory(bookId, userId, newStatus);
  }

  Future<void> removeBook(String bookId, int userId) async {
    try {
      await _dbHelper.removeUserBook(bookId, userId);
      int index = _myBooks.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        _myBooks.removeAt(index);
        _bookStates.removeAt(index);


      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error removing book: $e");
    }
  }
}