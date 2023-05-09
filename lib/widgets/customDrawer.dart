import 'package:flutter/material.dart';
import 'package:t2/global.dart';

Widget customDrawer() {
  return Drawer(
    backgroundColor: Color.fromARGB(255, 18, 18, 18),
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
              fontFamily: "vibes",
                fontSize: 27,
                
                color: Colors.black87),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: TextFormField(textAlign: TextAlign.left,
              controller: txtController1,
              decoration: const InputDecoration(hintText: "Start talking with sign..",hintStyle: TextStyle(color: Colors.white24),
              
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  fillColor: Color.fromARGB(12, 255, 255, 255),
                  border: InputBorder.none,
                  filled: true),
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.white),
              readOnly: true,
              maxLines: null,
            ),
          ),
        ),
      
      ],
    ),
  );
}
