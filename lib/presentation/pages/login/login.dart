import 'dart:async';
import 'package:beda_invest/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: constant_identifier_names
enum PhoneVerificationState { SHOW_PHONE_FORM_STATE, SHOW_OTP_FORM_STATE }

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final GlobalKey<ScaffoldState> _scaffoldKeyForSnackBar = GlobalKey();
  PhoneVerificationState currentState =
      PhoneVerificationState.SHOW_PHONE_FORM_STATE;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  TextEditingController countryController = TextEditingController(text: "+998");
  String? verificationIDFromFirebase;
  bool spinnerLoading = false;
  late Timer _timer;
  int _start = 60; // Countdown duration in seconds

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  _verifyPhoneButton() async {
    setState(() {
      spinnerLoading = true;
    });
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: countryController.text + phoneController.text,
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {
          spinnerLoading = false;
        });
      },
      verificationFailed: (verificationFailed) async {
        setState(() {
          spinnerLoading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Verification Code Failed: ${verificationFailed.message}"),
        ));
      },
      codeSent: (verificationId, resendingToken) async {
        setState(() {
          spinnerLoading = false;
          currentState = PhoneVerificationState.SHOW_OTP_FORM_STATE;
          this.verificationIDFromFirebase = verificationId;
        });
        startTimer();
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  _verifyOTPButton() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationIDFromFirebase!,
      smsCode: otpController.text,
    );
    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      spinnerLoading = true;
    });
    try {
      final authCredential =
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      setState(() {
        spinnerLoading = false;
      });
      if (authCredential?.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        spinnerLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? "An error occurred"),
      ));
    }
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _resendOTP() async {
    setState(() {
      _start = 60;
    });
    _verifyPhoneButton();
  }

  getPhoneFormWidget(context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return Column(
      children: [
        const Text(
          "Enter authentication phone number\nUse country code (eg: +94712345678)",
          style: const TextStyle(fontSize: 16.0),
        ),
        const SizedBox(
          height: 40.0,
        ),
        Container(
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 45,
                child: TextField(
                  controller: countryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Text(
                "|",
                style: TextStyle(fontSize: 33, color: Colors.grey),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Phone",
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              String phoneNumber =
                  '${countryController.text}${phoneController.text}';
              await _verifyPhoneButton();
            },
            child: Text(appLocalizations?.sendTheCode ?? "Send the code"),
          ),
        )
      ],
    );
  }

  getOTPFormWidget(context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return Column(
      children: [
        const Text(
          "Enter OTP Number",
          style: const TextStyle(fontSize: 16.0),
        ),
        const SizedBox(
          height: 40.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < 6; i++)
                SizedBox(
                  width: 45,
                  height: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (i == 5 && value.isNotEmpty) {
                        // Auto-submit or verify OTP when the last digit is entered
                        _verifyOTPButton();
                      } else if (value.isNotEmpty) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _verifyOTPButton,
            child:
                Text(appLocalizations?.verifyPhoneNumber ?? "Verify the code"),
          ),
        ),
        const SizedBox(height: 10),
        _start == 0
            ? ElevatedButton(
                onPressed: _resendOTP,
                child: Text(appLocalizations?.resend ?? "Resend"),
              )
            : Text(
                "Resend the code in $_start seconds",
                style: TextStyle(fontSize: 12),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKeyForSnackBar,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                const Column(
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Flutter Firebase Phone Auth",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40.0,
                ),
                spinnerLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : currentState ==
                            PhoneVerificationState.SHOW_PHONE_FORM_STATE
                        ? getPhoneFormWidget(context)
                        : getOTPFormWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
