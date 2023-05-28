import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:languagechanger/Service/firebase_auth.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../Custom/custom_text.dart';
import '../Home/profile.dart';
import '../Storage/storage.dart';

class Otp extends StatefulWidget {
  const Otp(
      {Key? key,
      required this.phoneNo,
      required this.verificationId,
      required this.resendToken})
      : super(key: key);
  final String phoneNo;
  final String verificationId;
  final int? resendToken;
  @override
  State<Otp> createState() => _OtpState(phoneNo, verificationId, resendToken);
}

class _OtpState extends State<Otp> {
  _OtpState(this.phoneNo, this.verificationId, resendToken);
  String phoneNo;
  String? error;
  String otp = "";
  String verificationId;
  int? resendToken;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 50),
        padding: const EdgeInsets.all(11),
        child: OtpBody(
          onTap: () {
            Navigator.pop(context);
          },
          onPressed: () async {
            if (otp.length == 6) {
              await FirebaseAuths.verifyOtp(otp, verificationId).then((value) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Profile()),
                    (route) => false);
              }).onError((error, stackTrace) {
                setState(() {
                  error = "Wrong Otp";
                });
              });
            }
          },
          phoneNo: phoneNo,
          error: error,
          onChanged: (String? value) {
            setState(() {
              error = "";
              otp = value!;
            });
          },
          onResendOtp: () {
            setState(() async {
              verificationId = await FirebaseAuths.resendOtp(
                  phoneNo: phoneNo, resendToken: resendToken);
            });
          },
        ),
      ),
    );
  }
}

class OtpBody extends StatelessWidget {
  const OtpBody(
      {Key? key,
      required this.onTap,
      required this.onPressed,
      required this.phoneNo,
      required this.error,
      required this.onChanged,
      required this.onResendOtp})
      : super(key: key);

  final void Function() onTap;
  final void Function() onPressed;
  final void Function(String? value) onChanged;
  final void Function() onResendOtp;
  final String? error;
  final String phoneNo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: const Align(
            alignment: Alignment.topLeft,
            child: Icon(Icons.arrow_back),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        CustomText(
          translate(context).verify_phone,
          color: Colors.black,
          fontSize: 18,
        ),
        const SizedBox(
          height: 10,
        ),
        CustomText("${translate(context).code_sent} $phoneNo"),
        const SizedBox(
          height: 10,
        ),
        OTPTextField(
          length: 6,
          fieldWidth: 40,
          outlineBorderRadius: 2,
          spaceBetween: 5,
          width: 285,
          hasError: error != "" ? true : false,
          otpFieldStyle: OtpFieldStyle(
              backgroundColor: Colors.blue, borderColor: Colors.blue),
          fieldStyle: FieldStyle.box,
          onChanged: onChanged,
          onCompleted: onChanged,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(
          height: 10,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: translate(context).not_receive,
            style: const TextStyle(
              color: Colors.grey,
            ),
            children: <TextSpan>[
              TextSpan(
                text: translate(context).request_again,
                recognizer: TapGestureRecognizer(),
                onEnter: (PointerEnterEvent event) {
                  onResendOtp;
                },
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              onPressed: onPressed,
              child: CustomText(
                "${translate(context).verify} ${translate(context).continues}",
                color: Colors.white,
              )),
        )
      ],
    );
  }
}
