import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Portfolio Value', style: TextStyle(fontSize: 18)),
              const Text('\$5,943',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const Text('Last 30 Days +12%',
                  style: TextStyle(fontSize: 16, color: Colors.green)),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 1),
                          const FlSpot(1, 3),
                          const FlSpot(2, 2),
                          const FlSpot(3, 4),
                          const FlSpot(4, 3),
                          const FlSpot(5, 5),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 2,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('1D', style: TextStyle(color: Colors.blue)),
                  Text('1W'),
                  Text('1M'),
                  Text('3M'),
                  Text('1Y'),
                ],
              ),
              const SizedBox(height: 20),
              _buildShareItem('1.24', '25.00'),
              _buildShareItem('0.96', '20.00'),
              _buildShareItem('2.10', '40.00'),
              _buildShareItem('6.02', '120.00'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareItem(String shares, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Shares', style: TextStyle(fontSize: 16)),
              Text(shares,
                  style: const TextStyle(fontSize: 14, color: Colors.blue)),
            ],
          ),
          Text('\$$value', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
