import 'package:flutter/material.dart';
import 'package:smart_library/pages/add_book_screen.dart'; // Importez votre page d'ajout
import 'package:smart_library/pages/books_screen.dart';
import 'package:smart_library/pages/home_screen.dart';
import 'package:smart_library/pages/setting.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  // Liste des VRAIES pages (sans la page d'ajout car elle s'ouvre par dessus)
  final List<Widget> _pages = [
    const HomeScreen(),
    const MyBooksScreen(),
    const AddBookScreen(), // Place-holder (ne sera jamais affiché)
    const SettingsScreen()
  ];

  int _currentIndex = 0;

  // Fonction pour gérer la navigation
  void _onItemTapped(int index) {
    // Si l'utilisateur clique sur le bouton "+" (index 2)
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddBookScreen()),
      );
      return; // On arrête ici pour ne pas changer l'onglet actif en dessous
    }

    // Sinon, on change l'onglet normalement
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ---------- APP BAR ----------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Flutter Ebook App',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ---------- BODY ----------
      // On affiche la page correspondante.
      // Si c'est Settings (index 3), _pages[3] affichera SettingsScreen.
      body: _pages[_currentIndex],

      // ---------- BOTTOM NAV ----------
      bottomNavigationBar: Container(
        // Petite ombre pour détacher la barre du contenu blanc
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed, // Important pour 4 items et +
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black, // Noir quand sélectionné
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0, // On gère l'ombre via le Container au dessus

          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home), // Icône pleine quand active
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'My Books',
            ),

            // --- LE BOUTON SPÉCIAL (ADD) ---
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(12), // Espace interne pour agrandir le cercle
                decoration: BoxDecoration(
                  color: Colors.black, // Le fond NOIR (Thème App)
                  shape: BoxShape.circle, // Forme ronde
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white, // Icône blanche pour contraster
                  size: 28, // Icône un peu plus grande
                ),
              ),
              label: '', // Pas de texte pour ce bouton
            ),
            // -------------------------------

            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label:'profile'
            )
          ],
        ),
      ),
    );
  }
}