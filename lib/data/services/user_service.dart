import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(
      String userId, String firstName, String lastName) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
      });
    } catch (e) {
      print('Error saving user data: $e');
      throw e;
    }
  }

  Future<Map<String, String>> getUserData(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();

      if (snapshot.exists) {
        return {
          'firstName': snapshot.data()!['firstName'],
          'lastName': snapshot.data()!['lastName'],
        };
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw e;
    }
  }

  Future<void> updateUserData(
      String userId, String firstName, String lastName) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'firstName': firstName,
        'lastName': lastName,
      });
    } catch (e) {
      print('Error updating user data: $e');
      throw e;
    }
  }
}
