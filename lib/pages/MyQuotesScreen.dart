import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_library/auth/database_helper.dart';
import 'package:smart_library/providers/user_provider.dart';
import 'package:smart_library/providers/my_books_provider.dart';
import 'package:smart_library/theme/app_themes.dart';
import 'AddNoteScreen.dart';

class MyQuotesScreen extends StatefulWidget {
  const MyQuotesScreen({Key? key}) : super(key: key);

  @override
  State<MyQuotesScreen> createState() => _MyQuotesScreenState();
}

class _MyQuotesScreenState extends State<MyQuotesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Navigation to the AddNoteScreen
  void _navigateToAddNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNoteScreen()),
    );

    // If result is true, it means a note was saved to the DB
    if (result == true) {
      setState(() {}); // This triggers the FutureBuilder to reload the list
    }
  }

  void _deleteQuote(int noteId) async {
    await _dbHelper.deleteNote(noteId);
    setState(() {}); // Refresh the list after deleting
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard!")),
    );
  }

  void _navigateToEditNotePage(Map<String, dynamic> quote) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNoteScreen(
          note: quote,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.currentUser?.usrId;
    if (userId != null) {
      Provider.of<MyBooksProvider>(context, listen: false).fetchUserBooks(userId);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.currentUser?.usrId;
    if (userId != null) {
      Provider.of<MyBooksProvider>(context, listen: false).fetchUserBooks(userId).then((_) {
        setState(() {}); // Ensure the UI updates after fetching data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNote,
        backgroundColor: isDark ? AppThemes.accentColor : Colors.black,
        foregroundColor: isDark ? Colors.black : Colors.white,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.getNotes(Provider.of<UserProvider>(context, listen: false).currentUser?.usrId ?? 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No quotes yet. Add one!',
              ),
            );
          }

          final quotes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return Card(
                color: isDark ? AppThemes.darkCardBg : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    quote['noteText'] ?? 'No text',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Page ${quote['pageNumber']}',
                          style: TextStyle(
                            color: isDark ? AppThemes.textSecondary : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Added on ${quote['date'] ?? ''}',
                          style: TextStyle(
                            color: isDark ? AppThemes.textTertiary : Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'copy',
                        onTap: () => _copyToClipboard(quote['noteText'] ?? ''),
                        child: Text('Copy', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                      ),
                      PopupMenuItem(
                        value: 'edit',
                        onTap: () => _navigateToEditNotePage(quote),
                        child: Text('Edit', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        onTap: () => _deleteQuote(quote['noteId']),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}