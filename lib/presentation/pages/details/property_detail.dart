import 'package:beda_invest/data/api_calls/api_service.dart';
import 'package:beda_invest/domain/models/property_type.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_formatter/money_formatter.dart';

class PropertyDetailPage extends StatefulWidget {
  const PropertyDetailPage({Key? key, required this.propertyId})
      : super(key: key);
  final String propertyId;

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  late Future<Property> futureProperty;
  double initialInvestment = 50000;
  double propertyValueGrowth = 30;
  double expectedAnnualRentalYield = 5.65;

  @override
  void initState() {
    super.initState();
    futureProperty = fetchProperty(widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Property>(
      future: futureProperty,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (snapshot.hasData) {
          final property = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(property.title),
              actions: [
                IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
                IconButton(icon: Icon(Icons.help_outline), onPressed: () {}),
                IconButton(icon: Icon(Icons.share), onPressed: () {}),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: property.imageUrl,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(property.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(
                          '\$ ' +
                              MoneyFormatter(amount: property.price.toDouble())
                                  .output
                                  .withoutFractionDigits,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 60,
                          width: MediaQuery.sizeOf(context).width / 1.08,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5,
                                  color:
                                      const Color.fromARGB(255, 204, 204, 204)),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                              child: Text(
                            "View Virtual in 3D",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          )),
                        ),
                        SizedBox(height: 20),
                        _buildInvestorInfo(property),
                        SizedBox(height: 20),
                        _buildReturnInfo(),
                        SizedBox(height: 20),
                        Text(
                          property.description,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        _buildInvestmentCalculator(),
                        SizedBox(height: 20),
                        Container(
                          height: 60,
                          width: MediaQuery.sizeOf(context).width / 1.08,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 4, 65, 114),
                              border: Border.all(
                                  width: 0.5,
                                  color: Color.fromARGB(255, 204, 204, 204)),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                              child: Text(
                            "Invest",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(body: Center(child: Text("No data available")));
        }
      },
    );
  }

  Widget _buildInvestorInfo(Property property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline),
              SizedBox(width: 4),
              Text(
                '${property.investorsCount} investors',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: property.shares / (property.shares + property.sharesLeft),
          minHeight: 10,
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${property.shares} funded'),
            Text('${property.sharesLeft} available'),
          ],
        ),
      ],
    );
  }

  Widget _buildReturnInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildReturnRow("5 year total return", "47.12%"),
          _buildReturnRow("Yearly investment return", "9.42%"),
          _buildReturnRow("Projected net yield", "5.62%"),
        ],
      ),
    );
  }

  Widget _buildReturnRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInvestmentCalculator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Investment Calculator',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        _buildInvestmentSummary(),
        SizedBox(height: 20),
        _buildChart(),
        SizedBox(height: 20),
        _buildSliders(),
      ],
    );
  }

  Widget _buildInvestmentSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem('Investment',
            'USD ${initialInvestment.toStringAsFixed(0)}', Colors.black),
        _buildSummaryItem(
            'Total rent',
            'USD ${(initialInvestment * expectedAnnualRentalYield / 100 * 5).toStringAsFixed(0)}',
            Colors.amber),
        _buildSummaryItem(
            'Value growth',
            'USD ${(initialInvestment * propertyValueGrowth / 100).toStringAsFixed(0)}',
            Colors.green),
      ],
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12)),
        Text(value,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildChart() {
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < 5; i++) {
      double investment = initialInvestment;
      double rent = investment * expectedAnnualRentalYield / 100 * (i + 1);
      double growth = investment * propertyValueGrowth / 100 * (i + 1) / 5;
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(toY: investment, color: Colors.black),
          BarChartRodData(toY: rent, color: Colors.amber),
          BarChartRodData(toY: growth, color: Colors.green),
        ],
      ));
    }

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: initialInvestment * 2,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('${2025 + value.toInt()}');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliders() {
    return Column(
      children: [
        _buildSlider('Initial Investment', initialInvestment, 1000, 100000,
            (value) {
          setState(() => initialInvestment = value);
        }),
        _buildSlider(
            'Property value growth (5 year)', propertyValueGrowth, 0, 100,
            (value) {
          setState(() => propertyValueGrowth = value);
        }),
        _buildSlider(
            'Expected annual rental yield', expectedAnnualRentalYield, 0, 10,
            (value) {
          setState(() => expectedAnnualRentalYield = value);
        }),
      ],
    );
  }

  Widget _buildSlider(String title, double value, double min, double max,
      ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
            Text('${value.toStringAsFixed(2)}'),
          ],
        ),
      ],
    );
  }
}
