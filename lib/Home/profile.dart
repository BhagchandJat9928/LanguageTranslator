import 'package:flutter/material.dart';
import 'package:languagechanger/Custom/custom_text.dart';
import 'package:languagechanger/Modal/person.dart';

import '../Storage/storage.dart';
import 'home_page.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String isSelected = "";
  List<Person> list = [];
  @override
  Widget build(BuildContext context) {
    list = [
      Person(
          type: translate(context).shipper,
          desc: "Lorem ipsum dolor sit amet,consectetur adipiscing",
          icon: Icons.home_outlined),
      Person(
          type: translate(context).transporter,
          desc: "Lorem ipsum dolor sit amet, consectetur adipiscing",
          icon: Icons.local_shipping_outlined)
    ];
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.only(top: 80),
          padding: const EdgeInsets.all(11),
          child: ProfileBody(
            isSelected: isSelected,
            onChanged: (String? value) {
              setState(() {
                isSelected = value!;
              });
            },
            list: list,
            onPressed: () {
              if (isSelected != "") {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false);
              }
            },
          )),
    );
  }
}

class ProfileBody extends StatelessWidget {
  const ProfileBody(
      {Key? key,
      required this.isSelected,
      required this.onChanged,
      required this.list,
      required this.onPressed})
      : super(key: key);
  final String isSelected;
  final void Function(String? value) onChanged;
  final void Function() onPressed;
  final List<Person> list;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomText(
          "Please select your profile",
          color: Colors.black,
        ),
        const SizedBox(
          height: 10,
        ),
        RadioList(list: list, onChanged: onChanged, isSelected: isSelected),
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

class RadioList extends StatelessWidget {
  const RadioList(
      {Key? key,
      required this.list,
      required this.onChanged,
      required this.isSelected})
      : super(key: key);
  final List<Person> list;
  final void Function(String? value) onChanged;
  final String isSelected;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Person person = list.elementAt(index);
          return GestureDetector(
            onTap: () {
              onChanged(person.type);
            },
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Radio(
                      value: person.type,
                      groupValue: isSelected,
                      onChanged: onChanged),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    person.icon,
                    size: 24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomText(
                        person.type,
                        fontSize: 18,
                      ),
                      Flexible(
                        flex: 2,
                        child: CustomText(
                          person.desc,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 30,
          );
        },
        itemCount: list.length);
  }
}
