import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_news/screens/dashboard.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late List news;
  var response;
  var data;
  var url =
      "https://newsapi.org/v2/top-headlines?country=in&apiKey=47f4287bd2824fa4a835a267455e0546";

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    response = await http.get(Uri.parse(url));
    data = jsonDecode(response.body);

    news = data["articles"];

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(
                  news: news,
                )));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.red));
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/news.json"),
          RichText(
            text: const TextSpan(
                text: "Flutter",
                style: TextStyle(fontSize: 40, color: Colors.black),
                children: [
                  TextSpan(
                    text: " News",
                    style: TextStyle(color: Colors.red),
                  )
                ]),
          )
        ],
      ),
    );
  }
}
