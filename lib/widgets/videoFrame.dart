import 'package:t2/global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

Widget videoFrame(int i) {

  return 
  
  
  GestureDetector(
    onTap:() {
    launchUrl(Uri.parse("https://www.youtube.com/watch?v=${links[i]}"),mode: LaunchMode.externalApplication);
    },
    child: Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Color.fromARGB(22, 255, 255, 255),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: width ,
      margin:const EdgeInsets.all(5),
      height: width * 0.25,
      child: Row(
        children: [
          Container(
              width: width * 0.38,
              height: width * 0.25,
              decoration:  BoxDecoration(
                image: DecorationImage(image: NetworkImage("https://img.youtube.com/vi/${links[i]}/0.jpg",),fit: BoxFit.fill
                ) ,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              )),
          Container(
            width: width * 0.62 - 10,
            height: width * 0.25,
            
            padding: const EdgeInsets.only(left: 10),alignment: Alignment.centerLeft,
            child: Text(titles[i],style: const TextStyle(color: Colors.white),),
            
          )
        ],
      ),
    ),
  );
}