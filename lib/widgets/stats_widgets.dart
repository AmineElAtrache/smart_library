import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// --- 1. PIE CHART : STATUT DE LECTURE ---
class ReadingStatusChart extends StatelessWidget {
  const ReadingStatusChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA), // Gris clair du thème
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
                // Le Graphique
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 30,
                      sections: [
                        PieChartSectionData(value: 12, color: Colors.black, radius: 25, showTitle: false), // Finished
                        PieChartSectionData(value: 3, color: Colors.grey.shade600, radius: 25, showTitle: false), // Reading
                        PieChartSectionData(value: 10, color: Colors.grey.shade300, radius: 25, showTitle: false), // To Read
                      ],
                    ),
                  ),
                ),
                // La Légende
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(Colors.black, "Finished (12)"),
                    _buildLegendItem(Colors.grey.shade600, "Reading (3)"),
                    _buildLegendItem(Colors.grey.shade300, "To Read (10)"),
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
  const CategoryBarChart({super.key});

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
                        const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10);
                        String text;
                        switch (value.toInt()) {
                          case 0: text = 'Thriller'; break;
                          case 1: text = 'Romance'; break;
                          case 2: text = 'Sci-Fi'; break;
                          case 3: text = 'Drama'; break;
                          case 4: text = 'History'; break;
                          default: text = '';
                        }
                        return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: style));
                      },
                    ),
                  ),
                ),
                barGroups: [
                  _makeBarData(0, 8),
                  _makeBarData(1, 10),
                  _makeBarData(2, 4),
                  _makeBarData(3, 6),
                  _makeBarData(4, 3),
                ],
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
          const Text("Monthly Read Books", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                        // On affiche 1 mois sur 2 pour l'exemple
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
                      color: Colors.black.withOpacity(0.05), // Ombre légère sous la courbe
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