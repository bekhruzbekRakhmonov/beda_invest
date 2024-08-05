import 'package:beda_invest/presentation/pages/drawers/app_drawer.dart';
import 'package:beda_invest/presentation/pages/details/property_detail.dart';
import 'package:beda_invest/domain/models/property_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'beda. invest',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w900),
        ),
      ),
      drawer: AppDrawer(isLoggedIn: true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                return PropertyCard(property: properties[index]);
              },
            ),
          ),
        ],
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
                  placeholder: (context, url) => Center(
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
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                property.description,
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
                style: TextStyle(
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
                        Text(
                          'Total Shares:',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${property.shares}',
                          style: TextStyle(
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
                        Text(
                          'Shares Left:',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${property.sharesLeft}',
                          style: TextStyle(
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
                        Text(
                          'Investors:',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '${property.investorsCount}',
                          style: TextStyle(
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

final List<Property> properties = [
  Property(
    id: '1',
    imageUrl:
        'https://frankfurt.apollo.olxcdn.com/v1/files/n8rqrpr6lr0g3-UZ/image;s=1000x700',
    title: 'Dala hovli Yunusobod tumanida',
    description:
        'A beautiful house located in the heart of Yunusobod district.',
    price: 1000000,
    shares: 10000,
    investorsCount: 40,
    sharesLeft: 800,
  ),
  Property(
    id: '2',
    imageUrl:
        'https://frankfurt.apollo.olxcdn.com/v1/files/t5b1y93v5ew1-UZ/image;s=1000x700',
    title: 'Dala hovli Chorvokda',
    description: 'A modern apartment located in Charvak.',
    price: 2000000,
    shares: 200,
    investorsCount: 40,
    sharesLeft: 160,
  ),
  // Add more properties here
];
