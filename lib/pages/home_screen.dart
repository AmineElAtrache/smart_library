import 'package:flutter/material.dart';

import '../widgets/stats_widgets.dart';
// IMPORTANT : Importez le fichier des charts qu'on vient de créer
// import '../widgets/stats_widgets.dart';
// (Pour l'instant, si vous mettez tout dans le même fichier, pas besoin d'import)

// Assurez-vous d'avoir bien installé fl_chart dans pubspec.yaml

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 1. CALENDRIER
          // const CalendarWidget(), // Décommentez si vous l'avez
          const SizedBox(height: 20), // Placeholder pour le calendrier

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // --- A. CARTE PROGRESSION (Noire) ---
                _buildProgressCard(),

                const SizedBox(height: 30),

                // ==========================================================
                // --- NOUVELLE SECTION : STATISTIQUES (FL_CHART) ---
                // ==========================================================
                const Text(
                  "Statistics",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // 1. Pie Chart (Statut)
                const ReadingStatusChart(),
                const SizedBox(height: 15),

                // 2. Bar Chart (Catégories) et Line Chart (Mois)
                // On peut les mettre l'un sous l'autre
                const CategoryBarChart(),
                const SizedBox(height: 15),
                const MonthlyProgressChart(),

                const SizedBox(height: 30),
                // ==========================================================


                // --- C. CATEGORY HEADER (Ancien code) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Overview",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "View All",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // --- CARTES CATÉGORIES (Noir/Gris) ---
                Row(
                  children: [
                    Expanded(child: _buildCategoryCard("Total Books", "25 Books", Icons.collections_bookmark_outlined)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCategoryCard("Finished", "12 Books", Icons.done_all)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildCategoryCard("Reading", "3 Books", Icons.menu_book)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCategoryCard("To Read", "10 Books", Icons.bookmark_border)),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- ANCIENS WIDGETS (Conservés) ---

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Keep going,\nyour progress is great!",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("My Books", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const SizedBox(width: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80, height: 80,
                child: CircularProgressIndicator(
                  value: 0.63, strokeWidth: 8, backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), strokeCap: StrokeCap.round,
                ),
              ),
              const Text("63%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.black, size: 22),
          ),
          const SizedBox(height: 20),
          Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}