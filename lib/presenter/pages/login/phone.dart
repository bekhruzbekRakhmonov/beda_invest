import 'package:beda_invest/presenter/pages/login/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationID = '';
  bool _codeSending = false; // Track whether the code is being sent

  @override
  void initState() {
    countryController.text = "+998"; // Set default country code
    super.initState();
    // Check if the user is already logged in
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // User is already logged in, navigate to home screen
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  Future<void> _verifyPhoneNumber() async {
    // Extracting the country code and phone number
    String countryCode = countryController.text.trim();
    String phone = phoneController.text.trim();
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    // Checking if the country code and phone number meet the length requirements
    if (countryCode.length < 2 || countryCode.length > 4) {
      // Alert the user that the country code length is invalid
      _showAlert(
          context,
          appLocalizations?.invalidCountryCode ?? 'Invalid country code',
          appLocalizations?.countryCodeMustBe ??
              'Country code must be between 1 to 3 digits.');
      return;
    }

    if (phone.length < 8 || phone.length > 10) {
      // Alert the user that the phone number length is invalid
      _showAlert(
          context,
          appLocalizations?.invalidPhoneNumber ?? 'Invalid phone number',
          appLocalizations?.phoneNumberMustBe ??
              'Phone number must be between 8 to 10 digits after the country code.');
      return;
    }

    // Combine country code and phone number
    String fullPhoneNumber = '$countryCode$phone';

    setState(() {
      _codeSending = true; // Set _codeSending to true to display loader
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print('Automatic verification completed');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: ${e.message}');
        setState(() {
          _codeSending = false; // Reset loading state on failure
        });
        if (e.code == 'too-many-requests') {
          _showAlert(
              context,
              AppLocalizations.of(context)?.tooManyRequests ??
                  'Too many requests',
              AppLocalizations.of(context)
                      ?.weBlockedYouBecauseOfTooManyRequests ??
                  'We blocked you because of too many requests. Please try again later.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          verificationID = verificationId;
          _codeSending = false; // Set _codeSending to false to hide loader
        });
        // Navigate to verification page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyVerify(
              verificationId: verificationID,
              phoneNumber: fullPhoneNumber,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          verificationID = verificationId;
        });
      },
    );
  }

  void _showAlert(BuildContext context, String title, String message) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)?.ok ?? 'OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _launchURL() async {
    final Uri termsUri = Uri.parse('https://www.beda.uz/terms-of-service');
    if (!await launchUrl(termsUri)) {
      throw Exception('Could not launch $termsUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Theme.of(context).primaryColor == Color(0xff1c1b1f)
                        ? 'assets/images/logo_black_big.png'
                        : 'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 25),
                  Text(
                    appLocalizations?.phoneVerification ?? "Phone Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 45,
                          child: TextField(
                            controller: countryController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(fontSize: 33, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: appLocalizations?.phone ?? "Phone",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Text(appLocalizations?.bySigningIntoOurPlatform ??
                          "By signing into our platform, you accept our"),
                      GestureDetector(
                        onTap: () {
                          _launchURL(); // Function to launch the URL
                        },
                        child: Text(
                          appLocalizations?.termsOfService ??
                              "Terms of Service.",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.underline),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _codeSending
                          ? null
                          : () async {
                              await _verifyPhoneNumber();
                            },
                      child: Text(
                          appLocalizations?.sendTheCode ?? "Send the code"),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Loader widget
          if (_codeSending)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
