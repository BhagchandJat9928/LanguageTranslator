import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:languagechanger/Custom/language_translation.dart';

import 'SignUp/signup.dart';
import 'Storage/storage.dart';
import 'firebase_options.dart';

late FirebaseAuth auth;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.playIntegrity,
  );
  auth = FirebaseAuth.instance;
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

void navigate(BuildContext context, Widget widget) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((value) => setLocale(value!));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: LanguageTranslation.keys.entries.map((e) => e.value),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropDownValue = 'English';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).size.height * .15,
              bottom: MediaQuery.of(context).size.height * .80,
              child: const Icon(
                Icons.image,
                size: 60,
                color: Colors.black,
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).size.height * .26,
              bottom: MediaQuery.of(context).size.height * .70,
              child: const Text(
                "Please Select Your Language",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).size.height * .30,
              bottom: MediaQuery.of(context).size.height * .63,
              child: const Text(
                "You can change the language \nat any time",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * .20,
              right: MediaQuery.of(context).size.width * .20,
              top: MediaQuery.of(context).size.height * .38,
              bottom: MediaQuery.of(context).size.height * .56,
              child: Container(
                height: 47,
                width: MediaQuery.of(context).size.width * .70,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all()),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropDownValue,
                  underline: const SizedBox(),
                  items: LanguageTranslation.keys.entries
                      .map<DropdownMenuItem<String>>((e) =>
                          DropdownMenuItem<String>(
                              value: e.key, child: Text(e.key)))
                      .toList(),
                  onChanged: (String? val) {
                    setState(() {
                      dropDownValue = val!;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * .20,
              right: MediaQuery.of(context).size.width * .20,
              top: MediaQuery.of(context).size.height * .46,
              bottom: MediaQuery.of(context).size.height * .47,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * .70,
                child: ElevatedButton(
                    onPressed: () {
                      /* Localizations.override(
                        context: context,
                        locale: LanguageTranslation.keys[dropDownValue],
                      );*/
                      setLocale(dropDownValue)
                          .then((value) => MyApp.setLocale(context, value!));
                      navigate(context, const SignUp());
                    },
                    child: const Text("Next",
                        style: TextStyle(
                          color: Colors.white,
                        ))),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.of(context).size.height - 100,
                bottom: 0,
                child: CustomPaint(
                  painter: Waves1(),
                )),
            /*Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.of(context).size.height - 100,
                bottom: 0,
                child: CustomPaint(
                  painter: Waves2(),
                )),*/
          ],
        ),
      ),
    );
  }
}

class Waves1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint1 = Paint()
      ..color = Colors.lightBlueAccent.shade100
      ..strokeWidth = 1;
    Path path = Path();
    path.moveTo(0, size.height * .25);
    path.arcToPoint(Offset(size.width * .25, size.height * .25),
        radius: Radius.circular(size.height * .25), clockwise: true);
    path.arcToPoint(Offset(size.width * .50, size.height * .25),
        largeArc: true,
        radius: Radius.circular(size.height * .25),
        clockwise: false);
    path.arcToPoint(Offset(size.width * .75, size.height * .25),
        largeArc: false,
        radius: Radius.circular(size.height * .25),
        clockwise: true);
    path.arcToPoint(Offset(size.width, size.height * .25),
        largeArc: true,
        radius: Radius.circular(size.height * .25),
        clockwise: false);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Waves2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint1 = Paint()
      ..color = Colors.blueGrey.shade300
      ..strokeWidth = 1;
    Path path = Path();
    path.moveTo(0, 0);
    path.arcToPoint(Offset(size.width * .25, size.height * .25),
        largeArc: true,
        radius: Radius.circular(size.height * .25),
        clockwise: false);
    path.arcToPoint(Offset(size.width * .50, size.height * .25),
        largeArc: true,
        radius: Radius.circular(size.height * .25),
        clockwise: true);
    path.arcToPoint(Offset(size.width * .75, size.height * .25),
        largeArc: false,
        radius: Radius.circular(size.height * .25),
        clockwise: false);
    path.arcToPoint(Offset(size.width, size.height * .25),
        largeArc: true,
        radius: Radius.circular(size.height * .25),
        clockwise: true);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
