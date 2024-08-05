import 'package:flutter/material.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Row(
              children: [
                Text('USD', style: TextStyle(color: Colors.white)),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Portfolio Value', style: TextStyle(fontSize: 16)),
              const Text('USD 0',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCircularButton(Icons.arrow_upward, 'Invest', Colors.blue),
                  _buildCircularButton(Icons.add, 'Deposit', Colors.blue),
                ],
              ),
              const SizedBox(height: 20),
              _buildEarningCard(),
              const SizedBox(height: 20),
              _buildPortfolioBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: Icon(icon,
              color: color == Colors.white ? Colors.blue : Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildEarningCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_city, color: Colors.blue[300]),
                const SizedBox(width: 8),
                const Text('Start earning on Beda Invest',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Text(
                'Become a property owner and start earning passive income'),
            const SizedBox(height: 16),
            _buildInfoRow(
                Icons.description, 'Receive legal ownership documents'),
            _buildInfoRow(Icons.payment, 'Receive rental payments every month'),
            _buildInfoRow(
                Icons.trending_up, 'Earn property appreciation over time'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildPortfolioBuilder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white),
              SizedBox(width: 8),
              Text('Portfolio builder',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Create your portfolio',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const Text(
              'Our quickstart tool helps get you get started with your first investment',
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('Quickstart portfolio',
                style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
