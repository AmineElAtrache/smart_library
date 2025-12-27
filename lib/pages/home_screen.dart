import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:smart_library/models/books_model.dart';
import 'package:smart_library/providers/my_books_provider.dart';
import 'package:smart_library/providers/favorites_provider.dart';
import 'package:smart_library/pages/book_datails_screen.dart';
// import '../widgets/calender.dart'; // Décommentez si vous avez ce fichier

class HomeScreen extends StatefulWidget {
  // Callback pour changer d'onglet depuis le Home
  final Function(int) onTabChange;

  const HomeScreen({Key? key, required this.onTabChange}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ImageProvider _buildBookImage(String thumbnail) {
    if (thumbnail.isEmpty) {
      return const AssetImage('assets/images/test.jpg');
    }
    if (thumbnail.startsWith('http')) {
      return NetworkImage(thumbnail);
    }
    // Pour les images locales ou fichiers, ajustez selon votre logique
    // Ici on suppose que c'est une URL ou un asset par défaut pour simplifier,
    // mais si vous gérez des fichiers locaux :
    // return FileImage(File(thumbnail));
    return const AssetImage('assets/images/test.jpg');
  }

  void _navigateToDetails(Book book) {
    // Naviguer vers les détails du livre
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer les livres depuis le provider
    final myBooksProvider = Provider.of<MyBooksProvider>(context);
    final allBooks = myBooksProvider.myBooks;
    
    // On inverse pour avoir les plus récents en premier, comme dans MyBooksScreen
    final recentBooks = allBooks.reversed.take(3).toList();

    // Calcul des statistiques réelles
    final finishedCount = allBooks.where((b) => b.status == 'Finished').length;
    final readingCount = allBooks.where((b) => b.status == 'Reading').length;
    final toReadCount = allBooks.where((b) => b.status == 'Not Read' || b.status == 'To Read').length;
    final totalCount = allBooks.length;

    // Calcul du pourcentage de progression global (basé sur le nombre de livres finis vs total)
    // Ou on pourrait calculer la moyenne des pages lues si on avait l'info précise
    double progressPercent = totalCount > 0 ? (finishedCount / totalCount) : 0.0;
    // On peut aussi ajouter un peu de poids pour les livres en cours
    if (totalCount > 0) {
      progressPercent += (readingCount * 0.5) / totalCount;
    }
    // Clamp to 1.0 max
    if (progressPercent > 1.0) progressPercent = 1.0;


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 1. CALENDRIER (Placeholder si vous ne l'avez pas encore intégré)
          // const CalendarWidget(),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // --- A. CARTE PROGRESSION (Noire) ---
                _buildProgressCard(progressPercent),

                const SizedBox(height: 30),

                // ==========================================================
                // --- SECTION STATISTIQUES (FL_CHART) ---
                // ==========================================================
                const Text(
                  "Statistics",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // 1. Pie Chart (Statut de lecture)
                ReadingStatusChart(
                  finished: finishedCount,
                  reading: readingCount,
                  toRead: toReadCount,
                ),
                const SizedBox(height: 15),

                // 2. Bar Chart (Catégories)
                CategoryBarChart(books: allBooks),
                const SizedBox(height: 15),

                // 3. Line Chart (Progression mensuelle) - Placeholder pour l'instant car requiert historique complexe
                const MonthlyProgressChart(),

                const SizedBox(height: 30),
                // ==========================================================

                // --- C. OVERVIEW HEADER ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Overview",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        // Redirige aussi vers "My Books" (index 1)
                        widget.onTabChange(1);
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // --- CARTES CATÉGORIES (Thème Gris/Noir) ---
                Row(
                  children: [
                    Expanded(child: _buildCategoryCard("Total Books", "$totalCount Books", Icons.collections_bookmark_outlined)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCategoryCard("Finished", "$finishedCount Books", Icons.done_all)), 
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildCategoryCard("Reading", "$readingCount Books", Icons.menu_book)), 
                    const SizedBox(width: 16),
                    Expanded(child: _buildCategoryCard("To Read", "$toReadCount Books", Icons.bookmark_border)), 
                  ],
                ),

                const SizedBox(height: 40),

                // --- D. RECENTLY ADDED (Nouveau) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recently Added",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                     IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: () {
                         // Action filtre ou navigation vers My Books
                         widget.onTabChange(1);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (recentBooks.isEmpty)
                  const Text("No books added recently.")
                else
                  Consumer<FavoriteBooksProvider>(
                    builder: (context, favoritesProvider, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentBooks.length,
                        itemBuilder: (context, index) {
                          final book = recentBooks[index];
                          // Vérifier si le livre est déjà dans les favoris
                          final isFavorite = favoritesProvider.favorites.any((b) => b.id == book.id);
                          return _buildRecentBookItem(context, book, isFavorite);
                        },
                      );
                    },
                  ),
                  
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBookItem(BuildContext context, Book book, bool isFavorite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _navigateToDetails(book),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: _buildBookImage(book.thumbnail),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                    ),
                  ]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.authors.join(', '),
                    style: const TextStyle(
                      color: Color(0xFF4F46E5),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey.shade400,
                      height: 1.4,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // --- BOUTON FAVORIS ---
            IconButton(
              onPressed: () {
                final provider = Provider.of<FavoriteBooksProvider>(context, listen: false);
                if (isFavorite) {
                   provider.removeFavorite(book.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${book.title} removed from favorites')),
                    );
                } else {
                   provider.addFavorite(book);
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${book.title} added to favorites')),
                   );
                }
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: const Color(0xFFFF4757),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET : CARTE NOIRE ---
  Widget _buildProgressCard(double percent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black, // Fond Noir
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
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // C'EST ICI QUE LA MAGIE OPÈRE :
                    // On demande au parent (Layout) de changer l'onglet vers l'index 1 (My Books)
                    widget.onTabChange(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black, // Texte noir
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  value: percent,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text("${(percent * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          )
        ],
      ),
    );
  }

  // --- WIDGET : CARTE CATÉGORIE ---
  Widget _buildCategoryCard(String title, String count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA), // Gris Clair
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

// ==============================================================================
// WIDGETS GRAPHIQUES (FL_CHART) - Placé ici pour faciliter le copier-coller
// ==============================================================================

// --- 1. PIE CHART : STATUT ---
class ReadingStatusChart extends StatelessWidget {
  final int finished;
  final int reading;
  final int toRead;

  const ReadingStatusChart({super.key, required this.finished, required this.reading, required this.toRead});

  @override
  Widget build(BuildContext context) {
    // Si tout est à zéro, on affiche un graphique vide ou par défaut
    bool isEmpty = (finished == 0 && reading == 0 && toRead == 0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Reading Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              children: [
                Expanded(
                  child: isEmpty 
                  ? Center(child: Text("No data yet", style: TextStyle(color: Colors.grey)))
                  : PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 30,
                      sections: [
                        if (finished > 0)
                        PieChartSectionData(value: finished.toDouble(), color: Colors.black, radius: 25, showTitle: false),
                        if (reading > 0)
                        PieChartSectionData(value: reading.toDouble(), color: Colors.grey.shade600, radius: 25, showTitle: false),
                        if (toRead > 0)
                        PieChartSectionData(value: toRead.toDouble(), color: Colors.grey.shade300, radius: 25, showTitle: false),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(Colors.black, "Finished ($finished)"),
                    _buildLegendItem(Colors.grey.shade600, "Reading ($reading)"),
                    _buildLegendItem(Colors.grey.shade300, "To Read ($toRead)"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// --- 2. BAR CHART : CATÉGORIES ---
class CategoryBarChart extends StatelessWidget {
  final List<Book> books;
  const CategoryBarChart({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    // Compter les catégories
    Map<String, int> counts = {};
    for (var book in books) {
      String cat = (book.category.isEmpty) ? "General" : book.category;
      counts[cat] = (counts[cat] ?? 0) + 1;
    }
    
    // Prendre le top 5
    var sortedKeys = counts.keys.toList()..sort((a,b) => counts[b]!.compareTo(counts[a]!));
    var top5 = sortedKeys.take(5).toList();

    if (top5.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(20)),
          child: const Center(child: Text("No category data yet")),
        );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= top5.length) return const SizedBox();
                        String text = top5[index];
                        // Shorten text
                        if (text.length > 4) text = text.substring(0, 3);
                        
                        const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10);
                        return SideTitleWidget(meta: meta, child: Text(text, style: style));
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(top5.length, (index) {
                   return _makeBarData(index, counts[top5[index]]!.toDouble());
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarData(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(toY: y, color: Colors.black, width: 12, borderRadius: BorderRadius.circular(4))
    ]);
  }
}

// --- 3. LINE CHART : PROGRESSION MENSUELLE ---
class MonthlyProgressChart extends StatelessWidget {
  const MonthlyProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monthly Activity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold);
                        switch(value.toInt()) {
                          case 0: return const Text('Jan', style: style);
                          case 2: return const Text('Mar', style: style);
                          case 4: return const Text('May', style: style);
                          case 6: return const Text('Jul', style: style);
                          default: return const Text('');
                        }
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1), FlSpot(1, 3), FlSpot(2, 2), FlSpot(3, 5),
                      FlSpot(4, 4), FlSpot(5, 7), FlSpot(6, 6),
                    ],
                    isCurved: true,
                    color: Colors.black,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}