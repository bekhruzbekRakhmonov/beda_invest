import 'package:beda_invest/data/api_calls/api_service.dart';
import 'package:beda_invest/domain/models/property_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PropertyDetailPage extends StatefulWidget {
  const PropertyDetailPage({super.key, required this.propertyId});
  final String propertyId;

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  late Future<Property> futureProperty;

  @override
  void initState() {
    futureProperty = fetchProperty(widget.propertyId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Property>(
      future: futureProperty,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final property = snapshot.data!;
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CarouselSlider.builder(
                        itemCount: property.imageUrl.length,
                        itemBuilder: (context, index, realIndex) {
                          return CachedNetworkImage(
                            imageUrl: property.imageUrl[index],
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            height: 300,
                            fit: BoxFit.cover,
                          );
                        },
                        options: CarouselOptions(
                          height: 300,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: true,
                          autoPlay: false,
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 20,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      // Add other icons (bookmark, question mark, share)
                    ],
                  ),

                  // Property details
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(property.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),

                        // Price and financing details
                        Text('USD ${property.price}',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 10,
                        ),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.people_outline_rounded),
                              Text(
                                property.investorsCount.toString(),
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'investors',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            value: 0.84,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green),
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            minHeight: 10, // Adjust height as needed
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${property.shares} funded'),
                            Text('${property.sharesLeft} available'),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          width: MediaQuery.sizeOf(context).width / 1.07,
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(246, 238, 238, 238),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "5 year total return",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "47.12%",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Yearly investment return",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "9.42%",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Projected yet yield",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "5.62%",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          property.description,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: Text("error"),
          );
        }
      },
    );
  }
}
