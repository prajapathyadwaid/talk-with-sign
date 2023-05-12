import 'package:flutter/material.dart';
import 'package:t2/global.dart';
import 'package:t2/widgets/imageFrame.dart';
import 'package:t2/widgets/videoFrame.dart';

Widget educateTab() {
  return Drawer(
    backgroundColor: const Color.fromARGB(255, 18, 18, 18),
    width: width,
    child: Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 25, left: 10),
          height: 95,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12))),
          child: const Text(
            "Talk With Sign",
            style: TextStyle(
                fontFamily: "vibes", fontSize: 27, color: Colors.black87),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: false,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(10),
                child: const Text(
                  "Basic Signs",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: width - 10,
                height: width * 0.62,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  for (int i = 0; i < pTitles.length; i++) imageFrame(i),
                ]),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(10),
                child: const Text(
                  "Related Videos",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
              for (int i = 0; i < links.length; i++) videoFrame(i)
            ],
          ),
        ),
      ],
    ),
  );
}
