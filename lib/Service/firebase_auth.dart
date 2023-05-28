import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

class FirebaseAuths {
  static void sendOtp(
      {required String phone,
      required void Function(PhoneAuthCredential phoneAuthCredential)
          verificationCompleted,
      required void Function(FirebaseAuthException ex) verificationFailed,
      required void Function(String verificationId, int? resendToken)
          codeSent}) async {
    await auth.verifyPhoneNumber(
        timeout: const Duration(minutes: 1),
        phoneNumber: phone,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String timeout) {});
  }

  static Future<String> resendOtp(
      {required String phoneNo, int? resendToken}) async {
    String verificationId = "";
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credential) {
          print(credential.smsCode);
        },
        timeout: const Duration(seconds: 60),
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
          //  verificationId=exception.message!;
        },
        codeSent: (String code, val) {
          print("String $code int  $val");

          verificationId = code;
        },
        codeAutoRetrievalTimeout: (code) {
          print("auto $code");
        });
    return verificationId;
  }

  static Future<UserCredential> verifyOtp(
      String smsCode, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    return await auth.signInWithCredential(credential);
    /*on FirebaseAuthException catch (e) {
      SnackBar(
        content: SmallText("${e.message}"),
        padding: EdgeInsets.all(11),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
      );
    }*/
  }
}
