import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static late SharedPreferences _prefs;

  // Initialize shared preferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Method to send OTP
  static Future<void> sendOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    await _firebaseAuth
        .verifyPhoneNumber(
      timeout: Duration(seconds: 30),
      phoneNumber: "$phone",
      verificationCompleted: (phoneAuthCredential) async {
        return;
      },
      verificationFailed: (error) async {
        return;
      },
      codeSent: (verificationId, forceResendingToken) async {
        // Store the verification ID in shared preferences
        await _prefs.setString('verificationId', verificationId);
        nextStep();
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        return;
      },
    )
        .onError((error, stackTrace) {
      errorStep();
    });
  }

  // Method to verify OTP and login
  static Future<String> loginWithOtp({required String otp}) async {
    // Retrieve verification ID from shared preferences
    String? verificationId = _prefs.getString('verificationId');
    if (verificationId == null) {
      return "Verification ID not found";
    }

    final cred = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      final userCredential = await _firebaseAuth.signInWithCredential(cred);
      if (userCredential.user != null) {
        return "Success";
      } else {
        return "Error in OTP login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Unknown error occurred";
    } catch (e) {
      return e.toString();
    }
  }

  // Method to logout
  static Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Method to check if user is logged in
  static Future<bool> isLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    return user != null;
  }
}
