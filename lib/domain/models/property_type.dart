import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final dynamic price;
  final dynamic shares;
  final dynamic investorsCount;
  final dynamic sharesLeft;

  Property({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.shares,
    required this.investorsCount,
    required this.sharesLeft,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        price: json['price'],
        shares: json['shares'],
        investorsCount: json['investorsCount'],
        sharesLeft: json['sharesLeft']);
  }

  // New fromFirestore factory constructor
  factory Property.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Property(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      price: data['price'],
      shares: data['shares'],
      investorsCount: data['investorsCount'],
      sharesLeft: data['sharesLeft'],
    );
  }
}
