import 'package:flutter/material.dart';

import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

class WebViewContent extends StatefulWidget {
  const WebViewContent({Key? key}) : super(key: key);

  @override
  WebViewContentState createState() => WebViewContentState();
}

class WebViewContentState extends State<WebViewContent> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)?.settings.arguments.toString());
    return WebView(
      initialUrl: ModalRoute.of(context)?.settings.arguments.toString(),
    );
  }
}
