import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';

  Future<void> verifyPhone(String phoneNumber) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      // TODO: Handle authenticated user
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      // Handle error
      print(authException.message);
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      // Navigate to OTP screen
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void signInWithOTP(String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      // TODO: Handle authenticated user
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Replace the phone number with the desired phone number for testing
            verifyPhone('+48739056620');
          },
          child: Text('Verify Phone Number'),
        ),
      ),
    );
  }
}
