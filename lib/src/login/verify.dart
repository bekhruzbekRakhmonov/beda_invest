import 'dart:async';

import 'package:beda_invest/src/login/user_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyVerify extends StatefulWidget {
  String verificationId;
  String phoneNumber;
  late User user;
  final UserService userService = UserService();

  MyVerify({Key? key, required this.verificationId, required this.phoneNumber}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _smsController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  late Timer _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
    // Listen to the authentication state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // If there is a user logged in, navigate to the home screen.
        setState(() {
          widget.user = user;
        });
        checkUserData();
      }
      // If there is no user logged in, stay in the current screen (or handle accordingly).
    });
  }

  @override
  void dispose() {
    _smsController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _resendVerificationCode() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _start = 60; // Reset timer
            startTimer(); // Start timer again
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code Auto Retrieval Timeout");
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> checkUserData() async {
    try {
      Map<String, String> userData =
          await widget.userService.getUserData(widget.user.uid);

      if (userData.isNotEmpty) {
        // User data found, navigate to home screen
        // Navigator.pushReplacementNamed(context, '/home');
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        // User data not found, navigate to authorization screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthorizationScreen(user: widget.user),
          ),
        );
      }
    } catch (e) {
      print(e);
      // Handle error here, maybe show an error message to the user
    }
  }

  void _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _smsController.text,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Proceed to authorization after authentication
        setState(() {
          widget.user = user;
        });
        await checkUserData();
      } else {
        print('Failed to sign in with phone number.');
      }
    } catch (e) {
      // Handle verification errors here
      print(e.toString());
      // Show error message to the user
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)?.verificationError ?? 'Verification Error'),
            content: Text(AppLocalizations.of(context)?.inavlidVerificationCode ??
                'Invalid verification code. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                    AppLocalizations.of(context)?.ok ?? 'OK'),
              ),
            ],
          );
        },
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations?.phoneVerification ?? 'Phone Verification'),
      ),
      body: Container(
        margin: EdgeInsets.all(25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appLocalizations?.phoneVerification ?? "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (pin) {
                  // You can handle pin changes if necessary
                },
                controller: _smsController,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${appLocalizations?.resendCodeIn ?? 'Resend Code in'} $_start ${appLocalizations?.seconds ?? 'seconds'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _start == 0 ? _resendVerificationCode : null,
                    child: Text(appLocalizations?.resend ?? 'Resend'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    _signInWithPhoneNumber();
                  },
                  child: Text(appLocalizations?.verifyPhoneNumber ?? "Verify Phone Number"),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(appLocalizations?.editPhoneNumber ?? "Edit Phone Number"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthorizationScreen extends StatefulWidget {
  final User user;
  final UserService userService = UserService();

  AuthorizationScreen({required this.user});

  @override
  _AuthorizationScreenState createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations?.authorization ?? 'Authorization'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${appLocalizations?.hello}, ${widget.user.phoneNumber}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              appLocalizations?.pleaseProvideYourFirstAndLastName ?? 'Please provide your first name and last name:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: appLocalizations?.firstName ?? 'First Name',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: appLocalizations?.lastName ?? 'Last Name',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Proceed with authorization process
                String firstName = firstNameController.text;
                String lastName = lastNameController.text;
                if (firstName.isNotEmpty && lastName.isNotEmpty) {
                  try {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('user_id', widget.user.uid);
                    await prefs.setString('first_name', firstName);
                    await prefs.setString('last_name', lastName);

                    await widget.userService
                        .saveUserData(widget.user.uid, firstName, lastName);
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/home', (route) => false);
                  } catch (e) {
                    print('Error saving user data: $e');
                  }
                } else {
                  // Show an error message or handle empty fields
                }
              },
              child: Text(appLocalizations?.finish ?? 'Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
