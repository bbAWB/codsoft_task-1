import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/extenstions/space_exs.dart';
import 'package:todo_app/utils/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];
  final List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: AppColors.primaryGradientColor,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
      child: Column(children: [
        const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              "https://images.unsplash.com/photo-1703163015032-949f08e5fd8f?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            )),
        8.h,
        Text("Blen Bete", style: textTheme.displayMedium),
        Text("Flutter dev", style: textTheme.displaySmall),
        Expanded(
            child: ListView.builder(
                itemCount: icons.length,
                itemBuilder: (BuildContext constext, int index) {
                  return InkWell(
                    onTap: () {
                      log('${texts[index]} Item Tappped');
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      child: ListTile(
                          leading: Icon(
                            icons[index],
                            color: Colors.white,
                            size: 30,
                          ),
                          title: Text(texts[index],
                              style: const TextStyle(color: Colors.white))),
                    ),
                  );
                })),
      ]),
    );
  }
}
