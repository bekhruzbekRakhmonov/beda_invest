import 'package:beda_invest/domain/models/property_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Property> fetchProperty(String propertyId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    DocumentSnapshot doc =
        await firestore.collection('Properties').doc(propertyId).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Property.fromJson(data);
    } else {
      throw Exception('Property not found');
    }
  } catch (e) {
    throw Exception('Failed to load property: $e');
  }
}
