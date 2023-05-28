import 'package:countries_flag/countries_flag.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:languagechanger/Storage/storage.dart';
import 'package:languagechanger/main.dart';

import '../Custom/custom_text.dart';
import '../Modal/country.dart';
import '../Service/firebase_auth.dart';
import 'otp.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String country;
  String error = "";
  TextEditingController controller = TextEditingController();
  List<Country> list = [
    Country(name: "India", number: "+91", flag: CountriesFlag(Flags.india)),
    Country(
        name: "USA",
        number: "+1",
        flag: CountriesFlag(Flags.unitedStatesOfAmerica)),
    Country(name: "Nepal", number: "+92", flag: CountriesFlag(Flags.nepal)),
    Country(name: "Japan", number: "+96", flag: CountriesFlag(Flags.japan)),
    Country(name: "Italy", number: "+95", flag: CountriesFlag(Flags.italy)),
  ];
  @override
  void initState() {
    country = list.elementAt(0).number;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(Localizations.localeOf(context).languageCode);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        padding: const EdgeInsets.all(11),
        child: SignUpBody(
          onTap: () {
            Navigator.pop(context);
          },
          controller: controller,
          list: list,
          onChanged: (String? value) {
            setState(() {
              error = "";
              country = value!;
            });
          },
          onPressed: () {
            int len = controller.value.text.length;
            if (len == 10) {
              FirebaseAuths.sendOtp(
                  phone: "$country ${controller.value.text}",
                  verificationCompleted: (PhoneAuthCredential credential) {
                    print("verificationCompleted ${credential.verificationId}");
                  },
                  verificationFailed: (FirebaseAuthException exception) {},
                  codeSent: (String verificationId, int? token) {
                    print("codeSent $verificationId");
                    navigate(
                        context,
                        Otp(
                            phoneNo: "$country${controller.value.text}",
                            verificationId: verificationId,
                            resendToken: token));
                  });
            } else {
              setState(() {
                error = "Enter Valid Number";
              });
            }
          },
          country: country,
          error: error,
          onUpdate: (String? value) {
            setState(() {
              error = "";
            });
          },
        ),
      ),
    );
  }
}

class SignUpBody extends StatelessWidget {
  const SignUpBody(
      {Key? key,
      required this.onTap,
      required this.controller,
      required this.list,
      required this.onChanged,
      required this.onPressed,
      this.country,
      required this.error,
      required this.onUpdate})
      : super(key: key);
  final void Function() onTap;
  final void Function() onPressed;
  final void Function(String? value) onChanged;
  final void Function(String? value) onUpdate;
  final TextEditingController controller;
  final List<Country> list;
  final String? country;
  final String error;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: const Align(
              alignment: Alignment.topLeft,
              child: Icon(FontAwesomeIcons.xmark)),
        ),
        const SizedBox(
          height: 40,
        ),
        CustomText(translate(context).enter_mobile_number,
            color: Colors.black, fontSize: 18),
        const SizedBox(
          height: 10,
        ),
         CustomText(
            translate(context).digit_code_verify),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          // height: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            onChanged: onUpdate,
            onSubmitted: onUpdate,
            decoration: InputDecoration(
                errorText: error == "" ? null : error,
                border: const OutlineInputBorder(),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 35,
                        child: list
                            .firstWhere((element) => element.number == country)
                            .flag,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      DropdownButton<String>(
                        isDense: true,
                        iconSize: 16,
                        underline: const SizedBox(),
                        items: list
                            .map((e) => DropdownMenuItem<String>(
                                value: e.number,
                                child: CustomText(
                                  "${e.number} ",
                                  color: Colors.black,
                                )))
                            .toList(),
                        onChanged: onChanged,
                        value: country,
                      ),
                    ],
                  ),
                ),
                hintText: "Mobile Number"),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              onPressed: onPressed,
              child: const CustomText(
                "Continue",
                color: Colors.white,
              )),
        )
      ],
    );
  }
}
