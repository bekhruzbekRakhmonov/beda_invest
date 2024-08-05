import 'package:beda_invest/data/services/settings_service.dart';
import 'package:beda_invest/domain/controllers/settings_controller.dart';
import 'package:beda_invest/presentation/pages/drawers/switch_languages.dart';
import 'package:beda_invest/presentation/pages/details/property_detail.dart';
import 'package:beda_invest/domain/models/property_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

// Ensure Property class is correctly defined elsewhere
class Property {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final int shares;
  final int investorsCount;
  final int sharesLeft;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.shares,
    required this.investorsCount,
    required this.sharesLeft,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Property>> futureProperties;

  @override
  void initState() {
    super.initState();
    futureProperties = _fetchProperties();
  }

  Future<List<Property>> _fetchProperties() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Properties').get();

      return querySnapshot.docs
          .map((doc) => Property(
              id: doc.id,
              title: doc['title'],
              description: doc['description'],
              imageUrl: doc['imageUrl'],
              price: doc['price'],
              shares: doc['shares'],
              investorsCount: doc['investorsCount'],
              sharesLeft: doc['sharesLeft']))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch properties: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = SettingsController(SettingsService());
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.language),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SwitchLanguages(settingsController: settingsController,),
              ),
            );
          },
        ),
        title: const Text(
          'beda. invest',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w900),
        ),
      ),
      // Uncomment if AppDrawer is needed and provide necessary params
      // drawer: AppDrawer(isLoggedIn: true),
      body: FutureBuilder<List<Property>>(
        future: futureProperties,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No properties found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return PropertyCard(property: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;

  PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailPage(propertyId: property.id),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  imageUrl: property.imageUrl,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                property.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                property.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 12.0),
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
              SizedBox(height: 12.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Shares:',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${property.price}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shares Left:',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${property.sharesLeft}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Investors:',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${property.investorsCount}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
