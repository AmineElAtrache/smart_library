import 'package:flutter/material.dart';
import 'package:smart_library/pages/add_book_screen.dart';
import 'package:smart_library/pages/books_screen.dart';
import 'package:smart_library/pages/home_screen.dart';
import 'package:smart_library/pages/setting.dart';
import 'package:smart_library/theme/app_themes.dart';
import 'MyQuotesScreen.dart' as quotes_screen;

class Layout extends StatefulWidget {
  final int? id_page;

  const Layout({super.key, this.id_page});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.id_page != null) {
      _currentIndex = widget.id_page!;
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddBookScreen()),
      );
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> pages = [
      HomeScreen(onTabChange: _onItemTapped),
      const MyBooksScreen(),
      const SizedBox(),
      const quotes_screen.MyQuotesScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppThemes.darkBg : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppThemes.darkBg : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Flutter Ebook App',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppThemes.darkCardBg : Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppThemes.darkCardBg : Colors.white,
          selectedItemColor: isDark ? AppThemes.accentColor : Colors.black,
          unselectedItemColor: isDark ? AppThemes.textTertiary : Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'My Books',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppThemes.accentColor : Colors.black,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: isDark ? Colors.black : Colors.white,
                  size: 28,
                ),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.format_quote_outlined),
              activeIcon: Icon(Icons.format_quote_sharp),
              label: 'Quotes',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
