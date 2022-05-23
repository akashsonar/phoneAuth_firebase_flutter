import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'HomeScreen.dart';

class OTPService extends StatefulWidget {
  final String phone;
  final String codeDigits;
  const OTPService({Key? key, required this.phone, required this.codeDigits})
      : super(key: key);

  @override
  State<OTPService> createState() => _OTPServiceState();
}

class _OTPServiceState extends State<OTPService> {
  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${widget.codeDigits + widget.phone}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            if (value.user != null) {
              return Navigator.push(context,
                  MaterialPageRoute(builder: (builder) {
                return const HomeScreen();
              }));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message.toString()),
            duration: const Duration(seconds: 3),
          ));
        },
        codeSent: (String? vID, int? resendToken) {
          setState(() {
            verificationCode = vID;
          });
        },
        codeAutoRetrievalTimeout: (String vID) {
          setState(() {
            verificationCode = vID;
          });
        },
        timeout: const Duration(seconds: 60));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();
  String? verificationCode;

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: Colors.grey));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("OTP Verification"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/otp.png"),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Center(
                child: GestureDetector(
              onTap: () {
                verifyPhoneNumber();
              },
              child: Text(
                "Verifing : ${widget.codeDigits}-${widget.phone}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Pinput(
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsUserConsentApi,
                  hapticFeedbackType: HapticFeedbackType.mediumImpact,
                  length: 6,
                  focusNode: _pinOTPCodeFocus,
                  controller: _pinOTPCodeController,
                  onCompleted: (pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: verificationCode!, smsCode: pin))
                          .then((value) {
                        if (value.user != null) {
                          return Navigator.push(context,
                              MaterialPageRoute(builder: (builder) {
                            return const HomeScreen();
                          }));
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Invalid OTP"),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                  onSubmitted: (pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: verificationCode!, smsCode: pin))
                          .then((value) {
                        if (value.user != null) {
                          return Navigator.push(context,
                              MaterialPageRoute(builder: (builder) {
                            return const HomeScreen();
                          }));
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Invalid OTP"),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
