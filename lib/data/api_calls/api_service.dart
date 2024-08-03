// api_service.dart

import 'dart:convert';
import 'package:beda_invest/domain/models/property_type.dart';
import 'package:http/http.dart' as http;

Future<Property> fetchProperty(String propertyId) async {
  final response =
      await http.get(Uri.parse('https://your-api.com/properties/$propertyId'));

  if (response.statusCode == 200) {
    return Property.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load property');
  }
}
