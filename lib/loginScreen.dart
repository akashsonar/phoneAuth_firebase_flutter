import 'package:firebase_phone_auth_flutter/OTPService.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String dialCodeDigits = "+91";
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, right: 28),
            child: Image.asset('assets/images/login.jpg'),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Center(
              child: Text(
                "Phone (OTP) Authentication",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 400,
            height: 60,
            child: CountryCodePicker(
              onChanged: (country) {
                setState(() {
                  dialCodeDigits = country.dialCode!.toString();
                });
              },
              initialSelection: "IN",
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Phone Number",
                  prefix: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      dialCodeDigits,
                      style: const TextStyle(color: Colors.black),
                    ),
                  )),
              maxLength: 12,
              keyboardType: TextInputType.number,
              controller: _controller,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OTPService(
                      phone: _controller.text,
                      codeDigits: dialCodeDigits,
                    );
                  }));
                },
                child: const Text(
                  "Next",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
          )
        ],
      )),
    );
  }
}
