import 'package:flutter/material.dart';
import 'package:flutter_news/screens/webview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  final List news;
  const Dashboard({Key? key, required this.news}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

final List<String> _choices = [
  "headlines",
  "business",
  "entertainment",
  "general",
  "health",
  "science",
  "sports",
  "technology",
];

int _defaultChoiceIndex = 0;

class _DashboardState extends State<Dashboard> {
  Widget choiceChip(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: ChoiceChip(
        label: Text(_choices[index]),
        selected: _defaultChoiceIndex == index,
        selectedColor: Colors.red,
        onSelected: (bool selected) {
          setState(() {
            _defaultChoiceIndex = (selected ? index : null)!;
            newsFetch(_choices[index]);
          });
        },
        backgroundColor: Colors.blueGrey.shade300,
        pressElevation: 10,
        labelStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
      ),
    );
  }

  List lol = [];
  @override
  Widget build(BuildContext context) {
    List news = widget.news;
    lol = news;

    return Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Flutter News",
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            const SizedBox(
              width: 8,
            )
          ],
        ),
        drawer: const Drawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              newsChoice(),
              lol.isEmpty
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const Center(child: CircularProgressIndicator()))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: 8,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        String datetime = lol[index]["publishedAt"];
                        DateTime now = DateTime.parse(datetime);
                        String time = DateFormat.jm().format(now);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: newsCard(index, news, time),
                        );
                      })
            ],
          ),
        ));
  }

  Widget newsCard(int index, List news, String time) {
    return InkWell(
      child: Ink(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                lol[index]["urlToImage"],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              lol[index]["title"],
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(lol[index]["source"]["name"],
                style: GoogleFonts.robotoMono(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  time,
                  style: GoogleFonts.roboto(color: Colors.grey, fontSize: 14),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.share_outlined)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert_outlined)),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WebViewContent(),
                settings: RouteSettings(arguments: lol[index]["url"])));
      },
    );
  }

  void newsFetch(String choice) async {
    setState(() {
      lol.clear();
    });
    var url = "";
    if (choice == "headlines") {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&apiKey=47f4287bd2824fa4a835a267455e0546";
    } else {
      url =
          "https://newsapi.org/v2/everything?q=${choice.toLowerCase()}&apiKey=47f4287bd2824fa4a835a267455e0546";
    }

    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);

    var myNews = data["articles"];

    setState(() {
      lol.clear();
      lol.addAll(myNews);
    });
  }

  Container newsChoice() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.20,
      color: Colors.white,
      child: Wrap(
        children: [
          choiceChip(0),
          choiceChip(1),
          choiceChip(2),
          choiceChip(3),
          choiceChip(4),
          choiceChip(5),
          choiceChip(6),
          choiceChip(7),
        ],
      ),
    );
  }
}
