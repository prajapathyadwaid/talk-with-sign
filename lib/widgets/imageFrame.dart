import 'package:flutter/material.dart';
import 'package:t2/global.dart';

Widget imageFrame(int i) {
  return Container(
    width: width * 0.5,
    height: width * 0.6,
    margin: const EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: const Color.fromARGB(22, 255, 255, 255),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Container(
          width: width * 0.5,
          height: width * 0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/${pTitles[i]}.jpeg"),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: width * 0.12,
          child: Text(
            pTitles[i],
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ],
    ),
  );
}
